# Publishing to ClawdHub (Checklist)

> This is a lightweight checklist. Update once the ClawdHub manifest format is finalized.

## Pre-flight
- [ ] Ensure `skills/openclaw-agent-compute/SKILL.md` frontmatter is correct (name, description)
- [ ] Ensure repo contains a LICENSE
- [ ] Ensure `.gitignore` excludes `.env` and `node_modules/`
- [ ] Run `npm run lint` (GitHub Actions workflow: `lint`)
- [ ] (Recommended) Add `package-lock.json` and switch CI back to `npm ci` for reproducible installs

## Packaging
- [x] Confirmed: ClawdHub does **not** require a separate manifest file in the repo.
- [ ] Ensure the **skill folder** (`./skills/openclaw-agent-compute`) is self-contained (has SKILL.md + any runtime deps / package.json if needed).

## Release
- [ ] Tag `v0.1.0`
- [ ] Create GitHub Release with changelog
- [ ] Publish to ClawdHub:
  ```bash
  clawdhub publish ./skills/openclaw-agent-compute \
    --slug openclaw-agent-compute \
    --name "OpenClaw Agent Compute" \
    --version 0.1.0 \
    --tags latest
  ```

## Manifest

No separate manifest file is required.

ClawdHub publishing is driven by the CLI (`clawdhub publish ...`). Skill metadata should live in `skills/openclaw-agent-compute/SKILL.md` frontmatter + README.
