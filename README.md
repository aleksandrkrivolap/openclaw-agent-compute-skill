# openclaw-agent-compute (Skill)

Public Clawdbot/OpenClaw skill that exposes `compute.*` tools by calling a **private** Compute Gateway over **HTTPS**.

- Skill folder: `skills/openclaw-agent-compute/`
- Starter kit: `skills/openclaw-agent-compute/starter-kit/`

## Quickstart

```bash
cp skills/openclaw-agent-compute/.env.example .env
# edit .env: MCP_COMPUTE_URL + MCP_COMPUTE_API_KEY

npm i
npm run example:exec
```

## ClawdHub publishing

This repo is structured as a standard Clawdbot skill under `skills/openclaw-agent-compute/`.

Publish **the skill folder** (not the repo root):

```bash
clawdhub publish ./skills/openclaw-agent-compute \
  --slug openclaw-agent-compute \
  --name "OpenClaw Agent Compute" \
  --version 0.1.0 \
  --tags latest
```

## License

MIT (see `LICENSE`).

## Publishing

See `PUBLISHING.md`.
