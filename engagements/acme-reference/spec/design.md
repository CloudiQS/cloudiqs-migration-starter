# Design — Acme Azure Exit

> Baseline: **DES-v1**. Status: **FROZEN**. Requirements baseline served: **REQ-v1**. This file is the execution authority for Modules 4–6; supporting detail lives in `design/architecture-decisions.md` and `design/wave-plan.md` — if either ever disagrees with this file, this file governs.

## Incremental approval record

| Decision | Status |
|---|---|
| ADR-1 — dispatch database | **Approved** — defensible difference from the reference convention (RDS over Aurora: create time, R4, R5), accepted |
| ADR-2 — compute path | **Approved** — match |
| ADR-3 — object path | **Approved** — match |
| Satellite decision — reporting database | match; recorded for Mobilize, wired into validation design (not a fourth ADR) |
| Freeze | **Signed** — typed name "Steve Kodra", recorded as Partner Workshop Participant per this engagement's standing attribution, at 2026-10-29T15:00:16Z |

## Parameter block — executed-today choices

| Parameter | Value | Requirements served | ADR | Disqualifier / deciding proof |
|---|---|---|---|---|
| dispatch-db target | RDS for MySQL | R4, R5, R7 | ADR-1 | D1 binlog proof fails → quiesce + full load only |
| DMS capacity | provisioned `dms.t3.medium` | R1, R2 | ADR-1 | — |
| Availability | single-AZ (workshop scale) | R5 | ADR-1 | Multi-AZ recorded for Mobilize (R8) |
| Migration/cutover mode | full load + CDC; quiesce → drain → smoke | R2, R7 | ADR-1 | D1 fails → quiesce + full load |
| CDC pre-quiesce threshold | `CDCLatencySource` and `CDCLatencyTarget` ≤60s, sustained 10 min | R2, R7 | ADR-1 | — |
| CDC final threshold | both metrics at zero, measured after write-stop | R7 | ADR-1 | — |

## ADR-1 — Dispatch database target and migration mode

Full text and citations: `design/architecture-decisions.md#adr-1`. Summary: RDS for MySQL, provisioned `dms.t3.medium`, single-AZ, full load + CDC then quiesce/drain/smoke. Requirements served: R7 (dominant), R2, R4, R5. Evidence: `[SSB-ADAPTED]` — `implementation-guide-dms.md` `## Source page 4` (engine absent from CDC-capable list) and `## Source page 3` (borrowed Google Cloud SQL for MySQL prerequisites), combined with the Module 2 interview (binlog ROW confirmed; row-image and retention open). Disqualifier: binlog access/ROW/retention cannot be proved. Deciding proof: **D1**, Applications Lead, before freeze.

## Satellite decision — reporting database

Lane: recorded for Mobilize. Choice: application quiesce, then one-time full load of 40 GB, in its own weekday-evening window. Guardrail: full load only, no `CDCStartPosition`, `azuresqldb-fl-` naming, never inherits ADR-1's CDC-readiness thresholds. Validation row linked to R2. Full text: `design/architecture-decisions.md#satellite-decision`.

## ADR-2 — Compute path (both VMs)

