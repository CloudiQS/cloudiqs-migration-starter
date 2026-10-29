# Architecture Decision Records — Acme Azure Exit

> Supporting, customer-facing. Execution authority is `spec/design.md`. Served requirements baseline: **REQ-v1**.

## Step 1 — Dominant requirements

Approved `requirements.md` (REQ-v1), one line each: R1 exit notice by 15 Nov 2026 · R2 4-hour Sunday window, measured write-stop to GO/rollback · R3 scanning not degraded, ≤400 Mbps + smoke test · R4 two generalists, no undocumented specialist step · R5 cost visible by workload · R6 WMS vendor support valid on AWS · R7 zero record loss, `orders` schema, all four tables · R8 controls scorable, DNS registrar single-admin flagged.

**Your call:** R7, R2, R3 matter most here — data integrity, the cutover window itself, and the shared-link constraint that governs everything that moves data during business hours.

## ADR-1 — Dispatch database target and migration mode

- **Increment approval:** **Approved** (defensible difference from the reference convention, accepted at convergence).
- **Requirements served:** R7 first (data integrity — the dominant one), then R2 (the window the mode has to fit inside); R4 and R5 shape the target choice.
- **Lane:** executed today.
- **Choice:** RDS for MySQL, provisioned `dms.t3.medium`, single-AZ at workshop scale, full load + CDC, then quiesce → drain → smoke.
- **Why RDS over Aurora:** faster to create (RDS ~5–10 min vs. Aurora ~10–15 min, so it's ready for Module 5 sooner), simpler for two generalists to operate (R4), and a smaller, better-understood cost surface for a 260 GB workload (R5). This is a defensible divergence from the Module 3 checkpoint's reference choice of Aurora MySQL — same requirements, different weighting of create-time and operability over Aurora's storage-engine scaling headroom, which Acme's 260 GB / 4 GB-month-growth profile doesn't need.
- **Why provisioned over Serverless:** a provisioned instance is created alongside the target stack in Module 4, so it's ready when Module 5 starts. DMS Serverless creates nothing until the copy starts — in this lab that's taken 20–25 minutes to provision capacity before any data moves, eating most of Module 5's time. Serverless removes sizing work and idle cost, which matters more on a real migration than in a timed lab; not chosen here for that reason.
- **Why single-AZ:** Multi-AZ is recorded for Mobilize under R8 (production high-availability shape), not executed in this lab.
- **Evidence — the engine gap, `[SSB-ADAPTED]`:** `implementation-guide-dms.md`, `## Source page 4`, anchor **CDC Capability and Connection Risk Assessment**, lists DMS's CDC-capable sources: Azure SQL Database, Azure SQL Managed Instance, Google Cloud SQL for PostgreSQL, Google Cloud SQL for MySQL. Azure Database for MySQL — dispatch-db's actual engine — is absent.
- **Evidence — borrowed prerequisites:** same guide, `## Source page 3`, anchor **Google Cloud SQL for MySQL**: "Enable binary logging and set `binlog_format` to ROW and `binlog_row_image` to FULL — MIXED format produces incomplete CDC events that cause silent data loss at the target," plus "Extend binlog retention to cover the full migration window plus a retry buffer." These are the nearest-engine prerequisites, borrowed because no Azure Database for MySQL section exists in this guide — borrowed guidance, not a proven match for Acme's exact engine.
- **Combined with the interview:** binlog is enabled and format is confirmed ROW (Module 2, Applications Lead). Row-image setting and exact retention remain `[OPEN]` — that's **D1**.
- **The two readiness numbers:**
  - *Pre-quiesce (safe to pause):* `CDCLatencySource` and `CDCLatencyTarget` both ≤60 seconds, sustained for 10 minutes, while writes continue.
  - *Final (safe to compare and finish):* both metrics at zero, measured only after the write-stop.
  - The first number says it's safe to pause writes; only the second says it's safe to run the final comparison. Conflating them risks comparing against a target that's still catching up.
- **Alternatives considered:** Aurora MySQL (ruled out above); DMS Serverless (ruled out above); Multi-AZ (deferred to Mobilize); quiesce + full load only (the fallback if D1 fails).
- **Disqualifier:** binlog access, ROW format, or adequate retention cannot be proved.
- **Deciding proof:** **D1**, Applications Lead, before freeze.
- **Reopens if:** requirements, the binlog evidence, operability, cost, or the create-time trade changes.

## Satellite decision — reporting database

- **Lane:** recorded for Mobilize. Name the term: this is the satellite decision, flagged as deferred back in Module 2. Only ADR-1's dispatch-db path is proven in this lab; reporting-db's full-load mechanism is materially simpler and lower-risk, so it stays a reviewed plan here, not an in-lab execution.
- **The guide's three options**, `implementation-guide-dms.md`, `## Source page 4`, anchor **CDC Capability and Connection Risk Assessment**: "DMS does not support CDC for Azure SQL Database. Every Azure SQL Database migration requires one of three cutover approaches... Application quiesce window... Third-party CDC platform (e.g., Debezium)... Pre-migrate to Azure SQL Managed Instance..." In plain terms: pause writes for a window, use a third-party tool to fake a live copy, or move the database to a different Azure offering first.
- **Choice:** application quiesce, then a one-time full load of 40 GB, in its own weekday-evening window (the customer-confirmed tolerance from Module 2) — full load only, no CDC, none of ADR-1's readiness numbers, because this is a different engine behaving differently.
- **Disqualifier:** the timed load plus comparison exceeds the accepted evening window.
- **Deciding proof:** Applications Lead rehearsal.
- **Guardrail, regardless of lane:** this database can never do a live copy — the guide confirms that directly. If this decision is ever executed, the task must use full load only, carry no `CDCStartPosition` or ongoing-replication setting, and follow the guide's `azuresqldb-fl-` naming so the restriction stays visible in the console. It must never inherit ADR-1's CDC-readiness numbers.
- **Validation design row:** linked to R2, with a planned task placeholder (Module 4 creates the task).

## ADR-2 — Compute path (both VMs)

- **Increment approval:** **Approved** (match, confirmed at convergence).
- **Requirements served:** R1 (dominant — the exit date), R6 (vendor support/licence), R4 (operability).
- **Lane:** recorded for Mobilize — replication can start today; cutover is the Mobilize-gated step.
- **Choice:** MGN rehost for both VMs — dispatch-api (with the nightly rollup, same host) and the WMS connector.
- **Evidence:** `implementation-guide-mgn.md`, `## Source page 2`, anchor **Azure Virtual Machine Prerequisites**: "For VMs with Azure Hybrid Benefit (Windows Server or SQL Server BYOL): gather License Mobility verification documentation from your Microsoft Volume Licensing agreement — this must be on hand before cutover, as the license is re-registered on the EC2 target independently after migration." And `## Source page 11`, anchor **Test Launch and Application Validation**: "A test launch provisions a temporary EC2 instance from the latest replicated snapshot without pausing block-level replication on the source — the source and test instance run simultaneously."
- **Why the asymmetry:** block-level replication and test launches don't touch production traffic and need no vendor sign-off — they can start immediately. Switching real traffic over is different: it needs the vendor's written approval to install the Replication Agent and proof of the WMS connector's license (Azure Hybrid Benefit evidence Acme doesn't have yet). That gates cutover, not replication.
- **Alternatives considered:** rebuild, repurchase, retain the vendor workload as-is.
- **Disqualifier:** vendor refuses agent installation or support.
- **Deciding proofs:** **D3** (procurement) and **D4** (Applications Lead), before WMS cutover.

