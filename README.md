# openclaw-agent-compute (Skill)

[![lint](https://github.com/aleksandrkrivolap/openclaw-agent-compute-skill/actions/workflows/lint.yml/badge.svg)](https://github.com/aleksandrkrivolap/openclaw-agent-compute-skill/actions/workflows/lint.yml)

Public Clawdbot/OpenClaw skill that exposes `compute.*` tools by calling a **private** Compute Gateway over **HTTPS**.

- Skill folder: `skills/openclaw-agent-compute/`
- Starter kit: `skills/openclaw-agent-compute/starter-kit/`

## Install

### Option A — ClawHub (registry)

Listing: https://clawhub.ai/skills/openclaw-agent-compute

```bash
clawdhub install openclaw-agent-compute
```

### Option B — from GitHub

```bash
git clone https://github.com/aleksandrkrivolap/openclaw-agent-compute-skill
cd openclaw-agent-compute-skill
npm i
```

## Quickstart

Prereqs: Node.js + npm.

```bash
# from repo root
cp skills/openclaw-agent-compute/.env.example .env
# edit .env: MCP_COMPUTE_URL + MCP_COMPUTE_API_KEY

npm i
npm run example:exec
```

## Configuration

This is a **public client** skill. It does *not* run compute itself — it forwards requests to your **private Compute Gateway**.

Required env vars:

- `MCP_COMPUTE_URL` (example: `https://compute.example.com`)
- `MCP_COMPUTE_API_KEY`

Security notes:

- Treat `MCP_COMPUTE_API_KEY` like a root credential.
- Run the gateway behind HTTPS and keep it on a private network / allowlisted IPs.

## What you get (tools)

This skill exposes agent-friendly `compute.*` tools (see `skills/openclaw-agent-compute/` for the exact tool schema).

Gateway implementers: see `GATEWAY_REFERENCE.md` (artifacts path safety, raw upload notes, suggested smoketests).

The gateway is expected to implement:

- Sessions
  - `POST /v1/sessions` (create)
  - `GET /v1/sessions/{session_id}` (status)
  - `DELETE /v1/sessions/{session_id}` (destroy)
- Exec
  - `POST /v1/exec` (run a command)
  - `GET /v1/usage/{session_id}` (usage/cost)
- Artifacts
  - `GET /v1/artifacts/{session_id}` (list)
  - `PUT /v1/artifacts/{session_id}/{path}` (upload bytes)
  - `GET /v1/artifacts/{session_id}/{path}` (download bytes)
  - `DELETE /v1/artifacts/{session_id}/{path}` (delete)

`{path}` must be URL-encoded and may include slashes.

## ClawdHub publishing

This repo is structured as a standard Clawdbot skill under `skills/openclaw-agent-compute/`.

### Option A — Local publish

Install the ClawdHub CLI:

```bash
# Workaround: clawdhub CLI currently expects undici at runtime
npm i -g undici clawdhub
clawdhub login
```

Publish **the skill folder** (not the repo root):

```bash
clawdhub publish ./skills/openclaw-agent-compute \
  --slug openclaw-agent-compute \
  --name "OpenClaw Agent Compute" \
  --version 0.1.7 \
  --tags latest
```

Or use the helper script (reads the version from `skills/openclaw-agent-compute/package.json`):

```bash
./scripts/publish_clawdhub.sh
```

### Option B — GitHub Actions (tag-based)

1) Add repo secret: `CLAWDHUB_TOKEN`
2) Push a tag matching the version, e.g.:

```bash
git tag v0.1.7
git push origin v0.1.7
```

The workflow `.github/workflows/publish-clawdhub.yml` will publish automatically.

## License

MIT (see `LICENSE`).

## Publishing

- Checklist: `PUBLISHING.md`
- Runbook (local + GitHub Actions): `CLAWDHUB_RUNBOOK.md`
