#!/usr/bin/env bash
# Create (or report) the DMS source and target endpoints for one MySQL-family
# migration path. Run from the repo root after the design freeze:
#
#   ENGAGEMENT=<engagement> scripts/create-dms-endpoints.sh
#
# All inputs come from engagements/<engagement>/configs/dms-endpoints.inputs.env
# (non-secret identifiers only) plus the target stack's outputs:
#   AWS_REGION            region of the target stack
#   TARGET_STACK_NAME     CloudFormation stack built from target-mysql-dms.yaml
#   SOURCE_SSM_PREFIX     Parameter Store path holding the source details:
#                         <prefix>/host, <prefix>/port, <prefix>/secret_arn
#   SOURCE_ENGINE         DMS source engine name (mysql, sqlserver, azuredb, ...)
#   SOURCE_DB_NAME        source database name
#   TARGET_DB_NAME        target database name (defaults to the stack's DbName)
#   DMS_SSL_MODE          none | require | verify-ca | verify-full
#   ENDPOINT_PREFIX       identifier prefix, e.g. <engagement>-rehearsal
#   DISABLE_TARGET_FK_CHECKS  true when the target schema is pre-created with FKs
#                         and the task truncates rather than recreates tables
#
# Credentials: read from Secrets Manager at run time and passed to DMS through a
# 0600 temp file in RAM, deleted when the call returns. They never appear on a
# command line, in the repo or in this script's output.
#
# Safe to re-run: existing endpoints are reported, not recreated.
# Writes: two DMS endpoints, then engagements/<engagement>/configs/dms-endpoints.env
# (ARNs only). With a provisioned replication instance it also runs DMS's
# connection test on both and stops on the first failure.
set -euo pipefail
case "$-" in *x*) set +x ;; esac

: "${ENGAGEMENT:?Set ENGAGEMENT to the folder name under engagements/}"
ENG_DIR="engagements/$ENGAGEMENT"
INPUTS="$ENG_DIR/configs/dms-endpoints.inputs.env"
[ -f "$INPUTS" ] || { echo "ERROR: $INPUTS not found; copy configs/dms-endpoints.inputs.env.template" >&2; exit 1; }
# shellcheck disable=SC1090
source "$INPUTS"

for v in AWS_REGION TARGET_STACK_NAME SOURCE_SSM_PREFIX SOURCE_ENGINE SOURCE_DB_NAME DMS_SSL_MODE ENDPOINT_PREFIX; do
  [ -n "${!v:-}" ] || { echo "ERROR: $v is empty in $INPUTS" >&2; exit 1; }
done
case "$DMS_SSL_MODE" in none|require|verify-ca|verify-full) ;; *) echo "ERROR: bad DMS_SSL_MODE" >&2; exit 1 ;; esac
export AWS_DEFAULT_REGION="$AWS_REGION"
SECRET_TMP="/dev/shm"; [ -d "$SECRET_TMP" ] && [ -w "$SECRET_TMP" ] || SECRET_TMP="${TMPDIR:-/tmp}"

say() { printf '%s\n' "$*"; }
fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

say "Caller: $(aws sts get-caller-identity --query Arn --output text)"
say "Region: $AWS_REGION  Stack: $TARGET_STACK_NAME"

ssm() { aws ssm get-parameter --name "$SOURCE_SSM_PREFIX/$1" --query Parameter.Value --output text; }
out() { aws cloudformation describe-stacks --stack-name "$TARGET_STACK_NAME" \
          --query "Stacks[0].Outputs[?OutputKey=='$1'].OutputValue | [0]" --output text; }

SRC_HOST="$(ssm host)"; SRC_PORT="$(ssm port)"; SRC_SECRET="$(ssm secret_arn)"
TGT_HOST="$(out DbEndpoint)"; TGT_PORT="$(out DbPort)"; TGT_SECRET="$(out DbSecretArn)"
FLAVOUR="$(out DatabaseFlavorChosen)"; REPL_INSTANCE="$(out DmsReplicationInstanceArn)"
TARGET_DB_NAME="${TARGET_DB_NAME:-$(out DbName)}"
[ "$TGT_HOST" != "None" ] || fail "stack $TARGET_STACK_NAME has no DbEndpoint output; is it CREATE_COMPLETE?"

case "$FLAVOUR" in
  aurora-mysql) TGT_ENGINE="aurora" ;;
  rds-mysql)    TGT_ENGINE="mysql" ;;
  *) fail "unexpected DatabaseFlavorChosen '$FLAVOUR'" ;;
