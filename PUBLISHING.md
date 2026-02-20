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
