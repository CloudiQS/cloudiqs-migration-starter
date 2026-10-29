# acme-reference (worked example, fictional customer)

Acme Outdoor Supplies is the fictional customer from the AWS "From SSB to Migrated Workload" workshop, completed by CloudiQS (Steve Kodra) on 28 to 29 Oct 2026. Use it to see what a filled engagement looks like. Never copy its facts, numbers or results into a real engagement.

State at the time of copy:

| Stage | Status | Baseline |
|---|---|---|
| Requirements | approved | REQ-v1 (29 Oct 2026 13:14 UTC) |
| Design | frozen | DES-v1 (29 Oct 2026 15:00 UTC) |
| Tasks | draft, not accepted | TASK-v1 |
| Execute, sign-off | not started | none |

Known gap to learn from: D1 (dispatch-db binlog row image and retention proof, Applications Lead) was set as "before design freeze", but the freeze was signed with D1 still open. On a real engagement the freeze gate blocks until D1 has evidence, or ADR-1 falls back to quiesce plus full load.

Path note: workshop paths were rewritten to this layout (`spec/`, `analysis/`, `design/`). References to `checkpoints/` and `ssb/` point at workshop material that is not in this repo.
