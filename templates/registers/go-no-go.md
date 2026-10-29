# Go/No-Go Register — <WORKLOAD> Cutover · <DATE>

> Name criteria before the window. Every `FAIL`, `OPEN`, or row with missing proof blocks `GO`. A disposition completes the record; it does not convert `OPEN` to `PASS`. Criteria are copied from the approved requirements baseline, and evidence must be actual or explicitly reference-sourced.

## Baseline and decision scope

| Field | Value |
|---|---|
| Requirements / design / tasks | <REQ-v#> / <DES-v# FROZEN> / <TASK-v#> |
| Evidence mode | <live participant run / reference-pack review> |
| Decision applies to | <this run, reference run, rehearsal, or named scope> |

| # | Requirement ID | ADR/design link | Task ID | Acceptance criterion copied unchanged | Evidence source / path or query / observed value | Result | Disposition / checked by |
|---|---|---|---|---|---|---|---|
| 1 | <R#> | <design § Validation design> | <T#> | <Stage-1 baseline criterion> | <source / path / value> | <PASS/FAIL/OPEN> | <action / name> |
| 2 | <R#> | <ADR-##> | <T#> | <in-flight validation criterion> | <source / path / value> | | |
| 3 | <R#> | <ADR-##> | <T#> | <latency/steady-state criterion or n/a rule> | <source / path / value> | | |
| 4 | <R#> | <design § Validation design> | <T#> | <Stage-3 comparison criterion> | <source / path / value> | | |
| 5 | <R#> | <cutover ADR> | <T#> | <critical-path smoke criterion> | <source / path / value> | | |
| 6 | <R#> | <rollback design> | <T#> | <rollback rehearsal/RTO criterion> | <source / path / value> | | |
| 7 | <R#> | <preconditions heading> | <T#> | <DNS, supplier, licence, control criterion> | <source / path / value> | | |
| 8 | <R#> | <ADR/design link> | <T#> | <engagement-specific exact criterion> | <source / path / value> | | |

## Decision

**GO / NO-GO / DEFER:** ________  **Time:** ________  **Reason:** ____________________

For a reference-pack path, write: `Decision on the reference run; no participant execution claimed.`

| Role | Name | Signature |
|---|---|---|
| Partner engagement lead | | |
| Customer owner (database/application) | | |
| <third party if required> | | |