## ADR-3 — Object path (dispatch-blob)

- **Increment approval:** **Approved** (match, confirmed at convergence).
- **Requirements served:** R3 (dominant — the shared-link bandwidth cap), R1 (exit date).
- **Lane:** recorded for Mobilize — bulk copy is long-lead Wave 1 work; the whole-estate execution sequence is Mobilize.
- **Choice:** DataSync to S3; bulk copy capped at ≤400 Mbps; archive tier rehydrated first; final incremental sync sized to daily object churn (128–160 GB/day), not the 140 GB/month net-growth figure.
- **Evidence:** `implementation-guide-datasync.md`, `## Source page 5`, anchor **Estimating the Transfer Window**: "Add rehydration time for any Azure Blob archive volume in the inventory — rehydration must complete before the DataSync task starts and cannot be parallelized with task configuration." Same page, anchor **Assessing Cloud-Exit Eligibility**: "Contact your Azure account team to confirm eligibility for Azure's data transfer waiver program before scheduling any transfers — enrollment requires documentation of migration intent and must be completed before egress begins."
- **Alternatives considered:** offline transfer; retaining the source until eligibility/lead time is confirmed.
- **Disqualifier:** rehydration or transfer lead time exceeds the exit runway.
- **Deciding proofs:** **D6** (rehydration lead time/cost) and **D2** (Azure waiver eligibility), before Wave 1 commitment.

