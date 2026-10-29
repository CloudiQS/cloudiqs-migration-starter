#!/usr/bin/env bash
# Capture DMS validation evidence without printing or persisting credentials.
#
# Run from the repo root with ENGAGEMENT set, one phase at a time:
#   ENGAGEMENT=<engagement> scripts/capture-dms-validation-evidence.sh <phase>
# Phases:
#   baseline | preflight | inflight | reconcile | smoke | rollback-readiness
#
# The companion context file holds identifiers and secret ARNs only. Secret
# values are resolved in memory for aggregate SQL queries, then unset. This
# runner never starts, stops, modifies, or deletes a DMS task, endpoint, stack,
# database, or application.
set -euo pipefail
case "$-" in *x*) set +x ;; esac
umask 077

PHASE="${1:-}"
case "$PHASE" in
  baseline|preflight|inflight|reconcile|smoke|rollback-readiness) ;;
  *)
    echo "Usage: $0 {baseline|preflight|inflight|reconcile|smoke|rollback-readiness}" >&2
    exit 2
    ;;
esac

SCRIPT_DIR="$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(CDPATH="" cd -- "$SCRIPT_DIR/.." && pwd)"
: "${ENGAGEMENT:?Set ENGAGEMENT to the folder name under engagements/}"
ENGAGEMENT_DIR="$REPO_ROOT/engagements/$ENGAGEMENT"
[ -d "$ENGAGEMENT_DIR" ] || { echo "ERROR: $ENGAGEMENT_DIR does not exist" >&2; exit 1; }
CONTEXT_FILE="${DMS_VALIDATION_CONTEXT:-$ENGAGEMENT_DIR/configs/dms-validation-context.env}"
EVIDENCE_DIR="${DMS_EVIDENCE_DIR:-$ENGAGEMENT_DIR/evidence/dms}"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_var() {
  local name="$1"
  [ -n "${!name:-}" ] || fail "Required context value is empty: $name"
}

require_file() {
  [ -f "$1" ] || fail "Required file does not exist: $1"
}

utc_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

safe_stem() {
  printf '%s' "$(utc_now)" | tr ':+' '--'
}

record_context() {
  local path="$1"
  {
    printf 'captured_at=%s\n' "$(utc_now)"
    printf 'phase=%s\n' "$PHASE"
    printf 'aws_region=%s\n' "${AWS_REGION:-}"
    printf 'dms_task_arn=%s\n' "${DMS_TASK_ARN:-}"
    printf 'source_endpoint_arn=%s\n' "${SOURCE_ENDPOINT_ARN:-}"
    printf 'target_endpoint_arn=%s\n' "${TARGET_ENDPOINT_ARN:-}"
    printf 'source_db_host=%s\n' "${SOURCE_DB_HOST:-}"
    printf 'source_db_name=%s\n' "${SOURCE_DB_NAME:-}"
    printf 'source_db_secret_arn=%s\n' "${SOURCE_DB_SECRET_ARN:-}"
    printf 'target_db_host=%s\n' "${TARGET_DB_HOST:-}"
    printf 'target_db_name=%s\n' "${TARGET_DB_NAME:-}"
    printf 'target_db_secret_arn=%s\n' "${TARGET_DB_SECRET_ARN:-}"
    printf 'target_app_base_url=%s\n' "${TARGET_APP_BASE_URL:-}"
    printf 'rollback_owner=%s\n' "${ROLLBACK_OWNER:-}"
    printf 'rollback_rto=%s\n' "${ROLLBACK_RTO:-}"
    printf 'cdc_evidence_path=%s\n' "${CDC_EVIDENCE_PATH:-NOT PROVIDED}"
  } > "$path"
}

secret_field() {
  local secret_json="$1"
  shift
  printf '%s' "$secret_json" | python3 -c '
import json
import sys
secret = json.load(sys.stdin)
for key in sys.argv[1:]:
    value = secret.get(key)
    if value not in (None, ""):
        print(value, end="")
        break
else:
    raise SystemExit("secret is missing one of: " + ", ".join(sys.argv[1:]))
' "$@"
}

