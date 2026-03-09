#!/usr/bin/env bash
set -euo pipefail

# Clean-install smoke test from ClawdHub.
#
# Usage:
#   ./scripts/verify_clawdhub_install.sh [version]
#
# Example:
#   ./scripts/verify_clawdhub_install.sh 0.1.1
#
# Notes:
# - ClawdHub sometimes rate-limits immediately after publish. This script retries with backoff.
# - If you see: `env: node: No such file or directory` then Node is not on PATH. Example (nvm):
#     export PATH="$HOME/.nvm/versions/node/v22.22.0/bin:$PATH"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_ROOT="${TMPDIR:-/tmp}/clawdhub-smoke"

VERSION="${1:-}"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: missing required command: $1" >&2
    return 1
  fi
}

need_cmd clawdhub

# Retry parameters (total worst-case ~6 minutes)
MAX_ATTEMPTS=${MAX_ATTEMPTS:-8}
SLEEP_BASE_SECONDS=${SLEEP_BASE_SECONDS:-5}

install_once() {
  rm -rf "$TMP_ROOT"
  mkdir -p "$TMP_ROOT"

  local args=(install openclaw-agent-compute)
  if [[ -n "$VERSION" ]]; then
    args+=(--version "$VERSION")
  fi

  clawdhub "${args[@]}" \
    --dir "$TMP_ROOT/skills" \
    --workdir "$TMP_ROOT" \
    >"$TMP_ROOT/install.log" 2>&1

  TMP_ROOT="$TMP_ROOT" python3 - <<'PY'
import json, os
from pathlib import Path
p = Path(os.environ["TMP_ROOT"]) / "skills/openclaw-agent-compute/package.json"
if not p.exists():
    raise FileNotFoundError(f"Missing expected installed package.json: {p}")
print("INSTALL_OK")
print(json.loads(p.read_text()).get("version"))
PY
}

attempt=1
while true; do
  echo "==> ClawdHub install verification (attempt $attempt/$MAX_ATTEMPTS)" >&2

  if install_once; then
    echo "Smoke install dir: $TMP_ROOT/skills/openclaw-agent-compute" >&2
    echo "Log: $TMP_ROOT/install.log" >&2
    exit 0
  fi

  if grep -qi "rate limit" "$TMP_ROOT/install.log"; then
    sleep_for=$((SLEEP_BASE_SECONDS * attempt))
    echo "Rate limited. Sleeping ${sleep_for}s then retrying..." >&2
    sleep "$sleep_for"
  else
    echo "Install failed (non-rate-limit). Last 120 lines:" >&2
    tail -n 120 "$TMP_ROOT/install.log" >&2 || true
    exit 1
  fi

  attempt=$((attempt + 1))
  if [[ "$attempt" -gt "$MAX_ATTEMPTS" ]]; then
    echo "ERROR: exceeded max attempts ($MAX_ATTEMPTS)." >&2
    tail -n 120 "$TMP_ROOT/install.log" >&2 || true
    exit 1
  fi
done
