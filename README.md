# CloudiQS Migration Starter

**Private. Internal to CloudiQS.** A Claude Code repo for running cloud-to-AWS migration engagements (BPTAO Transform) with hard gates: approved requirements, frozen design, accepted tasks, captured evidence, signed decision.

Built 29 Oct 2026 from the AWS Workshop Studio event "From SSB to Migrated Workload" completed by Steve Kodra. The method and templates are adapted from the workshop's take-home kit, which was written for partner reuse. The infrastructure and scripts were rewritten for customer accounts with no hardcoded values.

## What is here

| Path | What it is |
|---|---|
| `CLAUDE.md`, `AGENTS.md` | Agent instructions and golden rules |
| `.claude/rules/` | Gates G0 to G9, evidence rules, no-hardcoding rule |
| `.claude/agents/` | `migration-consultant` (does the work) and `evidence-auditor` (read-only audit) |
| `.claude/skills/transform-migration/` | Step-by-step method with commands |
| `.claude/hooks/` | `freeze-gate.py` blocks cloud changes before freeze and edits to frozen specs; `validate-dms-task-config.py` checks DMS task settings; `selftest.sh` |
| `templates/` | Spec, register, library and steering templates |
| `engagements/_template/` | Blank engagement to copy |
| `engagements/acme-reference/` | Worked example (fictional customer): approved REQ-v1, frozen DES-v1, draft tasks |
| `infrastructure/cloudformation/target-mysql-dms.yaml` | RDS or Aurora MySQL target plus DMS (provisioned or Serverless), snapshot on delete, all parameters |
| `scripts/` | DMS endpoints, evidence capture (6 read-only phases), task watcher, validation SQL template |
| `configs/` | Validated DMS task settings, table mapping and env templates |
| `product/CQ-TRN-001.yaml` | BPTAO product contract, **proposal**: pricing, owner and IaC formats to decide |

## Start an engagement

```bash
cp -r engagements/_template engagements/<customer-slug>
claude   # then: "Use the migration-consultant agent to start engagement <customer-slug>"
```

Customer engagements with real data belong in a private repo per customer (or the customer's own GitHub), not in this starter.

## Checks

```bash
cfn-lint infrastructure/cloudformation/*.yaml
shellcheck -S warning scripts/*.sh
bash .claude/hooks/selftest.sh
```

## Status and limits

- Database path (DMS) is scripted and linted but **not yet deployed from this repo**. First run should be a rehearsal in a CloudiQS sandbox account.
- MGN (servers) and DataSync (files) are planned in the method; runbooks and IaC still to build.
- Terraform and CDK versions of the target stack are not built yet (BPTAO requires all three).
- Hook and permission formats follow Claude Code's settings and hooks documentation as understood on 29 Oct 2026; verify against current docs if behaviour differs.
- No SSB PDFs are stored. Obtain current packs from AWS Partner Central under their access terms per engagement.
