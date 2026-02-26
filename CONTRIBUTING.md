# Contributing

Thanks for contributing!

## Repo layout

- `skills/openclaw-agent-compute/` — the actual Clawdbot skill folder (this is what gets published to ClawdHub)
- `starter-kit/` — example OpenClaw starter kit

## Local development

Prereqs: Node.js + npm.

```bash
npm i
npm run lint
npm run example:exec
```

## Publishing to ClawdHub

See `PUBLISHING.md`.

Quick path:

```bash
npm i -g clawdhub
clawdhub login
./scripts/publish_clawdhub.sh
```
