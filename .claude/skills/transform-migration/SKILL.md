---
name: transform-migration
description: Step-by-step CloudiQS method for a cloud-to-AWS migration engagement (servers via MGN, databases via DMS, objects via DataSync), from qualification to signed go/no-go. Use when starting or progressing an engagement under engagements/.
---

# Transform migration engagement

Full reference: `templates/library/ssb-to-engagement-playbook.md` (ten steps, which guidance layer and which template each uses).

## Start a new engagement
1. `cp -r engagements/_template engagements/<engagement>` (slug: lowercase, hyphens).
2. Fill `engagements/<engagement>/engagement-context.md` from the customer brief and the SDD of the relevant SSB. Correct at least one line that assumes a scale, team or operating model the customer does not have.
3. Fill `templates/registers/customer-intake.template.md` into `analysis/intake.md`.

## Steps and gates
| Step | Do | Template | Gate |
|---|---|---|---|
| 0 Qualify | Applicability against the 1-Pager | none | G0 |
| 1 Reference set | Obtain current SSB pack, hash, convert by page, compare one page | `templates/library/MANIFEST.template.md`, `evidence-index.template.md` | G1 |
| 2 Map estate | Each workload to MGN / DMS / DataSync / retain / retire, with label | `templates/steering/engagement-context.template.md` | part of G2 |
| 3 Discover | 3 to 5 questions, each tied to a guide checklist row; classify answers | `templates/registers/discovery-checklist.template.md`, `window-arithmetic.md` | part of G2 |
| 4 Requirements | Register, then baseline; two approvals | `requirements-register.template.md`, `templates/spec/requirements.md` | G2, G3 |
| 5 Design | ADR-1..n, satellite decisions, waves back from the hard date; freeze | `templates/spec/design.md` | G4, G5 |
| 6 Tasks | Tasks with copied criteria; bidirectional audit (use `evidence-auditor`) | `templates/spec/tasks.md` | G6 |
| 7 Execute | Deploy target, endpoints, task, evidence phases | `infrastructure/`, `scripts/`, `configs/` | G7, G8 |
| 8 Decide | Validation, go/no-go and decision registers; sign | `templates/registers/go-no-go.md`, `validation-register.md` | G9 |
| 9 Sign off | One traced chain; production debt with owners | `migration-signoff.md`, `traceability-chain.md` | close |

## Database path commands (after G5)
```bash
cfn-lint infrastructure/cloudformation/target-mysql-dms.yaml
ENGAGEMENT=<e> aws cloudformation deploy --stack-name <e>-<env>-target \
  --template-file infrastructure/cloudformation/target-mysql-dms.yaml \
  --parameter-overrides file://engagements/<e>/configs/target-params.json \
  --capabilities CAPABILITY_NAMED_IAM
ENGAGEMENT=<e> scripts/create-dms-endpoints.sh
ENGAGEMENT=<e> scripts/capture-dms-validation-evidence.sh baseline
```
Then create the replication task from `configs/dms-task-settings.json` and the engagement's table mapping, and capture `preflight`, `inflight`, `reconcile`, `smoke`, `rollback-readiness` in order.

## Lessons from the reference run (acme-reference)
- Write R-data-integrity as: counts, key-column sums, max timestamps, distinct PKs match the Stage-1 baseline, and every discrepancy or suspended row has an owner-approved disposition. Then check each metric exists in the schema.
- Put the DNS TTL reduction in its own dated task; the cutover window depends on it.
- Satellite decisions (for example a full-load-only Azure SQL Database) need a task or backlog row and must not inherit CDC thresholds.
- The config hook catches `EnableValidation` missing; DMS validation is off by default.
