# Simulation Decision Register — DMS Cutover Lab

> Completes Module 5's T12 simulation decision. Does not authorize a production cutover, DNS change, client repoint, or source retirement.

## Scope and evidence mode

| Field | Value |
|---|---|
| Requirements / design / tasks | REQ-v1 / DES-v1 FROZEN / TASK-v1 |
| Evidence mode | live + reference-pack |
| Decision applies to | This participant lab session, combined with the reference run |
| Production authorization | Not granted by this register |

## Technical decision gates

| Gate | Evidence path / observed value | Result | Disposition / owner |
|---|---|---|---|
| Full load and DMS validation | reference-pack: `ValidationFailed=0`, but `ValidationSuspended=1` on `orders` | **OPEN** | Quiet-period re-run or manual row comparison; owner Applications Lead (agent recommendation — not participant-dispositioned) |
| CDC evidence and final drain | reference-pack: `CDCLatencySource`/`CDCLatencyTarget` both 0 s; drain 1 m 40 s | **PASS** | — |
| Stage-1 ↔ Stage-3 reconciliation | reference-pack aggregate table, all rows match | **PASS** | — (live Stage-1 baseline captured this session has no live Stage-3 counterpart to compare; this gate is satisfied on reference-pack evidence only) |
| Target application smoke | Live pre-migration smoke only (`/actuator/health` UP, `/orders` empty) — no post-cutover smoke exists in either source | **OPEN** | Run smoke after a completed copy (live or reference); owner Applications Lead / Infrastructure Lead |
| Rollback readiness | reference-pack RTO 6 m 05 s; live context file: owner "Applications Lead" present, RTO labelled `SIMULATION ONLY` | **PASS** | — |

A simulation attestation must say what was observed and must be labelled `SIMULATION ONLY`. It is enough for a lab decision only when the other technical gates pass — two gates above are `OPEN`, so attestation alone does not carry this decision to GO.

## Decision

**Simulation decision:** DEFER
**Time:** 2026-10-29T19:10:48Z
**Reason:** Two of five lab gates are `OPEN` — full load/DMS validation (one undispositioned suspended row) and target application smoke (no post-cutover evidence in either source). Per the participant's standing rule, GO requires all five `PASS`; it does not. CDC/drain, reconciliation, and rollback readiness all `PASS`.

| Role | Name | Decision acknowledgement |
|---|---|---|
| Participant | Steve Kodra (recorded as Partner Workshop Participant) | DEFER |
| Facilitator or peer reviewer | — | — |

## Production hand-off

A production `GO` requires the full `signoff/go-no-go.md`, approved owner and RTO, measured CDC-latency evidence, all customer controls and preconditions, and the customer's named approvers. This lab register records learning evidence only.
