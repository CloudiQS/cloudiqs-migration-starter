# AGENTS.md

Instructions for any coding agent working in this repo. Claude Code reads `CLAUDE.md` and `.claude/`; other agents should follow the same rules.

1. Read `CLAUDE.md`, then `.claude/rules/gates.md`, `evidence.md` and `no-hardcoding.md`.
2. Work inside one `engagements/<engagement>/` folder at a time.
3. No cloud-changing command before the engagement's design is frozen. Prefix such commands with `ENGAGEMENT=<engagement>`.
4. Frozen `spec/requirements.md` and `spec/design.md` are read-only; changes go through `change-requests/`.
5. Never write secret values anywhere. Env files hold identifiers and ARNs only.
6. Before finishing: `cfn-lint infrastructure/cloudformation/*.yaml`, `shellcheck -S warning scripts/*.sh`, `bash .claude/hooks/selftest.sh`.
