# ClawdHub publishing runbook (OpenClaw Agent Compute)

This repo publishes the **skill folder** `./skills/openclaw-agent-compute` (not the repo root).

## Option A — Local publish (fastest)

Prereqs:
- Node.js + npm
- ClawdHub CLI installed + logged in

```bash
npm i -g clawdhub
clawdhub login

./scripts/publish_clawdhub.sh
```

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
