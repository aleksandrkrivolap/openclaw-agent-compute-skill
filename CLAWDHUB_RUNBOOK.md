# ClawdHub publishing runbook (OpenClaw Agent Compute)

This repo publishes the **skill folder** `./skills/openclaw-agent-compute` (not the repo root).

## Option A — Local publish (fastest)

Prereqs:
- Node.js + npm
- ClawdHub CLI installed + logged in

```bash
# Workaround: clawdhub CLI currently expects undici at runtime
npm i -g undici clawdhub
clawdhub login

./scripts/publish_clawdhub.sh
```

### Dry-run checklist (before publishing)

1) Sanity-check metadata
- `skills/openclaw-agent-compute/SKILL.md` frontmatter:
  - `name: openclaw-agent-compute`
  - `description: ...`
- `skills/openclaw-agent-compute/README.md` exists and describes env vars + endpoints.
- `LICENSE` exists at repo root, and a copy exists inside `skills/openclaw-agent-compute/` (so the published folder is self-contained).

2) Confirm versioning
- `skills/openclaw-agent-compute/package.json` version matches your intended publish version.
- Tag to publish via Actions should be `vX.Y.Z` and should match that version.

3) Quick local checks
- `node -c skills/openclaw-agent-compute/scripts/client.js`
- `node -c skills/openclaw-agent-compute/scripts/example_exec.js`

4) After publish
- Copy the ClawdHub listing URL into the Notion card.
- Mark Status → Done once listing is live.

## Option B — GitHub Actions publish (tag-based)

The workflow `.github/workflows/publish-clawdhub.yml` publishes on:
- manual trigger (`workflow_dispatch`)
- pushing a tag like `v0.1.0`

### 1) Add repo secret

In GitHub → Settings → Secrets and variables → Actions:
- Add **Repository secret**: `CLAWDHUB_TOKEN`

(Generate the token in ClawdHub; keep it private.)

### 2) Create + push tag

```bash
git tag v0.1.0
git push origin v0.1.0
```

### 3) Verify

- Check Actions → `publish-clawdhub`
- After success, grab the ClawdHub listing URL and add it to the Notion card.