esac

endpoint_arn() {
  aws dms describe-endpoints --filters "Name=endpoint-id,Values=$1" \
    --query 'Endpoints[0].EndpointArn' --output text 2>/dev/null || true
}

# create_endpoint <id> <source|target> <engine> <host> <port> <db> <secret-arn>
create_endpoint() {
  local id="$1" type="$2" engine="$3" host="$4" port="$5" db="$6" secret="$7" arn req ok=1
  arn="$(endpoint_arn "$id")"
  if [[ "$arn" == arn:* ]]; then
    say "$type endpoint $id already exists - not recreated" >&2
  else
    req="$(umask 077; mktemp "${SECRET_TMP}/dms-endpoint.XXXXXX")"
    aws secretsmanager get-secret-value --secret-id "$secret" --query SecretString --output text |
      python3 -I -c '
import json, sys
s = json.load(sys.stdin)
i, t, e, h, p, d, ssl, eng, fk = sys.argv[1:10]
req = {"EndpointIdentifier": i, "EndpointType": t, "EngineName": e,
       "ServerName": h, "Port": int(p), "DatabaseName": d,
       "Username": s.get("username") or s["user"], "Password": s["password"],
       "SslMode": ssl,
       "Tags": [{"Key": "cq:engagement", "Value": eng}]}
if t == "target" and fk == "true":
    # DMS loads tables in parallel with no parent-before-child order.
    req["ExtraConnectionAttributes"] = "initstmt=SET FOREIGN_KEY_CHECKS=0"
print(json.dumps(req))
' "$id" "$type" "$engine" "$host" "$port" "$db" "$DMS_SSL_MODE" "$ENGAGEMENT" "${DISABLE_TARGET_FK_CHECKS:-false}" > "$req" &&
    aws dms create-endpoint --cli-input-json "file://$req" --query Endpoint.EndpointArn --output text >/dev/null || ok=0
    rm -f "$req"
    [ "$ok" = 1 ] || fail "could not create $type endpoint $id (see the AWS error above)"
    arn="$(endpoint_arn "$id")"
    [[ "$arn" == arn:* ]] || fail "could not create $type endpoint $id"
    say "$type endpoint $id created" >&2
  fi
  printf '%s' "$arn"
}

SRC_ARN="$(create_endpoint "${ENDPOINT_PREFIX}-src" source "$SOURCE_ENGINE" "$SRC_HOST" "$SRC_PORT" "$SOURCE_DB_NAME" "$SRC_SECRET")"
TGT_ARN="$(create_endpoint "${ENDPOINT_PREFIX}-tgt" target "$TGT_ENGINE" "$TGT_HOST" "$TGT_PORT" "$TARGET_DB_NAME" "$TGT_SECRET")"

if [[ "$REPL_INSTANCE" == arn:* ]]; then
  say "Testing both connections from the replication instance..."
  for ep in "$SRC_ARN" "$TGT_ARN"; do
    aws dms test-connection --replication-instance-arn "$REPL_INSTANCE" --endpoint-arn "$ep" >/dev/null 2>&1 || true
  done
  for ep in "$SRC_ARN" "$TGT_ARN"; do
    st="testing"
    for _ in $(seq 1 40); do
      st="$(aws dms describe-connections --filters "Name=endpoint-arn,Values=$ep" \
              --query 'Connections[0].Status' --output text)"
      [ "$st" = "testing" ] || break
      sleep 5
    done
    msg="$(aws dms describe-connections --filters "Name=endpoint-arn,Values=$ep" \
             --query 'Connections[0].LastFailureMessage' --output text)"
    [ "$st" = "successful" ] || fail "connection test for $ep: $st - $msg
  This script never changes an existing endpoint. Fix the cause, delete it
  (aws dms delete-endpoint --endpoint-arn $ep) and run again."
    say "Connection test passed: $ep"
  done
else
  say "No replication instance (Serverless): DMS tests connections itself once capacity is ready."
fi

mkdir -p "$ENG_DIR/configs"
printf 'SOURCE_ENDPOINT_ARN=%s\nTARGET_ENDPOINT_ARN=%s\n' "$SRC_ARN" "$TGT_ARN" > "$ENG_DIR/configs/dms-endpoints.env"
say "SOURCE_ENDPOINT_ARN=$SRC_ARN"
say "TARGET_ENDPOINT_ARN=$TGT_ARN"
say "Wrote $ENG_DIR/configs/dms-endpoints.env (ARNs only, no secrets)."
