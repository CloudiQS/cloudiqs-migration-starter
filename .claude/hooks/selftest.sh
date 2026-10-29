#!/usr/bin/env bash
# Self-test for the freeze gate and DMS config hooks. Exit 0 only if every case behaves.
set -uo pipefail
ROOT="$(CDPATH="" cd -- "$(dirname -- "$0")/../.." && pwd)"
export CLAUDE_PROJECT_DIR="$ROOT"
GATE="python3 $ROOT/.claude/hooks/freeze-gate.py"
DMS="python3 $ROOT/.claude/hooks/validate-dms-task-config.py"
pass=0; failn=0
check() { # <name> <expected-exit> <hook> <json>
  printf '%s' "$4" | $3 >/dev/null 2>&1; got=$?
  if [ "$got" = "$2" ]; then pass=$((pass+1)); echo "ok   $1"; else failn=$((failn+1)); echo "FAIL $1 (exit $got, want $2)"; fi
}
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
echo '{"ValidationSettings":{"ThreadCount":5}}' > "$TMP/bad-task-settings.json"
echo '{"ValidationSettings":{"EnableValidation":true},"TargetMetadata":{"TargetSchema":""}}' > "$TMP/good-task-settings.json"
echo '{"ValidationSettings":{"EnableValidation":true},"ChangeProcessingTuning":{}}' > "$TMP/azuresqldb-fl-task-settings.json"

check "read-only aws passes"            0 "$GATE" '{"tool_name":"Bash","tool_input":{"command":"aws sts get-caller-identity"}}'
check "write with no engagement blocks" 2 "$GATE" '{"tool_name":"Bash","tool_input":{"command":"aws cloudformation deploy --stack-name x"}}'
check "template not frozen blocks"      2 "$GATE" '{"tool_name":"Bash","tool_input":{"command":"ENGAGEMENT=_template aws dms create-endpoint --x y"}}'
check "frozen reference deploy passes"  0 "$GATE" '{"tool_name":"Bash","tool_input":{"command":"ENGAGEMENT=acme-reference aws cloudformation deploy --stack-name x"}}'
check "edit frozen design blocks"       2 "$GATE" "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$ROOT/engagements/acme-reference/spec/design.md\"}}"
check "edit tasks after freeze passes"  0 "$GATE" "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$ROOT/engagements/acme-reference/spec/tasks.md\"}}"
check "edit unfrozen design passes"     0 "$GATE" "{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"$ROOT/engagements/_template/spec/design.md\"}}"
check "dms missing validation fails"    2 "$DMS"  "{\"tool_input\":{\"file_path\":\"$TMP/bad-task-settings.json\"}}"
check "dms good settings passes"        0 "$DMS"  "{\"tool_input\":{\"file_path\":\"$TMP/good-task-settings.json\"}}"
check "full-load-only with CDC fails"   2 "$DMS"  "{\"tool_input\":{\"file_path\":\"$TMP/azuresqldb-fl-task-settings.json\"}}"
check "shipped task settings pass"      0 "$DMS"  "{\"tool_input\":{\"file_path\":\"$ROOT/configs/dms-task-settings.json\"}}"
echo "$pass passed, $failn failed"; [ "$failn" = 0 ]
