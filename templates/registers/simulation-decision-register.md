# Simulation Decision Register — DMS Cutover Lab

> This register completes the Module 5/T12 **simulation decision**. It does not authorize a production cutover, DNS change, client repoint, or source retirement. When copied to `engagements/<engagement>/signoff/decision-register.md`, keep the full requirements trace beside it in `engagements/<engagement>/signoff/go-no-go.md` and `engagements/<engagement>/signoff/validation-register.md`.

## Scope and evidence mode

| Field | Value |
|---|---|
| Requirements / design / tasks | <REQ-v#> / <DES-v# FROZEN> / <TASK-v#> |
| Evidence mode | <live participant run / reference-pack review / both> |
| Decision applies to | <this participant lab / named reference run> |
| Production authorization | Not granted by this register |

## Technical decision gates

| Gate | Evidence path / observed value | Result | Disposition / owner |
|---|---|---|---|
| Full load and DMS validation | <task/table-statistics path; all in-scope tables complete; ValidationFailed = 0> | <PASS/FAIL/OPEN> | <action / name> |
| CDC evidence and final drain | <CloudWatch/console path or simulation attestation; write-stop and final-drain timestamps> | <PASS/FAIL/OPEN> | <action / name> |
| Stage-1 ↔ Stage-3 reconciliation | <baseline and reconcile artifact paths; exact match or approved tolerance> | <PASS/FAIL/OPEN> | <action / name> |
| Target application smoke | <health and orders artifact paths; HTTP status and observed result> | <PASS/FAIL/OPEN> | <action / name> |
| Rollback readiness | <rollback-readiness artifact; lab owner/RTO or actual approved owner/RTO> | <PASS/FAIL/OPEN> | <action / name> |

A simulation attestation must say what was observed and must be labelled `SIMULATION ONLY`. It is enough for a lab decision only when the other technical gates pass; it is never a substitute for measured production CDC-latency evidence.

## Decision

Choose one outcome and record the reason:

- **GO — simulation cutover approved:** every technical gate above is `PASS`. The participant may proceed only with the workshop’s simulated cutover discussion; no production action is authorized.
- **DEFER — simulation evidence incomplete:** one or more gates are `OPEN`; name the next evidence action and owner.
- **NO-GO — simulation gate failed:** one or more gates are `FAIL`; record the blocking condition and recovery action.

**Simulation decision:** <GO — simulation cutover approved / DEFER / NO-GO>
**Time:** <timestamp>
**Reason:** <evidence-based summary>

| Role | Name | Decision acknowledgement |
|---|---|---|
| Participant | | |
| Facilitator or peer reviewer | | |

## Production hand-off

A production `GO` requires the full `registers/go-no-go.md`, approved owner and RTO, measured CDC-latency evidence, all customer controls and preconditions, and the customer’s named approvers. This lab register records learning evidence only.
