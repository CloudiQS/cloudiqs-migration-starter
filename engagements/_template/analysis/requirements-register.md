# Requirements Register — <CUSTOMER>

> The working analysis behind `requirements.md`. Approve this register first; derive the spec baseline from it second, preserving IDs and criteria; approve that separately. In the workshop these were Module 2, steps 5 and 6, and your own filled copy is `engagements/<engagement>/analysis/requirements-register.md`.
>
> **Scoring test for every row:** could a reader mark it pass or fail from the criterion alone? A row that fails the test is rewritten or rejected, not approved. "It all looks fine" is not an available answer.

## Baseline metadata

| Field | Value |
|---|---|
| Register version / status | <REG-v0.1> / <draft / approved / superseded> |
| Owner / prepared at | <role> / <ISO-8601> |
| Approved by / at | <customer or partner role> / <blank until explicit approval> |
| Supersedes / change reason | <none or version> / <reason and affected IDs> |
| Reference set | `ssb/MANIFEST.md` dated <date>; `discovery-checklist` dated <date> |

Use stable IDs. Add IDs; never renumber. Retire an ID while retaining history.

## Requirements and constraints

| ID | Requirement or constraint | Source / status | Measurable acceptance criterion | Open evidence | Owner | Required by | Consequence if unmet |
|---|---|---|---|---|---|---|---|
| R1 | <dated dependency or business outcome> | `[CUSTOMER]` <role, date> / <proposed, confirmed, provisional> | <observable threshold, comparison, timestamp, or signed artifact returning pass/fail> | <missing proof or none> | <role> | <date/gate> | <scope/schedule/cost/no-go impact> |
| R2 | <interruption or recovery constraint, including any physical lead time such as a DNS change> | <source/status> | <start/end points, tolerance, evidence path> | <gap> | <role> | <gate> | <impact> |
| R3 | <data integrity outcome> | <source/status> | <baseline-to-final comparison method and tolerance; see the guide's validation stages> | <gap> | <role> | <gate> | <impact> |
| R4 | <data, operability, supplier, control, or cost outcome> | <source/status> | <measurable criterion> | <gap> | <role> | <gate> | <impact> |

Cover dated dependencies, per-workload interruption and recovery, supplier and support terms, operability, cost and its basis, control and recovery, and applicable classification, residency, audit and retention requirements. Write outcomes and constraints; an AWS service name is a solution, not a requirement.

Where a row's criterion comes from the guidance (for example a validation method), cite the address: `<derivative> — page N — anchor`. Where it comes from the customer, quote the words and name who said them.

## Assumptions

| ID | Assumption | Source/status | Owner | Validation action and expected evidence | Required by | Consequence if false |
|---|---|---|---|---|---|---|
| A1 | <assumption> | <source> / open | <role> | <test and evidence source/path/value> | <gate> | <design/scope/schedule/cost impact> |

## Discovery actions

| ID | Requirement/assumption IDs | Evidence needed | Owner | Required by | Expected source/path | Status / consequence if late |
|---|---|---|---|---|---|---|
| D1 | <R# / A#> | <question, measurement, supplier record, or assessment> | <role> | <gate> | <path/system/source> | <open; impact> |

## Approval and next layer

- [ ] Every active row has source/status, measurable criterion, open-evidence statement, owner, required-by point, and consequence.
- [ ] Every row passes the scoring test.
- [ ] Criteria describe outcomes, not preferred services.
- [ ] Assumptions remain separate and owned.
- [ ] The riskiest row is named, and agreed or replaced.
- [ ] Explicit approval recorded above.
- [ ] After approval, derive `requirements.md` from `specs/migration-spec.template/requirements.md`, preserving IDs and criteria; compare at least two rows side by side; approve it separately before design.