run_aggregate_queries() {
  local role="$1"
  local host="$2"
  local port="$3"
  local database="$4"
  local secret_arn="$5"
  local query_file="$6"
  local output_file="$7"
  local secret_json db_user db_password

  require_file "$query_file"
  secret_json="$(aws secretsmanager get-secret-value --region "$AWS_REGION" --secret-id "$secret_arn" --query SecretString --output text)"
  db_user="$(secret_field "$secret_json" username user)"
  db_password="$(secret_field "$secret_json" password)"

  # MYSQL_PWD is process-local. Do not use --password or create a defaults file.
  # --skip-column-names: MySQL would otherwise print a header line for every
  # query in the file; write one fixed header instead.
  printf 'tbl\tmetric\tvalue\n' > "$output_file"
  MYSQL_PWD="$db_password" mysql --protocol=TCP --host="$host" --port="$port" \
    --user="$db_user" --database="$database" --batch --raw --skip-column-names < "$query_file" >> "$output_file"
  unset secret_json db_user db_password
  printf 'role=%s\nquery_file=%s\ncaptured_at=%s\n' "$role" "$query_file" "$(utc_now)" \
    > "${output_file}.metadata"
}

capture_task() {
  local output_file="$1"
  aws dms describe-replication-tasks --region "$AWS_REGION" \
    --filters "Name=replication-task-arn,Values=$DMS_TASK_ARN" \
    --output json > "$output_file"
}

capture_table_statistics() {
  local output_file="$1"
  aws dms describe-table-statistics --region "$AWS_REGION" \
    --replication-task-arn "$DMS_TASK_ARN" --output json > "$output_file"
}

# Print how many orders the /orders response holds, or -1 if it is not JSON the
# check understands. The dispatch API returns a Spring Data page
# ({"content":[...],"totalElements":N,...}; newer Spring nests the count under
# "page"), so an empty, unmigrated target is NOT the literal `[]`: comparing raw
# text would report it as migrated. A plain JSON array is also accepted.
orders_count() {
  python3 - "$1" <<'ORDERS_PY'
import json, sys
try:
    with open(sys.argv[1]) as fh:
        body = json.load(fh)
except (OSError, ValueError):
    print(-1)
    raise SystemExit
if isinstance(body, list):
    print(len(body))
elif isinstance(body, dict):
    total = body.get("totalElements", (body.get("page") or {}).get("totalElements"))
    if isinstance(total, int):
        print(total)
    elif isinstance(body.get("content"), list):
        print(len(body["content"]))
    else:
        print(-1)
else:
    print(-1)
ORDERS_PY
}

run_smoke() {
  local base_url="$1"
  local health_body="$2"
  local orders_body="$3"
  local summary="$4"
  local health_status orders_status orders_total

  case "$base_url" in
    http://*|https://*) ;;
    *) fail "TARGET_APP_BASE_URL must start with http:// or https://" ;;
  esac
  case "$base_url" in *"@"*) fail "TARGET_APP_BASE_URL must not contain credentials" ;; esac

  health_status="$(curl --silent --show-error --location --output "$health_body" --write-out '%{http_code}' \
    --connect-timeout 10 --max-time 30 "$base_url${SMOKE_HEALTH_PATH:-/actuator/health}")"
  orders_status="$(curl --silent --show-error --location --output "$orders_body" --write-out '%{http_code}' \
    --connect-timeout 10 --max-time 30 "$base_url${SMOKE_DATA_PATH:-/orders}")"
  orders_total="$(orders_count "$orders_body")"

  {
    printf 'captured_at=%s\n' "$(utc_now)"
    printf 'health_http_status=%s\n' "$health_status"
    printf 'orders_http_status=%s\n' "$orders_status"
    printf 'health_body_contains_up=%s\n' "$(grep -q 'UP' "$health_body" && echo true || echo false)"
    printf 'orders_total=%s\n' "$orders_total"
    printf 'orders_body_is_nonempty=%s\n' "$( [ "$orders_total" -gt 0 ] && echo true || echo false)"
  } > "$summary"

  [ "$health_status" = "200" ] && grep -q 'UP' "$health_body" \
    || fail "Health smoke did not return HTTP 200 with UP; inspect $health_body"
  [ "$orders_total" -ge 0 ] \
    || fail "Orders smoke returned a body this check cannot read as JSON orders; inspect $orders_body"
  [ "$orders_status" = "200" ] && [ "$orders_total" -gt 0 ] \
    || fail "Orders smoke did not return migrated data (orders_total=$orders_total); inspect $orders_body"
}

