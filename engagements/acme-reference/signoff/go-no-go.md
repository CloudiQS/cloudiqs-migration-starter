# Go/No-Go Register — Acme Dispatch Cutover · 2026-10-29

> Criteria copied unchanged from `requirements.md` (REQ-v1). Every `FAIL`, `OPEN`, or row with missing proof blocks `GO`. This is a workshop decision, not production authorization.

## Baseline and decision scope

| Field | Value |
|---|---|
| Requirements / design / tasks | REQ-v1 / DES-v1 FROZEN / TASK-v1 |
| Evidence mode | live (partial) + reference-pack |
| Decision applies to | Production cutover readiness — this register, not the lab simulation register |

| # | Req | ADR/design | Task | Criterion (copied unchanged) | Evidence source / value | Result | Disposition / owner |
|---|---|---|---|---|---|---|---|
| 1 | R1 | Portfolio strategy | T14 | "Cancellation notice given by 15 Nov 2026" | `change-requests/CR-1...`: wave-plan dates already past as of 2026-10-29 | **OPEN** | CR-1 — Managing Director to confirm a realistic exit date; re-planned dates become DES-v2 |
| 2 | R2 | ADR-1 cutover mode | T9/T10/T15 | "...write-stop to GO/rollback... DNS TTL ≤5 min at least 48h before the window" | T15: DNS task `OVERDUE`; no live write-stop performed | **OPEN** | Infrastructure Lead — DNS TTL reduction, re-dated with CR-1 |
| 3 | R3 | ADR-3 / cutover smoke | T11/T13 | "Migration traffic ≤400 Mbps during warehouse hours, and a scanner critical-path smoke test passes before GO" | No bandwidth or scanner-smoke evidence in either source | **OPEN** | Infrastructure Lead — run during a real migration window |
| 4 | R4 | Operator walkthrough | T13 (D7) | "Two named generalist operators follow the accepted runbook... no undocumented specialist step" | Walkthrough not yet performed | **OPEN** | Applications Lead — before production readiness |
| 5 | R5 | Cost design | T14 | "Per-workload cost allocation tags... one-time cost separated from recurring" | Not implemented in this lab (Mobilize) | **OPEN** | Managing Director — before final sign-off |
| 6 | R6 | ADR-2 | T13 (D3/D4) | "Written vendor confirmation... and written approval to install the AWS Replication Agent" | Vendor not yet contacted | **OPEN** | Applications Lead + procurement |
| 7 | R7 | ADR-1 validation | T9–T11 | "Stage-3 row counts, key-column sums, maximum timestamps, and distinct primary-key counts match the Stage-1 baseline exactly... every suspended validation row has an owner-approved disposition" | Live Stage-1 baseline captured; reference-pack Stage-3 comparison PASS except one undispositioned suspended row | **OPEN** | Applications Lead — disposition the suspended row; D1 (binlog row-image/retention) also still open |
| 8 | R8 | Control/rollback design | T8/T12 (D8) | Controls `PASS` only with actual evidence or an owner-approved disposition with a required-by date | Rollback owner present; RTO `SIMULATION ONLY`; A6 data classification and D8 second DNS admin still open | **OPEN** | Managing Director (A6); Infrastructure Lead (D8) |

## Decision

**GO / NO-GO / DEFER:** DEFER
**Time:** 2026-10-29T19:10:48Z
**Reason:** The database migration path was exercised in the lab only — live through endpoint creation and Stage-1 baseline capture, reference-pack for the remainder — not a completed live run. Every production requirement above remains `OPEN`: R1 is at risk per CR-1 (the cutover window has already passed relative to today's date); R2's DNS precondition is overdue (T15); R3's bandwidth/smoke, R6's vendor letter, and R8's controls all remain open with named owners. No row supports `GO`, and none has failed outright, so `DEFER` — not `NO-GO` — is the accurate call: the path is credible, the evidence to act on it is not yet complete.

Decision on the combined lab run; no production execution is claimed or authorized.

| Role | Name | Signature |
|---|---|---|
| Partner engagement lead | Steve Kodra (recorded as Partner Workshop Participant) | DEFER |
| Customer owner (database/application) | — (not present in this lab) | — |
