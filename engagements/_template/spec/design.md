# Design — <WORKLOAD> Migration

> **Planning-owned spec file:** `engagements/<engagement>/spec/design.md`
> Delivery reads this file as the execution baseline and cannot edit it.

## Baseline and freeze metadata

| Field | Value |
|---|---|
| Design baseline version | <DES-v0.1> |
| Requirements baseline served | <REQ-v#> |
| Status | <draft / increment-approved / frozen / superseded> |
| Prepared by / at | <name> / <ISO-8601> |
| Frozen by | <participant name; blank until explicit freeze> |
| Frozen at | <ISO-8601; blank until explicit freeze> |
| Freeze status | <NOT FROZEN / FROZEN> |
| Supersedes | <baseline or none> |
| Change summary | <what changed, affected requirement IDs, and why> |

A `FROZEN` design, paired with the named requirements baseline, is the only delivery execution baseline. A requirement, acceptance criterion, ADR, lane, or parameter change creates a new planning baseline and requires a new freeze before delivery resumes.

## Incremental approval record

Incremental approval confirms a decision for convergence; it does not freeze the whole design.

| Increment / ADR | Status | Reviewed or approved by | At | Conditions, dissent, or required proof |
|---|---|---|---|---|
| ADR-01 | <draft / approved / deferred> | <name> | <ISO-8601> | <condition or none> |
| ADR-02 | <draft / approved / deferred> | <name> | <ISO-8601> | <condition or none> |

## Parameter block

| Parameter | Frozen value | Requirements served | Lane | ADR/design link | Validation or disqualifying condition |
|---|---|---|---|---|---|
| <target/service shape> | <value> | <R#> | <executed this phase / recorded for next phase> | <ADR-01> | <proof or stop condition> |
| <migration mode/capacity> | <value> | <R#> | <lane> | <ADR-01> | <proof or stop condition> |
| <availability shape> | <value> | <R#> | <lane> | <ADR-##> | <proof or stop condition> |
| <cutover/repoint approach> | <value> | <R#> | <lane> | <ADR-##> | <proof or stop condition> |

The `Requirements served` column is mandatory. A parameter that serves no requirement does not enter the frozen baseline.

## Decisions in force

Repeat this block for each stable ADR ID; never renumber an ADR.

### ADR-01 — <decision title>

- **Requirements served:** <R# list; name the dominant requirement and why it dominates>
- **Increment status:** <draft / approved / deferred> · **Approved by/at:** <name / ISO-8601 or blank>
- **Decision:** <choice or explicit deferral>
- **Lane:** <executed this phase / recorded for next phase>
- **Alternatives considered:** <options weighed against the named requirements, including retain/do-nothing where credible>
- **Customer evidence:** <fact IDs, interview, or file + heading>
- **Guidance evidence:** <file + heading; adapted guidance names both the borrowed section and the gap>
- **Assumptions:** <A# with owner and validation route>
- **Disqualifying condition:** <condition that stops or changes the choice>
- **Deciding proof:** <measurement, review, supplier evidence, rehearsal, or proof of concept; owner and required-by point>
- **Consequences:** <operating model, cost category, schedule, controls, or skills impact>
- **Changes if:** <evidence or requirement change that reopens this ADR>
- **Tasks affected:** <T# once delivery authors tasks>

## Constraints inherited from steering

Reference `engagements/<engagement>/engagement-context.md`; list only constraints that bind generated artifacts. Do not silently copy or weaken them.

| Constraint | Source | Requirements served | Design consequence | Open proof / owner / required by |
|---|---|---|---|---|
| <constraint> | <file + heading> | <R#> | <parameter, ADR, or task consequence> | <proof / role / gate> |

## Validation design

| Requirement ID | Acceptance criterion copied from `requirements.md` | ADR/design link | Planned task ID | Expected evidence source/path/value | Failure disposition |
|---|---|---|---|---|---|
| <R#> | <paste exactly; do not paraphrase> | <ADR-## or heading> | <T# placeholder until tasks exist> | <query, metric, artifact, threshold> | <block, rollback, investigate, or accepted exception owner> |

## Freeze check

- [ ] Every decision and parameter names the requirements served.
- [ ] Increment approvals, conditions, and dissent are recorded.
- [ ] Every active acceptance criterion has a validation design and expected evidence.
- [ ] Open assumptions have owners, proofs, required-by points, and consequences.
- [ ] Frozen by, frozen at, freeze status, requirements baseline, and design baseline are complete.
- [ ] The participant explicitly signed the freeze; file existence alone is not approval.
