# Requirements — <WORKLOAD> Migration

> **Planning-owned spec file:** `engagements/<engagement>/spec/requirements.md`
> Delivery reads this file but does not edit it. Replace every placeholder before approval.

## Baseline metadata

| Field | Value |
|---|---|
| Baseline version | <REQ-v0.1> |
| Status | <draft / approved / superseded> |
| Prepared by / at | <name> / <ISO-8601> |
| Approved by / at | <participant name> / <ISO-8601; blank until explicit approval> |
| Supersedes | <baseline or none> |
| Change summary | <what changed and why> |

Stable IDs are permanent. Add new IDs; never renumber an existing requirement. Mark retired requirements `retired` and retain their history. A requirement is not approval-ready unless its acceptance criterion can produce a pass or fail from named evidence.

## Requirements register

| ID | Requirement or constraint | Source | Status | Measurable acceptance criterion (copy unchanged into tasks and registers) | Open evidence | Owner | Required by | Consequence if unmet |
|---|---|---|---|---|---|---|---|---|
| R1 | <dated dependency or business outcome> | <fact ID, interview, or file + heading> | <proposed / confirmed / provisional / retired> | <observable threshold, timestamp, comparison, or signed artifact that determines pass/fail> | <missing proof or none> | <role> | <date or gate> | <scope, schedule, cost, design, or no-go impact> |
| R2 | <interruption or recovery constraint> | <source> | <status> | <start/end points, maximum duration, and evidence path> | <gap> | <role> | <gate> | <impact> |
| R3 | <data-integrity outcome> | <source> | <status> | <metrics, tolerance, and required disposition> | <gap> | <role> | <gate> | <impact> |
| R4 | <operability, control, supplier, or cost outcome> | <source> | <status> | <measurable criterion> | <gap> | <role> | <gate> | <impact> |

## Assumptions

Assumptions are visible planning liabilities, not facts or requirements.

| ID | Assumption | Source/status | Owner | Validation action and expected evidence | Required by | Consequence if false |
|---|---|---|---|---|---|---|
| A1 | <assumption> | <source> / open | <role> | <how it will be tested and where evidence will be stored> | <date or gate> | <impact and fallback> |

## Open evidence and discovery actions

| ID | Requirement/assumption IDs | Evidence needed | Owner | Required by | Expected path or source | Status / consequence if late |
|---|---|---|---|---|---|---|
| D1 | <R# / A#> | <question, measurement, supplier letter, or assessment> | <role> | <date or gate> | <path, system, or named source> | <open / obtained / rejected; impact> |

## Baseline approval check

- [ ] Every active requirement has a stable ID, source, status, measurable acceptance criterion, and open-evidence statement.
- [ ] Every open item has an owner, required-by point, and consequence.
- [ ] Each acceptance criterion is written so Module 4 can copy it unchanged into tasks and registers; the task-coverage audit happens after `tasks.md` exists.
- [ ] Proposed solution names appear in design options, not as disguised requirements.
- [ ] The participant explicitly approved the baseline metadata above.
