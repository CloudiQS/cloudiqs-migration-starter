#!/usr/bin/env bash
# Watch a DMS replication task: status, full-load progress, validation state.
# Read-only. Usage: scripts/watch-task.sh <replication-task-arn> [interval-seconds]
# Region comes from AWS_REGION (never hardcoded).
set -euo pipefail
TASK_ARN="${1:?usage: watch-task.sh <task-arn> [interval]}"
: "${AWS_REGION:?Set AWS_REGION}"
INTERVAL="${2:-30}"
while true; do
  aws dms describe-replication-tasks --region "$AWS_REGION" \
    --filters "Name=replication-task-arn,Values=$TASK_ARN" \
    --query 'ReplicationTasks[0].{status:Status,progress:ReplicationTaskStats.FullLoadProgressPercent,tablesLoaded:ReplicationTaskStats.TablesLoaded,tablesErrored:ReplicationTaskStats.TablesErrored}' \
    --output table
  aws dms describe-table-statistics --region "$AWS_REGION" \
    --replication-task-arn "$TASK_ARN" \
    --query 'TableStatistics[].{table:TableName,state:TableState,validation:ValidationState,failed:ValidationFailedRecords,suspended:ValidationSuspendedRecords}' \
    --output table | head -40
  # Gates: ValidationFailed = 0 and every suspended row dispositioned; for CDC
  # sources CDCLatencySource/CDCLatencyTarget at the frozen ADR threshold, then zero.
  sleep "$INTERVAL"
done
