# Source Assessment — Acme Outdoor Supplies

> Draft, Module 2 Step 2. Second pass checking `brief/customer-brief.md` (R1–R8) against the six discovery CSVs under `discovery/`. Evidence labelled `[DISCOVERY]`, `[CUSTOMER]`, `[SSB-DIRECT]`, `[SSB-ADAPTED]`, or `[OPEN]`.

## WKL-101 — dispatch-api (+ WKL-102 nightly rollup, folded into the same host)

- `AZ-VM-001`, Ubuntu 22.04, 4 vCPU / 16 GB / 128 GB, criticality critical, confidence high `[DISCOVERY]` (`servers.csv`).
- `servers.csv` notes: "Dispatch API and nightly rollup cron co-located" — confirms the Module 1 fold-in call. `[DISCOVERY]`
- CPU average 28%, p95 55%, peak 72%; memory average 61%, p95 74%, peak 80% `[DISCOVERY]` (`performance_metrics.csv`) — headroom exists for a replication agent, memory is the tighter margin.
- Dependencies (`connections.csv`): CON-101 to dispatch-db (synchronous, "api-and-database-must-be-sequenced"); CON-102 to dispatch-blob over HTTPS ("blob-final-sync-before-application-cutover"). Both are cutover-sequencing constraints, not just data flows.
- Known window: 4-hour Sunday maintenance window `[CUSTOMER]` (brief).

## WKL-103 — WMS connector

- `AZ-VM-002`, Windows Server 2019, vendor-owned, criticality high, confidence medium `[DISCOVERY]`. Notes: "believed to use Azure Hybrid Benefit — unverified."
- Dependency CON-105: outbound to dispatch-api, "vendor-connector-revalidation-after-cutover" `[DISCOVERY]`.
- R6 (vendor support terms valid on AWS) is unconfirmed; licence evidence (Software Assurance / License Mobility) is `[OPEN]` — owner: Applications Lead and procurement, required before cutover, not before replication.

## WKL-104 — dispatch-db (Azure Database for MySQL)

- Azure Database for MySQL 8.0 Flexible Server, 260 GB, ~4 GB/month growth, 95 TPS peak `[DISCOVERY]` (`databases.csv`); corroborated by `performance_metrics.csv` (38 avg / 78 p95 / 95 peak TPS).
- `cdc_observed: unknown`, `schema_assessment_complete: false`, `backup_restore_tested: unknown` `[DISCOVERY]` — all three stay `[OPEN]`.
- **Engine gap, carried from Module 1:** Azure Database for MySQL is absent from the DMS guide's supported-engine list (`implementation-guide-dms.md`, `## Source page 4`). `[SSB-ADAPTED]`, stays `[OPEN]` until Module 3's ADR-1.
- Binary log format and retention: not in the discovery export. `[OPEN]` — interview question.

## WKL-105 — reporting-db (Azure SQL Database)

- Azure SQL Database (current tier not stated in export), 40 GB, ~1 GB/month growth, 12 TPS peak `[DISCOVERY]`.
- `cdc_observed: false` — confirms the Module 1 / Step 3 answer: full-load only, no CDC. `[DISCOVERY]` + `[SSB-DIRECT]`.
- Variant is Azure SQL Database, not Managed Instance, matching the brief. `[DISCOVERY]`

## WKL-106 — dispatch-blob

- 11.6 TB, 9.2M objects, 1.4 TB in archive tier `[DISCOVERY]` (`storage.csv`).
- Growth vs. churn — both true, not a conflict: monthly net growth ~140 GB (`storage.csv`), while daily object churn averages 128 GB/day, p95 152, peak 160 GB/day (`performance_metrics.csv`, `STO-101`). `[DISCOVERY]` Sizing a final incremental sync on the 140 GB/month growth figure instead of the >100 GB/day churn figure would badly understate transfer time, because most daily writes replace short-lived objects rather than adding net volume.
- Archive rehydration lead time and cost: not in the export. `[OPEN]` — interview question, consequence: threatens R1's 15 November exit date if rehydration takes longer than planned.

## WKL-107 — payroll

- SaaS, stays, no infrastructure to migrate `[PARTNER-JUDGMENT]`, confirmed by `workloads.csv` (`state_profile: vendor-hosted`).
- CON-107: monthly CSV export only, "manual-process-no-technical-coupling" `[DISCOVERY]` — confirms no migration dependency.

## WKL-108 — legacy-monitor

- `AZ-VM-003`, Windows Server 2016, criticality low, no interactive logins observed in 90 days `[DISCOVERY]`.
- CPU utilization near-idle: 2% average, 6% peak `[DISCOVERY]` — corroborates the retirement call.
- Retire, but only after its owner confirms nothing still depends on it `[PARTNER-JUDGMENT]` — discovery action, owner Infrastructure Lead, before decommission (not before cutover).

## Cross-cutting, confirmed by the export

- Shared internet link: `WAN-101` shows 250–400 Mbps available for migration during business hours, with business-hours utilization already at 210–410 Mbps `[DISCOVERY]`. This corroborates R3 as a bandwidth-sharing constraint, not just a qualitative one.
- Cutover window: one 4-hour Sunday window, must include validation and rollback `[CUSTOMER]` (brief) — every migration method must fit inside it.
- DNS wait-time (TTL) governing the cutover: not in the export. `[OPEN]` — interview question.
