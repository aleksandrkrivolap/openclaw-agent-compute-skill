# Publishing to ClawdHub (Checklist)

> This is a lightweight checklist. Update once the ClawdHub manifest format is finalized.

## Pre-flight
- [ ] Ensure `skills/openclaw-agent-compute/SKILL.md` frontmatter is correct (name, description)
- [ ] Ensure repo contains a LICENSE
- [ ] Ensure `.gitignore` excludes `.env` and `node_modules/`
- [ ] Run `npm run lint`

## Packaging
- [ ] Confirm required manifest/metadata file name + fields for ClawdHub
- [ ] Add manifest once confirmed

## Release
- [ ] Tag `v0.1.0`
- [ ] Create GitHub Release with changelog
- [ ] Publish to ClawdHub

## Manifest (TBD)

ClawdHub manifest spec is currently unknown.

Working assumptions / candidates:
- ClawdHub may infer name/description from `skills/openclaw-agent-compute/SKILL.md` frontmatter.
- If an explicit manifest is required, likely candidates are something like `clawdhub.json`, `clawdhub.yml`, or `skill.json` at repo root.

Action:
- Locate official docs/schema for the manifest (filename + required fields).
- Add the manifest and cut release `v0.1.0`.
