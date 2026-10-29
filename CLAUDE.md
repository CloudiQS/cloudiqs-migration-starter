# CloudiQS Migration Starter (BPTAO Transform)

This repo runs CloudiQS cloud-to-AWS migration engagements with Claude Code. The method: bounded guidance plus customer evidence gives approved requirements, then a frozen design, then accepted tasks, then evidence, then a signed decision. It was proven on the AWS "From SSB to Migrated Workload" workshop (Oct 2026) and adapted to CloudiQS standards.

## Layout

- `engagements/<engagement>/`: one folder per customer engagement. Copy `engagements/_template/` to start. `acme-reference/` is a fictional worked example; never reuse its facts.
  - `spec/requirements.md`, `spec/design.md`, `spec/tasks.md`: the contract.
  - `analysis/`, `design/`, `configs/`, `scripts/`, `evidence/`, `signoff/`, `change-requests/`.
- `templates/`: spec, register, library and steering templates. Copy, never edit in place for one customer.
- `infrastructure/cloudformation/target-mysql-dms.yaml`: MySQL-family target plus DMS capacity.
- `scripts/`: DMS endpoints, evidence capture, task watch, validation SQL template.
- `configs/`: DMS task settings (validated), table mapping and env templates.
- `product/`: BPTAO product contract for this offer.
- `.claude/`: rules, agents, skill, hooks. Read `.claude/rules/*.md` before any engagement work.

## Golden rules

1. **Never hardcode.** Region, account IDs, ARNs, hostnames, instance classes, version pins and credentials come from parameters, env files under `engagements/<e>/configs/`, Parameter Store or Secrets Manager. Env files hold identifiers and ARNs only, never secret values.
2. **Requirements choose designs.** No AWS service name inside a requirement. Every requirement has a pass/fail criterion a reader can test.
3. **Freeze before delivery.** No cloud-changing command until `spec/requirements.md` is approved and `spec/design.md` shows `Freeze status | FROZEN`. The `freeze-gate` hook enforces this; do not try to work around it.
4. **Frozen files are read-only.** A change after freeze goes to `change-requests/`, increments the baseline, and needs a new approval and freeze.
5. **Expected evidence is not proof.** A task completes only with actual source, path, value, result and disposition. Reference or simulated evidence stays labelled as such.
6. **Deciding proofs gate the freeze.** Any proof marked "before freeze" needs evidence before the freeze is signed, or the ADR falls back to its stated alternative.
7. **Cite exactly.** Material claims from guidance quote the text and give file plus heading. Label claims `[CUSTOMER]`, `[DISCOVERY]`, `[SSB-DIRECT]`, `[SSB-ADAPTED]`, `[PARTNER-JUDGMENT]` or `[OPEN]`.
8. **Check criteria against the real schema and estate** before approving them (for example, a max-timestamp check needs a timestamp column).
9. **Humans approve.** Claude drafts registers, ADRs and tasks; the named CloudiQS engagement lead approves, freezes and signs GO, DEFER or NO-GO.

## Commands

- Lint IaC: `cfn-lint infrastructure/cloudformation/*.yaml`
- Lint scripts: `shellcheck -S warning scripts/*.sh`
- Hook self-test: `bash .claude/hooks/selftest.sh`
- Deploy target (after freeze only): `ENGAGEMENT=<e> aws cloudformation deploy --stack-name <e>-<env>-target --template-file infrastructure/cloudformation/target-mysql-dms.yaml --parameter-overrides file://engagements/<e>/configs/target-params.json --capabilities CAPABILITY_NAMED_IAM`
- Endpoints: `ENGAGEMENT=<e> scripts/create-dms-endpoints.sh`
- Evidence: `ENGAGEMENT=<e> scripts/capture-dms-validation-evidence.sh <baseline|preflight|inflight|reconcile|smoke|rollback-readiness>`

## Working style

British English. Plain, direct register. State assumptions and proceed; ask only for decisions the engagement lead must make. Before any AWS command, say what runs, the expected result and the failure signal, and confirm the caller identity and account.

## Scope boundaries

- Database path (DMS) is scripted. Servers (MGN) and files (DataSync) are planned in the design and need their own runbooks built from the current AWS guides.
- Customer AWS access, IAM and change control come from the customer and the CloudiQS platform owner, not this repo.
- SSB source PDFs are not stored here. Obtain current SSB packs from AWS Partner Central under their access terms.
