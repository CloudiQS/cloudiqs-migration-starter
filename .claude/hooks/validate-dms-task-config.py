#!/usr/bin/env python3
"""PostToolUse check for DMS task-settings files.

Runs after Write/Edit on any engagements/*/configs/*task*settings*.json (or
configs/dms-task-settings.json). Exit 2 sends the violations back to Claude so
it fixes the file; exit 0 means pass. Record the actual result (fail then pass)
as task evidence; a file existing is not proof the check ran.

Rules (from the DMS validation discipline proven in the SSB workshop):
  1. Only DMS replication-settings sections at the top level.
  2. ValidationSettings.EnableValidation must be true (DMS defaults it off).
  3. MySQL-family target: TargetMetadata.TargetSchema empty or absent.
  4. A file named as full-load-only (fl-only / -fl- / azuresqldb-fl) carries no CDC settings.
"""
import json
import os
import re
import sys

ALLOWED = {
    "TargetMetadata", "FullLoadSettings", "ValidationSettings", "Logging",
    "ErrorBehavior", "ChangeProcessingTuning", "ChangeProcessingDdlHandlingPolicy",
    "ControlTablesSettings", "StreamBufferSettings", "BeforeImageSettings",
    "LoopbackPreventionSettings", "CharacterSetSettings", "FailTaskWhenCleanTaskResourceFailed",
    "PostProcessingRules", "TTSettings",
}
CDC_KEYS = {"ChangeProcessingTuning", "ChangeProcessingDdlHandlingPolicy", "LoopbackPreventionSettings", "BeforeImageSettings"}


def main() -> None:
    try:
        data = json.load(sys.stdin)
    except ValueError:
        sys.exit(0)
    path = (data.get("tool_input") or {}).get("file_path", "")
    name = os.path.basename(path)
    if not re.search(r"task.*settings.*\.json$", name):
        sys.exit(0)
    try:
        with open(path, encoding="utf-8") as fh:
            cfg = json.load(fh)
    except (OSError, ValueError) as exc:
        sys.stderr.write(f"FAIL {path}: not valid JSON ({exc})\n")
        sys.exit(2)

    problems = []
    extra = sorted(set(cfg) - ALLOWED)
    if extra:
        problems.append(f"top-level keys that are not DMS settings sections: {extra}")
    if (cfg.get("ValidationSettings") or {}).get("EnableValidation") is not True:
        problems.append("ValidationSettings.EnableValidation must be true; DMS validation is off by default")
    if (cfg.get("TargetMetadata") or {}).get("TargetSchema"):
        problems.append("TargetMetadata.TargetSchema must be empty for a MySQL or Aurora MySQL target")
    if re.search(r"(fl-only|azuresqldb-fl|-fl-)", name) and CDC_KEYS & set(cfg):
        problems.append(f"full-load-only config carries CDC settings: {sorted(CDC_KEYS & set(cfg))}")

    if problems:
        sys.stderr.write(f"FAIL {path}\n" + "\n".join(f"- {p}" for p in problems) + "\n")
        sys.exit(2)
    print(f"PASS {path}")
    sys.exit(0)


if __name__ == "__main__":
    main()
