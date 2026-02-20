# OpenClaw Agent Compute Skill (public)

Public, agent-friendly skill that exposes `compute.*` tools by calling a **private** Compute Gateway over **HTTPS**.

## Config
Copy and fill:

```bash
cp .env.example .env
# set MCP_COMPUTE_URL, MCP_COMPUTE_API_KEY
```

## Local smoke test

```bash
npm i
npm run example:exec
```

## API expectation (draft)
This client expects the private gateway to implement:
- `POST /v1/sessions` (create)
- `POST /v1/exec` (run command)
- `GET /v1/usage/{session_id}` (usage/cost)
- `DELETE /v1/sessions/{session_id}` (destroy)

See the private OpenAPI spec (authoritative):
- `../backend-private/openapi.yaml`

Example exec payload:
```json
{ "session_id": "...", "cmd": "...", "cwd": null, "env": null, "timeout_s": null }
```

## Status
Scaffold only. Publish after Alex review.
