# Migration Validation Register — Acme dispatch-db · 2026-10-29

> Evidence mode: **both** — live (endpoints, Stage-1 baseline, pre-migration smoke) and reference-pack (full load, CDC, Stage-3 reconciliation, rollback). Reference-pack values are labelled and are not participant execution.

## Baseline and evidence mode

| Field | Value |
|---|---|
| Requirements baseline | REQ-v1 |
| Frozen design baseline | DES-v1 |
| Accepted task list | TASK-v1 |
| Evidence mode | live + reference-pack |
| Prepared / reviewed by | Agent (drafted) / Partner Workshop Participant |

## Acceptance-chain index

| Chain | Requirement | ADR/design | Task | Criterion (copied unchanged) | Evidence source | Result / disposition |
|---|---|---|---|---|---|---|
| C1 | R7 | ADR-1 validation | T9–T11 | "Stage-3 row counts, key-column sums, maximum timestamps, and distinct primary-key counts match the timestamped Stage-1 baseline exactly for every in-scope table; every discrepancy and every suspended validation row has an owner-approved disposition" | live (Stage-1 only) + reference-pack (full comparison) | **OPEN** — one suspended row in the reference run is undispositioned |
| C2 | R2 | ADR-1 cutover mode | T9–T10 | "...measured from the recorded source write-stop timestamp to either GO confirmation or rollback completion... DNS TTL ≤5 minutes at least 48 hours before the window" | reference-pack (timing) / T15 (OVERDUE) | **OPEN** — DNS precondition overdue, no live write-stop performed |
| C3 | R3 | ADR-3 / cutover smoke | T11 | "Migration traffic stays ≤400 Mbps during warehouse hours, and a scanner critical-path smoke test passes before GO" | neither source includes this evidence | **OPEN** — no bandwidth or scanner smoke evidence from either source |
| C4 | R8 | rollback/control design | T8/T12 | Control evidence linked to actual implementation or an owner-approved disposition; DNS registrar second-admin flag | live (context file: owner present, RTO `SIMULATION ONLY`) + reference-pack (RTO 6m05s) | **OPEN** — A6 data classification and D8 second-admin still open |

## Stage 1 ↔ Stage 3 — live Stage-1 baseline (this session, source only)

Captured 2026-10-29T18:54:43Z, `evidence/dms/2026-10-29T18-54-43Z-baseline-source.tsv`. **No live Stage-3 exists** — the replication task was never created (Stop 2 was not authorized in-session), so there is nothing in this session to diff this against.

| Table | Metric | Stage-1 value (live, this session) |
|---|---|---|
| customers | row_count | 10,000 |
| customers | sum_id | 50,005,000 |
| customers | max_created_at | 2026-04-30 22:07:17 |
| customers | distinct_pk | 10,000 |
| products | row_count | 500 |
| products | sum_price | 50,392.36 |
| orders | row_count | 50,000 |
| orders | sum_total | 13,258,320.60 |
| orders | max_created_at | 2026-04-30 23:46:15 |
| order_items | row_count | 74,880 |
| order_items | sum_price | 7,672,176.77 |

## Stage 1 ↔ Stage 3 — reference-pack (its own self-contained run, different dataset instance — not this session's numbers)

Source: `checkpoints/modules/05-execute/evidence-pack/validation-register.md`. Labelled `reference-pack` throughout; its row counts differ slightly from the live baseline above because it is a separate reference run, not the same captured instance.

| Table | Metric | Stage-1 (reference) | Stage-3 (reference) | Result |
|---|---|---|---|---|
| customers | row_count | 10,000 / 13:41:02 | 10,000 / 14:02:37 | PASS |
| customers | distinct_pk | 10,000 / 13:41:02 | 10,000 / 14:02:37 | PASS |
| products | row_count | 500 / 13:41:03 | 500 / 14:02:38 | PASS |
| products | sum_stock | 124,806 / 13:41:03 | 124,806 / 14:02:38 | PASS |
| orders | row_count | 50,412 / 13:41:05 | 50,412 / 14:02:40 | PASS |
| orders | sum_total | 5,246,183.42 / 13:41:05 | 5,246,183.42 / 14:02:40 | PASS |
| orders | max_created_at | 13:38:12 / 13:41:05 | 13:38:12 / 14:02:40 | PASS |
| orders | distinct_pk | 50,412 / 13:41:06 | 50,412 / 14:02:41 | PASS |
| order_items | row_count | 74,880 / 13:41:08 | 74,880 / 14:02:43 | PASS |
| order_items | sum_quantity | 187,412 / 13:41:08 | 187,412 / 14:02:43 | PASS |

## In-flight validation — CDC (reference-pack)

| Chain | Task | Evidence | ValidationFailed | ValidationSuspended | CDCLatencySource | CDCLatencyTarget | Result / disposition |
|---|---|---|---|---|---|---|---|
| C1 | `acme-orders-flcdc` (reference) | `checkpoints/.../evidence-pack/validation-register.md` | 0 | **1** | 0 s | 0 s | **OPEN** — one `orders` row was continuously updated; DMS could not complete its comparison. Agent recommendation: a quiet-period re-run or manual row comparison, owner Applications Lead, before this converts to PASS. Suspended is unconfirmed, not failed. |

## Register rules (applied)

Every `FAIL`, `OPEN`, or missing-proof row above blocks GO on its own criterion. No disposition here converts an `OPEN` to `PASS`; each open row carries a recommendation and owner, not an invented resolution.