require_file "$CONTEXT_FILE"
# The operator supplies this non-secret context file.
# shellcheck disable=SC1090
source "$CONTEXT_FILE"
for forbidden in SOURCE_DB_PASSWORD TARGET_DB_PASSWORD SOURCE_DB_USERNAME TARGET_DB_USERNAME SOURCE_DB_USER TARGET_DB_USER MYSQL_PWD; do
  [ -z "${!forbidden:-}" ] || fail "$forbidden must not be stored in the context file"
done

mkdir -p "$EVIDENCE_DIR"
STAMP="$(safe_stem)"
record_context "$EVIDENCE_DIR/${STAMP}-${PHASE}-context.txt"

case "$PHASE" in
  baseline)
    require_var AWS_REGION
    require_var SOURCE_DB_HOST
    require_var SOURCE_DB_PORT
    require_var SOURCE_DB_NAME
    require_var SOURCE_DB_SECRET_ARN
    QUERY_FILE="${VALIDATION_QUERY_FILE:-scripts/validation-queries.sql}"
    case "$QUERY_FILE" in /*) ;; *) QUERY_FILE="$ENGAGEMENT_DIR/$QUERY_FILE" ;; esac
    run_aggregate_queries source "$SOURCE_DB_HOST" "$SOURCE_DB_PORT" "$SOURCE_DB_NAME" \
      "$SOURCE_DB_SECRET_ARN" "$QUERY_FILE" "$EVIDENCE_DIR/${STAMP}-baseline-source.tsv"
    ;;
  preflight)
    require_var AWS_REGION
    require_var DMS_TASK_ARN
    require_var SOURCE_ENDPOINT_ARN
    require_var TARGET_ENDPOINT_ARN
    capture_task "$EVIDENCE_DIR/${STAMP}-preflight-task.json"
    ;;
  inflight)
    require_var AWS_REGION
    require_var DMS_TASK_ARN
    capture_task "$EVIDENCE_DIR/${STAMP}-inflight-task.json"
    capture_table_statistics "$EVIDENCE_DIR/${STAMP}-inflight-table-statistics.json"
    ;;
  reconcile)
    require_var AWS_REGION
    require_var DMS_TASK_ARN
    require_var TARGET_DB_HOST
    require_var TARGET_DB_PORT
    require_var TARGET_DB_NAME
    require_var TARGET_DB_SECRET_ARN
    QUERY_FILE="${VALIDATION_QUERY_FILE:-scripts/validation-queries.sql}"
    case "$QUERY_FILE" in /*) ;; *) QUERY_FILE="$ENGAGEMENT_DIR/$QUERY_FILE" ;; esac
    capture_task "$EVIDENCE_DIR/${STAMP}-reconcile-task.json"
    capture_table_statistics "$EVIDENCE_DIR/${STAMP}-reconcile-table-statistics.json"
    run_aggregate_queries target "$TARGET_DB_HOST" "$TARGET_DB_PORT" "$TARGET_DB_NAME" \
      "$TARGET_DB_SECRET_ARN" "$QUERY_FILE" "$EVIDENCE_DIR/${STAMP}-reconcile-target.tsv"
    ;;
  smoke)
    require_var TARGET_APP_BASE_URL
    run_smoke "$TARGET_APP_BASE_URL" "$EVIDENCE_DIR/${STAMP}-smoke-health.body" \
      "$EVIDENCE_DIR/${STAMP}-smoke-orders.body" "$EVIDENCE_DIR/${STAMP}-smoke-summary.txt"
    ;;
  rollback-readiness)
    require_var AWS_REGION
    require_var DMS_TASK_ARN
    require_var ROLLBACK_OWNER
    require_var ROLLBACK_RTO
    capture_task "$EVIDENCE_DIR/${STAMP}-rollback-readiness-task.json"
    {
      printf '# Rollback readiness record\n\n'
      printf -- '- Captured at: `%s`\n' "$(utc_now)"
      printf -- '- Rollback owner: `%s`\n' "$ROLLBACK_OWNER"
      printf -- '- Approved RTO: `%s`\n' "$ROLLBACK_RTO"
      printf -- '- DMS task status evidence: `%s`\n' "${STAMP}-rollback-readiness-task.json"
      printf -- '- Action performed: no service was started, stopped, modified, or deleted.\n'
      printf -- '- Remaining rehearsal or approval action: `%s`\n' "${CDC_EVIDENCE_PATH:-record before GO/NO-GO}"
    } > "$EVIDENCE_DIR/${STAMP}-rollback-readiness.md"
    ;;
esac

echo "Captured $PHASE evidence under $EVIDENCE_DIR"
