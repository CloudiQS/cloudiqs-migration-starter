# What you demonstrated — Acme Outdoor Supplies (azure-exit)

> One page, generated from your own approval records and files when the take-home ZIP was built. Nothing here is summarised or inferred: every line is copied from `.planning-state.json`, your spec files, or a register you signed. The files themselves are one folder away in this ZIP.

**Engagement lead:** Partner Workshop Participant

## Requirements baseline

- Baseline `REQ-v1`; register approved by Partner Workshop Participant, 2026-10-29T11:43:59Z; `requirements.md` approved by Partner Workshop Participant, 2026-10-29T13:14:23Z.
- Requirement IDs in `spec/requirements.md`: R1, R2, R3, R4, R5, R6, R7, R8 (8). The register behind them: `analysis/requirements-register.md`.

## Design decisions and freeze

- Baseline `DES-v1`, frozen by Partner Workshop Participant, 2026-10-29T15:00:16Z.
- Approved decisions: ADR-1, ADR-2, ADR-3. Full text, lanes, disqualifiers and the satellite decision: `spec/design.md`; wave plan: `design/wave-plan.md`.

## Task plan and audit

- Baseline `TASK-v1`, accepted by Partner Workshop Participant, 2026-10-29T18:48:16Z after the bidirectional audit.
- Task IDs in `spec/tasks.md`: T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16 (16). Generated configs and scripts: `configs/`, `scripts/`.
- Target environment launched at 2026-10-29T18:35:35Z.

## Evidence and signed decision

- Evidence source for this session: **live + reference-pack**. Evidence files: `evidence/`; row-by-row results: `signoff/validation-register.md`.
- Lab decision (`signoff/decision-register.md`): DEFER
- Go/no-go (`signoff/go-no-go.md`): DEFER
- Recorded outcome: **DEFER**, by Partner Workshop Participant, 2026-10-29T19:10:48Z. Checkpoint loads during the session: none recorded.

## What the SSB delivered, and what only this engagement supplied

**Where the SSB did the work today, and where it couldn't.** Six places in your own files took their content from a guidance page rather than from scratch:

- **ADR-1, `dispatch-db`** `[SSB-ADAPTED]` — the guide doesn't list Azure Database for MySQL, so the decision borrowed the Cloud SQL for MySQL prerequisites and named the gap: `implementation-guide-dms.md` — ## Source page 3 — `Google Cloud SQL for MySQL`, with the risk framing at ## Source page 4 — `CDC Capability and Connection Risk Assessment`.
- **The satellite decision, `reporting-db`** `[SSB-DIRECT]` — one-time copy only, no live replication, straight from ## Source page 2 — `Azure SQL Database` and ## Source page 13 — `Azure SQL Database Cutover (Full-Load Only)`.
- **R7's acceptance criterion, then T5 and T11** `[SSB-DIRECT]` — the before/after comparison you ran is the guide's own sequence: ## Source page 10 — `Stage 1: Pre-Migration Baseline Capture` and ## Source page 11 — `Stage 2: In-Flight DMS Validation`.
- **T4's hook rule** `[SSB-DIRECT]` — the check that caught the missing `EnableValidation` is the guide's instruction at ## Source page 11, Stage 2.
- **ADR-2, the two servers** `[SSB-DIRECT]` — the licence-evidence gate on the switch-over, not the copy: `implementation-guide-mgn.md` — ## Source page 2 — `Azure Virtual Machine Prerequisites` and ## Source page 17 — `BYOL License Mobility Documentation Completeness`.
- **ADR-3, the files, and your Module 1 map** `[SSB-DIRECT]` — the transfer-window arithmetic from `implementation-guide-datasync.md` — ## Source page 5 — `Estimating the Transfer Window`; the eight-row routing and the two out-of-scope items from `sdd.md` — ## Source page 5 — `Service Trio Overview` and ## Source page 9 — `Anti-Claims and Common Misconceptions`.

**What no page supplied:** the 15 November notice deadline ahead of the 15 December renewal, the four-hour Sunday window, the scanner bandwidth cap, who holds DNS, and every approval you gave. Those came from the brief, the interview, and you. Your signed decision today: **DEFER**, on live + reference-pack evidence.

## Next

Workshop completion is practice evidence, not certification or production authorization. For the next migration case, start with `kit/library/ssb-to-engagement-playbook.md`.
