# Wave Plan — Acme Azure Exit

> Supporting, customer-facing. Dates work backwards from the fixed 15 Nov 2026 cancellation deadline; none of these dates are invented — they are the fixed count-back this engagement uses throughout.

**Deadline arithmetic:** cancellation notice **15 Nov 2026** ← exit-decision evidence by **1 Nov** ← cutover window **25 Oct** (last October Sunday) ← DNS TTL ≤5 min by **23 Oct** (48h before) ← rehearsal/validation evidence by **18 Oct** ← Wave 1 long-lead work starts now.

## Wave 1 — slow, reversible, start first

| Item | Requirements | Entry gate | Expected exit evidence | Owner |
|---|---|---|---|---|
| Blob bulk copy, ≤400 Mbps cap | R1, R3, R5 | D2 waiver confirmed; D6 rehydration lead time known | task reports show ≤400 Mbps; remaining volume fits the final sync | Infrastructure Lead |
| Archive rehydration (1.4 TB) | R1, R5 | D6 lead time/cost accepted | archive volume readable, timestamped | Infrastructure Lead |
| MGN replication, both VMs | R1, R4, R6 | D4 agent-install approval requested | seeding complete; test-launch evidence | Applications Lead |
| dispatch-db rehearsal (RDS + DMS, full load + CDC) | R2, R7, R8 | D1 binlog proof; ADR-1 approved | traced validation register; pre-quiesce CDC latency ≤60s/10min demonstrated | Applications Lead |
| DNS TTL reduction to ≤5 minutes | R2 | — | TTL confirmed ≤5 min, by 23 Oct | Infrastructure Lead (D5) |
| Second DNS registrar administrator added | R8 | — | second admin account exists | Infrastructure Lead (D8) |
| Operator runbook walkthrough | R4 | Runbook drafted (Module 4) | walkthrough record, no undocumented specialist step | Applications Lead (D7) |

## Wave 2 — cutover window (Sunday 25 Oct, 4 hours)

| Order | Item | Requirements | Entry/exit gate |
|---|---|---|---|
| 1 | DNS TTL precondition check | R2 | ≤5 min, confirmed ≥48h before window (D5 already done in Wave 1) |
| 2 | Final object incremental sync | R3 | sized to daily churn, not monthly growth; scanner impact within criterion |
| 3 | dispatch-db quiesce → CDC drain → validation | R2, R7, R8 | pre-quiesce: both CDC latency metrics ≤60s for 10 min while writes continue. After write-stop: both metrics at zero before the Stage-3 comparison runs |
| 4 | Compute cutover rehearsal (scanner journey against AWS endpoint) | R3, R6 | D3/D4 vendor evidence in hand; end-to-end smoke passes before any traffic repoints |
| 5 | **Signed go/no-go — before the DNS repoint** | all active requirements | every lab gate `PASS`; `NO-GO`/`DEFER` means no repoint happens |
| 6 | DNS repoint (hard to undo past this point) | R2 | proceeds only on a recorded `GO` |
| — | reporting-db quiesce + full load (own evening window, recorded for Mobilize — satellite decision, full load only, no CDC) | R2, R7 | timed load plus comparison fits the accepted window |

**Rollback triggers:** an undispositioned validation mismatch; CDC latency non-zero at the point it should be zero; a critical scanner-journey failure; a missing D-series precondition (D1, D3/D4, D5, D8). Rollback cost differs by side of step 6: **before** the repoint, rollback is cheap — resume source writes, stop the task, the Azure source stays live and authoritative. **After** the repoint, rollback means re-pointing DNS back and reconciling any writes that reached AWS in the interim, and that reconciliation has to fit inside whatever time remains in the four-hour window.

**Decommission** (legacy-monitor, and eventually the Azure tenancy itself) happens only after requirement evidence and owner acceptance; the 15 Nov cancellation notice remains its own controlled action, separate from this wave sequence.

## Approval record

| Item | Status |
|---|---|
| ADR-1 | Approved — defensible difference accepted |
| ADR-2 | Approved — match |
| ADR-3 | Approved — match |
| `design.md` freeze | Signed "Steve Kodra", DES-v1, 2026-10-29T15:00:16Z |
