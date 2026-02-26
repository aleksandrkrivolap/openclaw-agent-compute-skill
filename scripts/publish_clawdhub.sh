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

echo "Publishing openclaw-agent-compute version: $VERSION"

clawdhub publish "$SKILL_DIR" \
  --slug openclaw-agent-compute \
  --name "OpenClaw Agent Compute" \
  --version "$VERSION" \
  --tags latest
