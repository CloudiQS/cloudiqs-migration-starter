# Transfer Chain — <ANONYMISED ENGAGEMENT>

> Neutral template. Adapt the method and fields, not sample-customer facts, choices, evidence, or results. Mark absent execution evidence `NOT RUN / OPEN`; never turn expected evidence into proof.

## Baseline metadata

| Field | Value |
|---|---|
| Chain ID | <CHAIN-01> |
| Requirements baseline | <REQ-v# / approved by / at> |
| Design baseline | <DES-v# / frozen by / at> |
| Task-list baseline | <TASK-v# / accepted by / at> |
| Evidence mode | <live / reference-pack / planned-not-run> |
| Owner / reviewer / at | <role> / <name> / <ISO-8601> |

Copy the chain block once per inspectable promise. Stable IDs are never renumbered.

## CHAIN-01 — <short outcome>

### 1. Customer fact and guidance boundary

| Field | Value |
|---|---|
| Customer fact or constraint | <anonymised fact stated without solution language> |
| Customer source / status | <interview, file, measurement / confirmed, proposed, provisional, open> |
| Guidance evidence | <relative file + heading; use short text only after live verification> |
| Direct, adapted, or boundary | <DIRECT / ADAPTED with borrowed section + gap / NOT COVERED> |
| What the evidence does not establish | <remaining customer, supplier, technical, cost, or production proof> |

### 2. Requirement

| Field | Value |
|---|---|
| Requirement ID | <R#> |
| Requirement | <customer outcome or constraint> |
| Measurable acceptance criterion | <observable threshold, comparison, timestamp, or signed evidence that returns pass/fail> |
| Open evidence | <missing proof or none> |
| Owner / required by / consequence | <role> / <date or gate> / <impact if unmet> |

### 3. Decision

| Field | Value |
|---|---|
| ADR/design link | <ADR-## or design heading> |
| Requirements served / dominant | <R# list / dominant R# and reason> |
| Decision and lane | <choice or explicit deferral> / <executed this phase or recorded for next phase> |
| Alternatives considered | <credible alternatives, including retain/defer where relevant> |
| Disqualifying condition | <what stops or changes the choice> |
| Deciding proof / owner / required by | <proof> / <role> / <date or gate> |
| Increment approval | <draft / approved by / at / conditions or dissent> |

### 4. Task and unchanged criterion

| Field | Value |
|---|---|
| Task ID / group | <T#> / <artifact, execution, hand-off, or backlog> |
| Task | <single verifiable action> |
| Requirement IDs and ADR/design link | <R#> / <ADR-## or heading> |
| Acceptance criterion copied unchanged | <paste the exact requirement criterion; do not paraphrase> |
| Expected evidence source / path / value | <system or artifact> / <path or query> / <expected threshold> |

### 5. Actual evidence and disposition

| Field | Value |
|---|---|
| Actual evidence source | <live command/system, reference-pack, supplied anonymised artifact, or NOT RUN> |
| Actual evidence path or query | <resolvable path/query, or NOT AVAILABLE> |
| Observed value and timestamp | <actual value/time, or NOT AVAILABLE> |
| Result | <PASS / FAIL / OPEN / NOT RUN> |
| Disposition / owner / required by | <accept, block, rollback, investigate, or planned action> / <role> / <date or gate> |
| Consequence and downstream links | <effect on decision, tasks, wave, cutover, or commitment> |

## Chain audit

- [ ] Customer fact and guidance evidence name sources and boundaries.
- [ ] Requirement is solution-neutral and has a measurable criterion.
- [ ] Decision follows named requirements and records lane, alternative, disqualifier, and deciding proof.
- [ ] Task links to requirement and design; its criterion is copied character-for-character.
- [ ] Expected and actual evidence are separate.
- [ ] Actual evidence has source, path/query, observed value, result, and disposition — or an honest `NOT RUN / OPEN` record with owner and required-by point.
- [ ] A changed requirement or decision points back to planning for a new baseline and freeze.
