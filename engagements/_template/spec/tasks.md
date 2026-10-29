# Tasks — <WORKLOAD> Migration

> **Delivery-owned spec file:** `engagements/<engagement>/spec/tasks.md`
> `requirements.md` and `design.md` are read-only inputs. Do not author or execute tasks until their named baselines are approved and frozen.

## Execution-baseline metadata

| Field | Value |
|---|---|
| Requirements baseline | <REQ-v#> |
| Design baseline | <DES-v#> |
| Design freeze status / by / at | <FROZEN> / <name> / <ISO-8601> |
| Task-list version / status | <TASK-v0.1> / <draft / accepted / executing / closed> |
| Authored by / at | <delivery owner> / <ISO-8601> |
| Change request path | <output path used if the frozen baseline must change> |

Every task row must contain actual requirement IDs and an ADR or design link before acceptance. Copy acceptance criteria exactly from `requirements.md`; do not paraphrase. Expected evidence describes what should exist. Actual evidence remains `NOT RUN` until execution produces a source, path, value, and result.

## Group 1 — Artifact generation

| Task ID | Task | Requirement IDs | ADR/design link | Lane | Group | Acceptance criterion copied from requirements | Expected evidence (source/path/value) | Runtime actual evidence (source/path/value) | Result / disposition |
|---|---|---|---|---|---|---|---|---|---|
| T1 | Verify source prerequisites and record unresolved gaps | <R#> | <ADR-## / prerequisite heading> | executed this phase | artifact generation | <exact criterion text> | <checklist path; expected settings and named confirmations> | NOT RUN — <source/path/value> | <not run / pass / fail; owner and action> |
| T2 | Parameterize the target template from the frozen parameter block | <R#> | <design § Parameter block / ADR-##> | executed this phase | artifact generation | <exact criterion text> | <parameter file path; values equal frozen block> | NOT RUN — <source/path/value> | <status/disposition> |
| T3 | Generate source and target endpoint configurations; secrets remain references | <R#> | <ADR-## / constraints heading> | executed this phase | artifact generation | <exact criterion text> | <configuration paths; lint/security check> | NOT RUN — <source/path/value> | <status/disposition> |
| T4 | Generate migration-task configuration with validation and named schema behavior | <R#> | <ADR-## / validation design> | executed this phase | artifact generation | <exact criterion text> | <task settings path; validation hook result> | NOT RUN — <source/path/value> | <status/disposition> |
| T5 | Generate Stage-1 baseline and Stage-3 comparison queries | <R#> | <design § Validation design> | executed this phase | artifact generation | <exact criterion text> | <query path; tables/metrics/tolerances covered> | NOT RUN — <source/path/value> | <status/disposition> |
| T6 | Generate watch, evidence-capture, and validation scripts | <R#> | <design § Validation design> | executed this phase | artifact generation | <exact criterion text> | <script paths; dry validation result> | NOT RUN — <source/path/value> | <status/disposition> |

## Group 2 — Execution

| Task ID | Task | Requirement IDs | ADR/design link | Lane | Group | Acceptance criterion copied from requirements | Expected evidence (source/path/value) | Runtime actual evidence (source/path/value) | Result / disposition |
|---|---|---|---|---|---|---|---|---|---|
| T7 | Deploy the target and verify outputs against the frozen parameter block | <R#> | <design § Parameter block / ADR-##> | executed this phase | execution | <exact criterion text> | <deployment event/output path and expected values> | NOT RUN — <source/path/value> | <status/disposition> |
| T8 | Run connectivity, secret-resolution, prerequisite, and rollback-readiness pre-flight | <R#> | <ADR-## / design § Validation design> | executed this phase | execution | <exact criterion text> | <connection tests, prerequisite checks, current rollback rehearsal/RTO evidence> | NOT RUN — <source/path/value> | <status/disposition> |
| T9 | Execute transfer to the frozen steady-state condition | <R#> | <ADR-## / migration-mode parameter> | executed this phase | execution | <exact criterion text> | <task status/statistics and latency path/value> | NOT RUN — <source/path/value> | <status/disposition> |
| T10 | Stop source writes, capture the start timestamp, and drain to the frozen final condition | <R#> | <ADR-## / cutover parameter> | executed this phase | execution | <exact criterion text> | <write-stop log, final-condition metrics, timestamps> | NOT RUN — <source/path/value> | <status/disposition> |
| T11 | Compare Stage-3 results with Stage-1, disposition anomalies, run the named business smoke test, and capture completion | <R#> | <design § Validation design / ADR-##> | executed this phase | execution | <exact criterion text> | <validation register values, dispositions, smoke output, completion timestamp> | NOT RUN — <source/path/value> | <status/disposition> |
| T12 | Complete the traced go/no-go register and obtain the participant decision | <R# list covering every criterion> | <design freeze + validation design> | executed this phase | execution | <exact criteria copied per register row> | <go/no-go path with evidence links and participant signature> | NOT RUN — <source/path/value> | <GO / NO-GO / deferred; reason> |

## Group 3 — Hand-off and platform backlog

| Task ID | Task | Requirement IDs | ADR/design link | Lane | Group | Acceptance criterion copied from requirements | Expected evidence (source/path/value) | Runtime actual evidence (source/path/value) | Result / disposition |
|---|---|---|---|---|---|---|---|---|---|
| T13 | Produce <deferred dimension or operating runbook> | <R#> | <ADR-##> | recorded for next phase | hand-off | <exact criterion text> | <owned backlog/runbook path and due date> | NOT RUN — <source/path/value> | <owner/status/consequence> |
| T14 | Complete dated cutover precondition <DNS, supplier, licence, or control> | <R#> | <ADR-## / precondition heading> | <executed or recorded> | hand-off | <exact criterion text> | <named letter, metric, configuration read, or approval path/value> | NOT RUN — <source/path/value> | <owner/status/consequence> |
| T15 | Record each out-of-catalog item with its affected requirement IDs and owner | <R# for each child item> | <ADR/design boundary> | recorded for next phase | platform backlog | <exact criterion text or explicit non-acceptance dependency> | <backlog path; owner; required-by; consequence> | NOT RUN — <source/path/value> | <owner/status/consequence> |

## Bidirectional acceptance audit

| Check | Result | Disposition |
|---|---|---|
| Every active requirement ID is served by at least one task | <pass/fail> | <missing task or none> |
| Every task names at least one active requirement ID | <pass/fail> | <scope removal or requirement link> |
| Every task links to an ADR/design heading and lane/group | <pass/fail> | <fix> |
| Every acceptance criterion is copied unchanged into the relevant task and register row | <pass/fail> | <fix> |
| Every completed task has actual evidence source/path/value and a result/disposition | <pass/fail> | <not run or fix> |
