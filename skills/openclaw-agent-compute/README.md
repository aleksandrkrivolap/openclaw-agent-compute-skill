# openclaw-agent-compute

Public Clawdbot/OpenClaw skill that exposes `compute.*` tools by calling a **private** Compute Gateway over **HTTPS**.

## Configuration

Copy the example env file and set:

- `MCP_COMPUTE_URL` — base URL of your Compute Gateway (e.g. `https://compute.example.com`)
- `MCP_COMPUTE_API_KEY` — Bearer token

```bash
cp .env.example .env
# edit .env
```

## Smoke test

From this folder:

```bash
npm i
npm run lint
npm run example:exec
```

## Repository

https://github.com/aleksandrkrivolap/openclaw-agent-compute-skill
