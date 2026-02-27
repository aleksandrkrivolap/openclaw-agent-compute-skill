#!/usr/bin/env bash
set -euo pipefail

# Publish the skill folder to ClawdHub.
#
# Prereqs:
#   npm i -g clawdhub
#   clawdhub login

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT_DIR/skills/openclaw-agent-compute"
SKILL_PKG="$SKILL_DIR/package.json"

if [[ ! -f "$SKILL_PKG" ]]; then
  echo "ERROR: missing $SKILL_PKG" >&2
  exit 1
fi

VERSION=$(python3 - <<'PY'
import json
from pathlib import Path
p = Path("skills/openclaw-agent-compute/package.json")
data = json.loads(p.read_text())
print(data["version"])
PY
)

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: missing required command: $1" >&2
    return 1
  fi
}

need_cmd python3
need_cmd clawdhub

echo "Publishing openclaw-agent-compute version: $VERSION"

echo "NOTE: This must be run from an environment with Node/npm available (for installing the ClawdHub CLI), and where you are logged in via 'clawdhub login'."

clawdhub publish "$SKILL_DIR" \
  --slug openclaw-agent-compute \
  --name "OpenClaw Agent Compute" \
  --version "$VERSION" \
  --tags latest
