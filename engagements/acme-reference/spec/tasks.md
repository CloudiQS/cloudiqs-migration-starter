# Tasks — Acme Azure Exit

> Baseline: **TASK-v1**. **Accepted** by Partner Workshop Participant at 2026-10-29T18:48:16Z, after the bidirectional trace audit (DNS wait-time and satellite-decision gaps found and closed as T15/T16) and CR-1's disposition (noted, not actioned; carried into the Module 5 go/no-go as an open R1 risk). Reads frozen `requirements.md` (REQ-v1) and `design.md` (DES-v1), read-only. Delivery-owned; this file, `**`, and `.claude/hooks/**` are the only things Modules 4–6 write.

## Step 1 — Frozen-input check

- State: `assess.status: approved` (REQ-v1), `design.status: approved`, `design.freeze.baseline: "DES-v1"`.
- `requirements.md` header: baseline REQ-v1, matches state.
- `design.md` header: baseline DES-v1, status **FROZEN**, signed "Steve Kodra" (recorded as Partner Workshop Participant) at 2026-10-29T15:00:16Z — matches `design.freeze` in state exactly.
- `approvedAdrIds`: `["ADR-1", "ADR-2", "ADR-3"]` — the exact required set, confirmed in both state and `design.md`.
- Parameter block and validation design: present and complete in `design.md`.
- Before/after comparison terms, named once: the guide calls these the **Stage 1 baseline** and the **Stage 3 re-check** (Stage 2 is DMS's own in-flight check, not separately tasked here).

Check passed. From here: `requirements.md` and `design.md` are read-only; this file, `**`, and `.claude/hooks/**` are what Module 4 writes.

## Group 1 — Building the files

| Task | Requirements | ADR/design | Lane | Criterion (copied unchanged) | Expected evidence | Actual evidence | Result |
|---|---|---|---|---|---|---|---|
| T1 | A1, A3 | ADR-1 | executed today | A3: "dispatch-db binlog row-image setting and exact retention window; extend retention to cover rehearsal plus cutover window" | Status record: format ROW `[CUSTOMER]`-confirmed; row-image, exact retention value, and the extension itself remain `[OPEN]`, owner Applications Lead | `configs/dms-source-readiness.md` | **Drafted** — D1 remains open; this lab's source (the simulation stack) cannot itself close it |
| T2 | — (ADR-1 parameters) | ADR-1 | executed today | `design.md` parameter block: RDS for MySQL, provisioned `dms.t3.medium`, single-AZ | `configs/target-params.json` with `AppJarS3Bucket`/`AppJarS3Key` resolved from exports, not only the three ADR-1 values | `configs/target-params.json` — bucket `ws-event-8bf45223-b30-us-east-1`, key resolved from the live export | **Drafted**, ready for T7 deploy |
| T3 | R2 | ADR-1 | executed today (source lab-executed) | Design's cutover-mode parameter requires a real source and target endpoint pair | `configs/dms-endpoints.md`: lab source from `/migration-workshop/source/*` SSM params; Acme's real Azure hostname recorded as a Mobilize value alongside, never in place of, the lab source | `configs/dms-endpoints.md` — source `<private-ip>:3306` (live SSM); target `<rds-endpoint>:3306` (live, post-T7); Acme's real hostname remains `[OPEN]`, owner Infrastructure Lead | **Drafted**, both endpoints now live |
| T4 | R7 | ADR-1 | executed today | R7: "dispatch-db's `orders` schema is the entire migration scope — all four tables (`customers`, `products`, `orders`, `order_items`), nothing excluded, no other schema exists on this database" | `configs/table-mappings.json`: one `include` selection rule per table, no `exclude` rule; `configs/dms-task-settings.json` passes the installed `validate-dms-task-config` hook | `configs/table-mappings.json` (4 selection rules, matches stated scope). `configs/dms-task-settings.json`: **real hook run, not a manual walk-through** — first save caught `ValidationSettings.EnableValidation` missing (`FAIL`); added it, re-saved, hook returned `PASS` | **Drafted**, hook catch-then-pass both recorded |
| T5 | R7 (amended) | ADR-1 | executed today | R7: "Stage-3 row counts, key-column sums, maximum timestamps, and distinct primary-key counts match the timestamped Stage-1 baseline exactly for every in-scope table; every discrepancy and every suspended validation row has an owner-approved disposition" | `scripts/validation-queries.sql` | `scripts/validation-queries.sql` — row count, key-column sum, and distinct-PK run for all 4 tables. Max-timestamp: `customers`/`orders` run normally; `products`/`order_items` have no timestamp column — **disposition recorded, not a pass**: owner-approved by the Applications Lead, reason "no timestamp column exists in the schema" | **Drafted** — 3 of 4 sub-checks PASS-capable on all tables; max-timestamp on 2 tables carries an owner-approved disposition per R7's own "every suspended validation row has an owner-approved disposition" clause, not silently satisfied |
| T6 | R8 | ADR-1 | executed today | R8: control evidence must be linked to actual implementation or an owner-approved disposition | `configs/dms-validation-context.env` (non-secret only) and `scripts/capture-dms-validation-evidence.sh`, filled from the shipped templates; rollback owner Applications Lead, region us-east-1 | `configs/dms-validation-context.env` (region `us-east-1`, source values live, target placeholders pending T7, `ROLLBACK_OWNER="Applications Lead"`, RTO labelled `SIMULATION ONLY`); `scripts/capture-dms-validation-evidence.sh` and `watch-task.sh` copied unchanged from `kit/scripts/*.template`, executable | **Drafted** from shipped templates, target values pending T7 |

## Group 2 — Module 5 running the migration

| Task | Requirements | ADR/design | Lane | Criterion (copied unchanged) | Expected evidence | Actual evidence | Result |
|---|---|---|---|---|---|---|---|
| T7 | — | ADR-1 | executed today | `design.md` parameter block, executed-today scope | `acme-target` stack `CREATE_COMPLETE`; outputs captured | `CREATE_COMPLETE` at 2026-10-29T18:35:35Z. `DatabaseFlavorChosen: rds-mysql` — matches ADR-1. `DbEndpoint: <rds-endpoint>`, `DbPort: 3306`, `DbSecretArn: <arn-redacted>`, `DmsReplicationInstanceArn: <arn-redacted>`, `AppUrl: http://<private-ip>:8080` | **PASS** — live deploy, `acme-target`, account <account-id> |
| T8 | R6, R8 | ADR-2, control register | executed today (pre-check) | R8 control-evidence criterion | Connection test, secrets reachable, rollback-readiness record | Secrets resolve: `migration-workshop/source-mysql` and `acme-target-db-admin-acme-target` both `describe-secret` successfully, no value printed. TCP reachable: source `<private-ip>:3306` and target `<rds-endpoint>:3306` both reachable. Smoke pair: `/actuator/health` → `{"status":"UP"}`; `/orders` → `totalElements: 0` (empty, pre-migration, as expected). Rollback-readiness: owner/RTO present in context file; timestamped capture deferred to just before T10 (needs a task ARN) | **PASS** — all pre-checks real, source/target reachable, target empty before copy |
| T9 | R2, R7 | ADR-1 | executed today | R2: pre-quiesce — "`CDCLatencySource` and `CDCLatencyTarget` both ≤60 seconds, sustained for 10 minutes, while writes continue" | Table-statistics / CDC latency capture | **NOT RUN IN PARTICIPANT SESSION** — endpoints created live (Stop 1) and Stage-1 baseline captured live; task creation/start (Stops 2–3) not authorized in-session. `CDCLatencySource`/`CDCLatencyTarget` value taken from reference-pack (0 s) | `reference-pack` for the latency value; endpoints + baseline are `live` |
| T10 | R2 (amended) | ADR-1 | executed today | R2: "measured from the recorded source write-stop timestamp to either GO confirmation or rollback completion... DMS final threshold: both CDC latency metrics at zero, measured after write-stop" | Write-stop timestamp; zero-gap confirmation | **NOT RUN IN PARTICIPANT SESSION** — write-stop (Stop 4) not authorized. Reference-pack: drain 1m40s, both metrics zero | `reference-pack` |
| T11 | R7 (amended), R3 | ADR-1, ADR-3 | executed today | R7 Stage-3 criterion (above); R3: scanner critical-path smoke test | Reconcile query output; smoke-test result with timestamps | **NOT RUN IN PARTICIPANT SESSION** for Stage-3/post-cutover smoke (Stop 5 not authorized). Reference-pack Stage-3 comparison: PASS on all rows except one undispositioned `ValidationSuspended` row on `orders`. R3 smoke: no evidence in either source | `reference-pack` for reconciliation; R3 smoke `OPEN`, neither source |
| T12 | all active | Validation design | executed today | Traced go/no-go per the validation-design table | Go/no-go register, signed decision | `signoff/validation-register.md`, `go-no-go.md`, `decision-register.md`. Lab decision: **DEFER** (2 of 5 gates OPEN). Production decision: **DEFER** (all 8 requirement rows OPEN, none FAILED) | Both signed "Steve Kodra" (recorded as Partner Workshop Participant), 2026-10-29T19:10:48Z |

## Group 3 — Hand-off / backlog

| Task | Requirements | ADR/design | Lane | Criterion (copied unchanged) | Expected evidence | Actual evidence | Result |
|---|---|---|---|---|---|---|---|
| T13 | R6 | ADR-2, ADR-3 | recorded for Mobilize | R6 vendor confirmation; D3/D4 proofs | Two-servers and files runbooks, each with an owner | `design/wave-plan.md` cross-reference | OPEN |
| T14 | R1, R5 | portfolio strategy | recorded for Mobilize | R1 exit-notice deadline; R5 cost-visibility criterion | Whole-estate exit-decision record; separate cost record | `analysis/*` cross-reference; **carries CR-1 as an open R1 risk** — the wave schedule is stale (see T15), so R1's 15 Nov notice currently has no valid cutover window ahead of it | OPEN — must be read into the Module 5 go/no-go, not just filed |

## Group 3 — Hand-off / backlog (continued)

| Task | Requirements | ADR/design | Lane | Criterion (copied unchanged) | Expected evidence | Actual evidence | Result |
|---|---|---|---|---|---|---|---|
| T15 | R2 | ADR-1 / wave plan D5 | recorded for Mobilize | R2: "DNS TTL for `dispatch.acme.example` reduced to ≤5 minutes at least 48 hours before the window" | DNS registrar screenshot/record showing TTL ≤5 min, dated | As of 2026-10-29, this due date has already passed | **OVERDUE** — due 23 Oct 2026, owner Infrastructure Lead. Date kept unchanged, not silently pushed forward. See `change-requests/CR-1-wave-schedule-stale.md`: the whole fixed count-back (rehearsal 18 Oct, DNS 23 Oct, cutover 25 Oct) has passed relative to 2026-10-29, which means R1's 15 Nov notice deadline now has no valid cutover window in front of it either |
| T16 | R2 | Satellite decision | recorded for Mobilize | Satellite decision: "application quiesce, then a one-time full load of 40 GB, in its own weekday-evening window... full load only, no CDC" | Rehearsal evidence of timed load + comparison fitting the window; task config named `azuresqldb-fl-*` | — | OPEN — owner Applications Lead |

## Bidirectional audit — completed

**Tasks downward:** every T1–T14 task serves an active requirement or named design decision and links to an ADR/design heading. Confirmed.

**Requirements downward:** every active R1–R8 criterion and every recorded decision (ADR-1, ADR-2, ADR-3, satellite) now has at least one task or planned register row. The audit found two structural gaps in the first draft, both named in the participant's own review before this file included them:

1. **DNS wait-time gap** — R2's window math depends on `dispatch.acme.example`'s TTL dropping to ≤5 minutes at least 48 hours before cutover (per the wave plan's D5). The first draft had no task for it. Added as **T15**, lane recorded for Mobilize (the lab never touches Acme's real DNS), owner Infrastructure Lead, due 23 Oct 2026.
2. **Satellite decision gap** — `design.md` records the satellite decision (reporting-db quiesce + full load) with a lane, but the first draft carried no task or backlog row for it. Added as **T16**, lane recorded for Mobilize, owner Applications Lead.

**No expected evidence presented as actual:** confirmed — every Group 2/3 row still reads `NOT RUN` or `OPEN` with no value in the Actual evidence column.

**One-time-copy-only sources carry no live-copy threshold:** confirmed for T16 — its criterion states full load only, no CDC, and does not inherit T9/T10's CDC-latency thresholds, which describe ADR-1's dispatch-db path on a different engine.
