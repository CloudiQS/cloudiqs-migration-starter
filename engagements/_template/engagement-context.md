# Migration Context — <ENGAGEMENT-REF>

<!-- Extract this from the customer's SDD (or your delivery standard) at engagement
     start. Review the WHOLE file per customer: commitments change between
     engagements, and a stale steering file constrains the agent to the wrong
     architecture. Keep it under ~60 lines so it stays loaded and readable. -->

## Architectural commitments

- Deployment tier: <base single-account | multi-account landing zone> — upgrade triggers: <compliance | residency | quota | credential isolation>
- Encryption: <at-rest defaults, in-transit requirements, key ownership>
- Credentials: <secrets manager of record; rotation posture; never in configs or code>
- Connectivity: <private path requirements; who owns firewall allow-listing on the source side>
- Cost framing: <one-time vs run-cost separation; egress treatment; the levers checked before any estimate>

## Working rules

- Citations: relative file plus heading or short quote; adapted guidance carries both the borrowed section and the gap.
- Decision lanes: executed-in-this-phase vs recorded-for-next-phase; every ADR labels its lane.
- Unknowns stay visible: owner, validation action, required-by date, consequence if false.
- Evidence is never fabricated; reference numbers are labelled as reference numbers.

## This Customer

- Business driver and dated dependency: <e.g., contract renewal, notice period>
- Source environment(s): <cloud/on-prem, regions, tenancy ownership>
- Workloads in scope: <name : technology : criticality : window>
- Databases: <engine and exact variant : size : change rate : replication capability — VERIFY, do not assume>
- Data stores: <type : volume : object/file count : archive tiers : daily churn vs net growth>
- Constraints: <windows, bandwidth caps, vendor boundaries, licence evidence status>
- Team: <who operates the target; what they must not have to become>