## Portfolio strategy (all 7 migration units + retain/retire)

| Workload | Strategy | Requirements / gate |
|---|---|---|
| dispatch-api + nightly rollup | Rehost (MGN) | R1, R4, R7 |
| wms-connector | Rehost (MGN), cutover vendor-gated | R6, D3, D4 |
| dispatch-db | Replatform (RDS for MySQL + DMS) | R2, R7, D1 |
| reporting-db | Replatform, satellite quiesce + full load | R2 |
| dispatch-blob | Replatform (DataSync + S3) | R1, R3, R5, D2, D6 |
| payroll | Retain | Out of migration scope |
| legacy-monitor | Retire, after owner confirms no dependency | Infrastructure Lead sign-off |

## Validation design

| Requirement | Criterion source | ADR/design link | Planned task | Expected evidence | Failure disposition |
|---|---|---|---|---|---|
| R2 | REQ-v1 | ADR-1 cutover mode | Module 4 task | write-stop/GO/rollback timestamps; DNS TTL read | NO-GO or rollback/replan |
| R2 | REQ-v1 | Satellite decision — reporting-db full load | Module 4 task (Mobilize) | quiesce-window plan; `azuresqldb-fl-` task naming | Mobilize backlog until executed |
| R3 | REQ-v1 | ADR-3 cutover smoke | Module 4 task | bandwidth metric ≤400 Mbps; scanner smoke pass | throttle or NO-GO |
| R4 | REQ-v1 | Operator walkthrough | Module 4 task | walkthrough record, no undocumented step | D7 unresolved → R4 FAIL |
| R6 | REQ-v1 | ADR-2 | Module 4 task | vendor/licence records (D3, D4) | blocks WMS cutover |
| R7 | REQ-v1 | ADR-1 validation | Module 4 task | Stage-1 baseline, Stage-3 comparison register | investigate/rollback/NO-GO |
| R8 | REQ-v1 | Control register + DNS second-admin | Module 4 task | control evidence; second registrar admin added (D8) | open Mobilize action or NO-GO |

## Deciding-proof index (D1–D8)

| ID | Proof | Owner | Required by |
|---|---|---|---|
| D1 | dispatch-db binlog access/row-image/retention proved | Applications Lead | Before design freeze |
| D2 | Azure cloud-exit free-egress waiver eligibility confirmed | Infrastructure Lead | Before Wave 1 commitment |
| D3 | Vendor doesn't refuse agent install / confirms support validity | Procurement | Before WMS cutover |
| D4 | Agent-install approval obtained from vendor | Applications Lead | Before WMS cutover |
| D5 | DNS TTL ≤5 minutes, set and confirmed | Infrastructure Lead | 23 Oct 2026 (48h before cutover) |
| D6 | Archive rehydration lead time and cost obtained | Infrastructure Lead | Before Wave 1 commitment |
| D7 | Operator walkthrough of the runbook (R4) completed, no undocumented step found | Applications Lead | Before production readiness |
| D8 | Second DNS registrar administrator added | Infrastructure Lead | Before cutover window |

> Checked `checkpoints/modules/03-architecture/architecture-decisions.md` for the D-numbering, task-ID, and citation-anchor conventions this file and Module 4 rely on — not for its reference decisions, which differ from yours in one place (it defaults to Aurora MySQL; you chose RDS for MySQL, recorded above as a defensible divergence). Everything else here — provisioned capacity, single-AZ, MGN rehost, DataSync bulk-copy approach — matches the reference's reasoning.
