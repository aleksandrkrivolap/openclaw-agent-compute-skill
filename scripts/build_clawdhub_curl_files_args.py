#!/usr/bin/env python3
"""Emit `curl -F` args for ClawdHub publish endpoint.

Usage:
  python3 scripts/build_clawdhub_curl_files_args.py <skill_dir>

Prints lines like:
  -F files=@/abs/path;filename=relative/path

We keep this as a standalone script because embedding heredocs inside GitHub Actions
`run: |` blocks can be brittle.
"""

from __future__ import annotations

import os
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: build_clawdhub_curl_files_args.py <skill_dir>", file=sys.stderr)
        return 2

    skill_dir = Path(sys.argv[1]).resolve()
    if not skill_dir.exists() or not skill_dir.is_dir():
        print(f"error: skill_dir not found: {skill_dir}", file=sys.stderr)
        return 2

    for path in skill_dir.rglob("*"):
        if not path.is_file():
            continue

        # Skip common junk
        parts = set(path.parts)
        if "node_modules" in parts or ".git" in parts:
            continue

        rel = path.relative_to(skill_dir).as_posix()
        abs_path = str(path)
        print(f"-F files=@{abs_path};filename={rel}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