Lane: recorded for Mobilize (replication executes today; cutover is Mobilize-gated). Choice: MGN rehost, dispatch-api + rollup and WMS connector. Requirements served: R1 (dominant), R6, R4. Evidence: `implementation-guide-mgn.md` `## Source page 2` (Azure Hybrid Benefit / License Mobility) and `## Source page 11` (test launch doesn't touch production). Disqualifier: vendor refuses agent install or support. Deciding proofs: **D3** (procurement), **D4** (Applications Lead), before WMS cutover. Full text: `design/architecture-decisions.md#adr-2`.

## ADR-3 — Object path (dispatch-blob)

Lane: recorded for Mobilize. Choice: DataSync to S3, bulk copy ≤400 Mbps, archive rehydrated first, final sync sized to daily churn (not monthly growth). Requirements served: R3 (dominant), R1. Evidence: `implementation-guide-datasync.md` `## Source page 5` (`Estimating the Transfer Window`, `Assessing Cloud-Exit Eligibility`). Disqualifier: rehydration or transfer lead time exceeds the exit runway. Deciding proofs: **D6**, **D2**, before Wave 1 commitment. Full text: `design/architecture-decisions.md#adr-3`.

## Inherited steering constraints (`engagement-context.md`)

Base tier, single AWS account (no PCI/ISO/SOC2, residency, quota, or credential-isolation trigger). Destination-side KMS re-encryption default. Public-internet TLS default, constrained in practice by the warehouse scanners' shared link (R3). Runbooks must be executable by two generalists (R4) — this governs ADR-1's target choice directly.

## Deciding-proof index (D1–D8)

| ID | Proof | Owner | Required by |
|---|---|---|---|
| D1 | dispatch-db binlog access/row-image/retention proved | Applications Lead | Before design freeze |
| D2 | Azure cloud-exit free-egress waiver eligibility confirmed | Infrastructure Lead | Before Wave 1 commitment |
| D3 | Vendor doesn't refuse agent install / confirms support validity | Procurement | Before WMS cutover |
| D4 | Agent-install approval obtained from vendor | Applications Lead | Before WMS cutover |
| D5 | DNS TTL ≤5 minutes, set and confirmed | Infrastructure Lead | 23 Oct 2026 |
| D6 | Archive rehydration lead time and cost obtained | Infrastructure Lead | Before Wave 1 commitment |
| D7 | Operator walkthrough of the runbook (R4), no undocumented step found | Applications Lead | Before production readiness |
| D8 | Second DNS registrar administrator added | Infrastructure Lead | Before cutover window |

## Validation design

| Requirement | Criterion source | ADR/design link | Planned task | Expected evidence | Failure disposition |
|---|---|---|---|---|---|
| R2 | REQ-v1 | ADR-1 cutover mode | Module 4 task | write-stop/GO/rollback timestamps; DNS TTL read | NO-GO or rollback/replan |
| R2 | REQ-v1 | Satellite — reporting-db full load | Module 4 task (Mobilize) | quiesce-window plan; `azuresqldb-fl-` naming | Mobilize backlog until executed |
| R3 | REQ-v1 | ADR-3 cutover smoke | Module 4 task | bandwidth ≤400 Mbps; scanner smoke pass | throttle or NO-GO |
| R4 | REQ-v1 | Operator walkthrough (D7) | Module 4 task | walkthrough record, no undocumented step | FAIL if D7 unresolved |
| R6 | REQ-v1 | ADR-2 | Module 4 task | vendor/licence records (D3, D4) | blocks WMS cutover |
| R7 | REQ-v1 | ADR-1 validation | Module 4 task | Stage-1 baseline; Stage-3 comparison register | investigate/rollback/NO-GO |
| R8 | REQ-v1 | Control register + D8 | Module 4 task | control evidence; second registrar admin added | open Mobilize action or NO-GO |

## Waves

Full plan: `design/wave-plan.md`. Fixed count-back from 15 Nov 2026: cutover window **25 Oct**; DNS TTL ≤5 min by **23 Oct**; rehearsal/validation evidence by **18 Oct**; Wave 1 starts now. Signed go/no-go precedes the DNS repoint (Wave 2, step 5 before step 6).

## Convergence note

Checked against `checkpoints/modules/03-architecture/architecture-decisions.md` for conventions only (D-numbering, citation anchors, task-ID pattern), not loaded as a substitute for participant decisions (no `checkpointLoads` entry — nothing here was taken from it as content). One flagged divergence: the reference defaults to Aurora MySQL for ADR-1; this design chooses RDS for MySQL on create-time, operability (R4), and cost (R5) grounds — a defensible divergence, not a gap. Every other reference value (provisioned capacity, single-AZ, MGN rehost both VMs, DataSync bulk-copy-then-churn-sized-final-sync) matches.

## Freeze record

**FROZEN.** ADR-1, ADR-2, and ADR-3 approved; convergence classification (ADR-1 defensible difference, ADR-2/ADR-3/satellite match) accepted. Signed "Steve Kodra" at 2026-10-29T15:00:16Z. `design.freeze: { baseline: "DES-v1", by: "Partner Workshop Participant", at: "2026-10-29T15:00:16Z" }` recorded in `.planning-state.json`. From here, shell and AWS use are authorized, but only for the participant lab catalog — before this freeze, that use was not authorized, even though the capability was always technically present. `requirements.md` and this file are now read-only; Module 4 builds `tasks.md` from them.
