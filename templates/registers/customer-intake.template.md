# Anonymised Customer Intake — Bring Your Own Customer

> **Anonymise before intake.** No company/person names, domains, account IDs, IP addresses, secrets, regulated records, or identifying details. The method needs the estate shape, not its identity. Generalise any risky field.

## One batched question set

| Area | Anonymised answer |
|---|---|
| Sector and rough scale | |
| Source environment(s) and tenancy ownership | |
| Workloads and exact technology/service variants | |
| Databases: engine/variant, size, change rate, replication capability if known | |
| Stores: type, volume, count, archive tiers, churn versus net growth | |
| Outcomes and dated dependencies | |
| Interruption, recovery, and rollback expectations per workload | |
| Operators: skills and what they must not need to become | |
| Cost posture: target, basis, included/excluded categories | |
| Compliance triggers: classification, residency, audit, retention | |
| Supplier constraints: support, install rights, licence evidence | |
| Connectivity: capacity, business cap, firewall/DNS ownership | |

## Progressive outputs — create and approve in order

1. **Assessment:** per-workload service map (servers → MGN, databases → DMS, files/objects → DataSync), one cited constraint per row, explicit coverage gaps, evidence confidence, and consequential questions.
2. **Requirements:** stable IDs; source/status; measurable criterion; open evidence; owner; required-by point; consequence. Approve the register, then approve the matching requirements baseline. Do not hide service choices in requirements.
3. **Design:** requirements-led ADRs with lane, alternatives, guidance/customer evidence, disqualifier, deciding proof, and increment approval. Freeze the named design baseline before delivery planning.
4. **Tasks:** stable IDs linked to requirement and ADR/design; criterion copied unchanged; expected evidence separate from actual evidence. Audit requirements ↔ tasks in both directions.
5. **Evidence and decision:** source/path/value, result, disposition, and signed scope. If nothing ran, record `NOT RUN / OPEN` with owner and next action.
6. **Transfer chain:** use the kit-local `registers/traceability-chain.md` to inspect one promise end to end.

## Starter output

For a 15-minute starter, stop after assessment plus one draft chain:

`customer fact → proposed requirement/criterion → provisional decision → planned task → expected evidence → NOT RUN / OPEN disposition`

Mark every output **ANONYMISED DRAFT / NOT CUSTOMER-READY**. A confident "this library barely applies" is valid when evidence supports it.
