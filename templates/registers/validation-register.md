# Migration Validation Register — <WORKLOAD> · <DATE>

> Evidence must resolve to an actual source, path/query, observed value, and timestamp. Expected evidence is not proof. Reference-pack values are labelled and never presented as participant execution.

## Baseline and evidence mode

| Field | Value |
|---|---|
| Requirements baseline | <REQ-v#> |
| Frozen design baseline | <DES-v#> |
| Accepted task list | <TASK-v#> |
| Evidence mode | <live / reference-pack> |
| Prepared / reviewed by | <name> / <name> |

## Acceptance-chain index

| Chain ID | Requirement ID | ADR/design link | Task ID | Acceptance criterion copied unchanged from requirements | Evidence source | Result / disposition |
|---|---|---|---|---|---|---|
| C1 | <R#> | <ADR-## / heading> | <T#> | <exact criterion> | <live / reference-pack> | <PASS / FAIL / OPEN; owner/action> |

## Stage 1 ↔ Stage 3 metrics

Stage 1 is captured before transfer; for a quiesce source, capture it at write-stop. Stage 3 follows CDC latency reaching zero or full-load completion. Split rows when one criterion needs multiple metrics.

| Chain ID | Database/table | Metric | Stage-1 source/path/value/time | Stage-3 source/path/value/time | Result | Disposition / owner |
|---|---|---|---|---|---|---|
| C1 | <db.table> | row_count | <source / query or artifact / value / timestamp> | <source / query or artifact / value / timestamp> | <PASS/FAIL/OPEN> | <action / role> |
| C1 | <db.table> | sum_<col> | | | | |
| C1 | <db.table> | max_<ts> | | | | |
| C1 | <db.table> | distinct_pk | | | | |

## In-flight validation — CDC sources

| Chain ID | Task ID | Evidence source/path/time | ValidationFailed | ValidationSuspended | CDCLatencySource | CDCLatencyTarget | Result / disposition |
|---|---|---|---|---|---|---|---|
| C1 | <T#> | <command/metric path/time> | | | | | |

Suspended rows are unconfirmed, not failed. Investigate before GO; do not average or omit them.

## Register rules

- Every row traces to a requirement, ADR/design link, task, and unchanged acceptance criterion through the chain index.
- Values come from executed queries/system reads or a clearly labelled reference pack, never memory or expectation.
- Every difference, suspended row, and missing proof has a result and disposition. Every `FAIL`, `OPEN`, or missing proof blocks `GO`; the participant instead records `NO-GO` or `DEFER` when evidence is unresolved.
- A disposition completes the record but does not convert `OPEN` to `PASS`. A reader must not need a verbal explanation; put the evidence gap and next action in the disposition.
