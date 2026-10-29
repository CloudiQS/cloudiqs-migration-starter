# Discovery Checklist — per service, from the guide's Phase 1

> One table per AWS service the estate maps to. Each row is one thing the implementation guide's Phase 1 (prerequisites / assessment) requires you to know before design. The guide supplies the row and its address; the customer supplies the answer. Never fill an answer from the guide.
>
> Status moves `Open` → `Confirmed` only with a classified answer. Every `Open` row that survives discovery needs an owner, a required-by point and a consequence, or it is not a row, it is a hope.

**Engagement:** ______  **Date:** ______  **Reference set:** `ssb/MANIFEST.md` dated ______

## Answer classification

| Label | Meaning | Counts as |
|---|---|---|
| `[CUSTOMER]` | Stated by a named customer role, quoted | Confirmed, pending validation if measurable |
| `[DISCOVERY]` | Read from an export, inventory, console or measurement, with path | Confirmed |
| `[OPEN]` | Nobody could answer; becomes a discovery action | Open, with owner and date |

Ask each question of the role that owns the fact. Start with the row that moves the most money, time or risk if it is wrong. The roles pre-filled below (Applications Lead, Infrastructure Lead, Managing Director) are the workshop's; replace them with the customer's.

## Database — DMS

| Guide requirement (Phase 1) | Guide address | Status | Asked of | Answer and label | Required by | Consequence if wrong |
|---|---|---|---|---|---|---|
| Source engine and exact variant listed in the guide, or nearest listed engine named | `implementation-guide-dms.md` — page 2–3 — source readiness | Open | Applications Lead | | Design (ADR) | Wrong borrowed prerequisites; `[SSB-ADAPTED]` not recorded |
| CDC capability on the source, or full-load-only confirmed | `implementation-guide-dms.md` — page 4 — `CDC Capability and Connection Risk Assessment` | Open | Applications Lead | | Design | Cutover method and window are wrong |
| Service tier / connection limits during full load | `implementation-guide-dms.md` — page 2 — `Azure SQL Database` | Open | Applications Lead | | Design | Full load fails or throttles in the window |
| Size, change rate, largest tables | `implementation-guide-dms.md` — page 5 — `Replication Instance Sizing` | Open | Applications Lead | | Design | Capacity and catch-up numbers unfounded |
| Target service and migration mode constraints from the customer side | `implementation-guide-dms.md` — page 5 — `Target Service and Migration Mode Selection` | Open | Applications Lead | | Design | |
| Network path source → replication instance, firewall ownership | `implementation-guide-dms.md` — page 4 | Open | Infrastructure Lead | | Task plan | Preflight fails on the day |
| | | | | | | |

## Compute — MGN

| Guide requirement (Phase 1) | Guide address | Status | Asked of | Answer and label | Required by | Consequence if wrong |
|---|---|---|---|---|---|---|
| Source VM prerequisites (OS, agent support) | `implementation-guide-mgn.md` — page 2 — `Azure Virtual Machine Prerequisites` | Open | Infrastructure Lead | | Design | |
| Compatibility of each server | `implementation-guide-mgn.md` — page 5 — `Azure VM Compatibility Assessment` | Open | Infrastructure Lead | | Design | Server is outside scope and nobody knew |
| Workloads outside MGN scope named | `implementation-guide-mgn.md` — page 4 — `Identifying Workloads Outside MGN Scope` | Open | Infrastructure Lead | | Map | |
| Replication network path and connectivity | `implementation-guide-mgn.md` — page 3 — `Network Connectivity` | Open | Infrastructure Lead | | Task plan | |
| Who may install the replication agent (including vendor-managed servers) | `implementation-guide-mgn.md` — page 3 — `Tooling and Access` | Open | Infrastructure Lead | | Task plan | Install blocked by a third party on the day |
| Licence evidence for BYOL / vendor software | `implementation-guide-mgn.md` — page 17 — `BYOL License Mobility Documentation Completeness` | Open | Managing Director | | Go/no-go | Cutover gate cannot close |
| | | | | | | |

## Data — DataSync

| Guide requirement (Phase 1) | Guide address | Status | Asked of | Answer and label | Required by | Consequence if wrong |
|---|---|---|---|---|---|---|
| Source store type and readiness | `implementation-guide-datasync.md` — page 2 — source readiness | Open | Applications Lead | | Design | |
| Inventory: volume, object count, tiers, churn versus net growth | `implementation-guide-datasync.md` — page 4 — `Building the Source Inventory` | Open | Applications Lead | | Design | Window arithmetic wrong |
| Operating mode constraints (versioning, metadata, permissions) | `implementation-guide-datasync.md` — page 5 — `Selecting DataSync Operating Mode` | Open | Applications Lead | | Design | |
| Usable bandwidth and business cap | `implementation-guide-datasync.md` — page 5 — `Estimating the Transfer Window` | Open | Infrastructure Lead | | Design | Date promised that the link cannot meet; run `registers/window-arithmetic.md` |
| Egress eligibility and cost treatment | `implementation-guide-datasync.md` — page 5 — `Assessing Cloud-Exit Eligibility`; `sdd.md` — page 8 — `Connectivity and Source-Cloud Egress` | Open | Managing Director | | Requirements | Cost requirement unfounded |
| | | | | | | |

## Cross-cutting (every engagement)

| Fact | Address or source | Status | Asked of | Answer and label | Required by | Consequence if wrong |
|---|---|---|---|---|---|---|
| Hard deadline and what sets it | Customer only | Open | Managing Director | | Requirements | |
| Cutover window length and who owns it | Customer only | Open | Managing Director | | Requirements | |
| DNS / firewall change ownership and lead time | Customer only | Open | Infrastructure Lead | | Task plan | Physical constraint on the window missed |
| Compliance triggers: classification, residency, audit, retention | `sdd.md` — page 9 — `Deployment Tiers — Base and Enhanced`; page 18 — `Regulatory Considerations` | Open | Managing Director | | Requirements | Wrong tier |
| Rollback expectation per workload (what "back" means, and by when) | Customer only | Open | Applications Lead | | Design | |
| Operators: skills, and what they must not need to become | Customer only | Open | Managing Director | | Design | |
| | | | | | | |

## Close-out

- [ ] Every `Open` row has an owner, a required-by point and a consequence.
- [ ] At least one question traced to a guide section was asked and answered.
- [ ] One new customer requirement, if raised, is phrased as an outcome or constraint, not as a service.
- [ ] Nothing in the Answer column came from the guide.

**Workshop precedent:** Acme's three to five interview questions in Module 2 (DNS wait-time, `reporting-db` service tier, who may install the MGN agent on the vendor's connector) each traced to a row like these; the DNS answer became a dated requirement row and a task. Addresses above are for the workshop's bundle edition; rebuild them from your current reference set.
