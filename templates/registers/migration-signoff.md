# Migration Sign-Off — <WORKLOAD> · <DATE>

> Record what this rehearsal, lab, or reference review proved and what production still owes. Do not claim more than the linked evidence.

## Baselines and evidence scope

| Field | Value |
|---|---|
| Requirements / design / tasks | <REQ-v#> / <DES-v# FROZEN> / <TASK-v#> |
| Evidence source | <live participant run / reference-pack / supplied rehearsal> |
| Decision register | <path and signed decision> |
| Scope boundary | <workload, environment, scale, exclusions> |

## What was proven

| Requirement ID | ADR/design link | Task ID | Criterion copied unchanged | Actual evidence source/path/value | Result / claim supported |
|---|---|---|---|---|---|
| <R#> | <ADR-##> | <T#> | <exact criterion> | <source / path or query / value / timestamp> | <bounded claim> |

For reference-pack evidence, use wording such as `The participant inspected and dispositioned reference-run evidence`; do not claim that they executed the migration.

## What production still owes

| Affected requirement/ADR/task | Item | Owner | Required by | Consequence if incomplete |
|---|---|---|---|---|
| <R# / ADR-## / T#> | Rollback rehearsal at production scale with recorded RTO | <role> | before window | <no-go or replan> |
| <R# / ADR-## / T#> | Production-scale timing under representative churn | <role> | before window booking | <window remains provisional> |
| <R# / ADR-## / T#> | <deferred dimensions or preconditions> | <role> | <gate> | <impact> |

## Boundaries

This sign-off is a workshop/rehearsal record. It is not production approval, a contractual commitment, a fixed price, or a licensing determination. Estimates remain ranges with assumptions and re-range triggers.

| Role | Name | Date |
|---|---|---|
| Prepared by | | |
| Reviewed by | | |
