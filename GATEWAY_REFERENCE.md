# Compute Gateway — reference implementation notes

This skill (`openclaw-agent-compute`) is a **client**: it forwards `compute.*` tool calls to your hosted **Compute Gateway** over HTTPS.

This page captures practical notes for implementing the gateway endpoints (especially **artifacts**) in a safe way.

> This is guidance, not production-hardened code.

## Endpoint contract (expected by the skill)

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

## Artifacts storage model

A simple (and common) approach is a filesystem-backed store:

- `ARTIFACTS_ROOT/<session_id>/<virtual_path>`

Where `virtual_path` is the user-facing path inside the session namespace.

### Critical: prevent path traversal

When your route captures `{path}`, **never** use it directly as a filesystem path.

At minimum:

1) Decode safely (defensive `decodeURIComponent`)
2) Join under the session root
3) Normalize
4) Verify the resolved path is still under the session root

Node/Express sketch:

```js
import path from "node:path";

const ARTIFACTS_ROOT = process.env.ARTIFACTS_ROOT || path.resolve("./data/artifacts");

function resolveArtifactPath(sessionId, virtualPath) {
  const sessionRoot = path.join(ARTIFACTS_ROOT, sessionId);
  const candidate = path.normalize(path.join(sessionRoot, virtualPath));

  // Prevent traversal: ensure candidate stays under sessionRoot
  const rel = path.relative(sessionRoot, candidate);
  if (rel.startsWith("..") || path.isAbsolute(rel)) {
    const err = new Error("Invalid artifact path");
    err.status = 400;
    throw err;
  }

  return { sessionRoot, absPath: candidate };
}
```

### Uploads: accept raw bytes

For `PUT /v1/artifacts/:session_id/:path` the body is raw bytes (not JSON).

Express example:

```js
import express from "express";

const MAX_UPLOAD_BYTES = Number(process.env.MAX_UPLOAD_BYTES || 50 * 1024 * 1024);

app.put(
  "/v1/artifacts/:session_id/:path(*)",
  express.raw({ type: "*/*", limit: MAX_UPLOAD_BYTES }),
  async (req, res) => {
    // write req.body to disk
  }
);
```

### Downloads: stream bytes

For `GET /v1/artifacts/:session_id/:path` stream the file.

Good defaults:
- `Cache-Control: no-store`

### List: return virtual paths

For `GET /v1/artifacts/:session_id`, list recursively and return **virtual** paths only.

Each artifact record should include at least:
- `path` (virtual)
- `bytes`
- `mtime`

### Delete: optionally prune empty directories

For `DELETE /v1/artifacts/:session_id/:path`, delete the file.

Optionally prune empty parent directories up to the session root.

## Auth

Gate the entire API behind a Bearer token (e.g. `Authorization: Bearer <MCP_COMPUTE_API_KEY>`), and run behind HTTPS.

## Suggested smoketests

- Upload + download roundtrip
- Listing returns the uploaded virtual path
- Delete removes the file
- Negative test: traversal attempt (e.g. encoded `../x.txt`) is rejected with 400
