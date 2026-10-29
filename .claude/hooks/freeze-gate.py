#!/usr/bin/env python3
"""PreToolUse gate for the CloudiQS engagement method.

Blocks (exit 2, reason on stderr for Claude to read):
  1. Any cloud-changing command (AWS CLI write verbs, CloudFormation/CDK/
     Terraform deploys, the DMS endpoint script) unless the named engagement's
     spec/design.md is FROZEN and spec/requirements.md is approved.
  2. Any Write/Edit to a frozen engagement's requirements.md or design.md.
     Changes after a freeze go through engagements/<e>/change-requests/.

The engagement is taken from ENGAGEMENT=<name> in the command, or from the
CQ_ENGAGEMENT environment variable. Read-only AWS calls (describe-, get-,
list-, sts get-caller-identity) always pass.
"""
import json
import os
import re
import sys

ROOT = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())

WRITE_PATTERNS = [
    r"\baws\s+\S+\s+(create|delete|start|stop|modify|update|put|reboot|restore|"
    r"terminate|run|deploy|apply|attach|detach|associate|disassociate|"
    r"authorize|revoke|reload|test-connection|tag|untag)[a-z-]*\b",
    r"\baws\s+cloudformation\s+(deploy|create-stack|update-stack|delete-stack|execute-change-set)\b",
    r"\baws\s+s3\s+(cp|mv|rm|sync|mb|rb)\b",
    r"\b(cdk)\s+(deploy|destroy)\b",
    r"\bterraform\s+(apply|destroy|import)\b",
    r"scripts/create-dms-endpoints\.sh",
]


def block(msg: str) -> None:
    sys.stderr.write(msg.strip() + "\n")
    sys.exit(2)


def read(path: str) -> str:
    try:
        with open(path, encoding="utf-8") as fh:
            return fh.read()
    except OSError:
        return ""


def is_frozen(design_text: str) -> bool:
    return bool(
        re.search(r"\|\s*Freeze status\s*\|\s*FROZEN\s*\|", design_text)
        or re.search(r"Status:\s*\**\s*FROZEN\b", design_text)
    )


def is_approved(req_text: str) -> bool:
    return bool(
        re.search(r"\|\s*Status\s*\|\s*approved\s*\|", req_text, re.I)
        or re.search(r"\bREQ-v\d+\b.*\bapproved\b", req_text, re.I)
    )


def engagement_paths(name: str):
    base = os.path.join(ROOT, "engagements", name, "spec")
    return os.path.join(base, "requirements.md"), os.path.join(base, "design.md")


def gate_command(cmd: str) -> None:
    if not any(re.search(p, cmd) for p in WRITE_PATTERNS):
        return
    m = re.search(r"\bENGAGEMENT=([A-Za-z0-9_-]+)", cmd)
    name = m.group(1) if m else os.environ.get("CQ_ENGAGEMENT", "")
    if not name:
        block(
            "Blocked: this command changes a cloud account but names no engagement. "
            "Prefix it with ENGAGEMENT=<name> (or set CQ_ENGAGEMENT) so the freeze gate "
            "can check engagements/<name>/spec/design.md."
        )
    req, des = engagement_paths(name)
    if not is_approved(read(req)):
        block(f"Blocked: engagements/{name}/spec/requirements.md is not approved. Approve the requirements baseline first.")
    if not is_frozen(read(des)):
        block(
            f"Blocked: engagements/{name}/spec/design.md is not FROZEN. No cloud changes before a signed "
            "design freeze. Finish the ADRs, get the named approver's freeze, then retry."
        )


def gate_edit(path: str) -> None:
    rel = os.path.relpath(os.path.abspath(path), ROOT)
    m = re.match(r"engagements/([^/]+)/spec/(requirements|design)\.md$", rel)
    if not m:
        return
    _, des = engagement_paths(m.group(1))
    if is_frozen(read(des)):
        block(
            f"Blocked: {rel} belongs to a FROZEN baseline and is read-only. Record the change in "
            f"engagements/{m.group(1)}/change-requests/, preserve the old baseline, increment the "
            "version, and get a new approval and freeze."
        )


def main() -> None:
    try:
        data = json.load(sys.stdin)
    except ValueError:
        sys.exit(0)
    tool = data.get("tool_name", "")
    inp = data.get("tool_input", {}) or {}
    if tool == "Bash":
        gate_command(inp.get("command", ""))
    elif tool in ("Write", "Edit", "MultiEdit"):
        gate_edit(inp.get("file_path", ""))
    sys.exit(0)


if __name__ == "__main__":
    main()
