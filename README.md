# drewjs/skills

Andrew Galvan's personal library of Claude Code skills.

## Install

```
/plugin marketplace add drewjs/skills
/plugin install drewjs-skills@drewjs
```

## Skills

### User-invoked

- [`new-skill`](skills/engineering/new-skill/SKILL.md) — scaffold a new experimental skill in this repo. Invoked as `/drewjs-skills:new-skill`.

### Model-invoked

_None yet._

## Layout

Skills live under `skills/<bucket>/<skill-name>/SKILL.md`. Two buckets:

- `skills/engineering/` — promoted. Every skill here is listed in
  `.claude-plugin/plugin.json`, the marketplace plugin entry, and this README.
  It ships to anyone who installs the plugin.
- `skills/experimental/` — drafts. Never listed anywhere, never shipped. Test
  locally, then promote when ready.

## Development

- `scripts/link-skills.sh` — symlink experimental skills into your local
  Claude/Agents skill directories for testing.
- `scripts/check-skills.sh` — validate manifests, buckets, and READMEs stay
  consistent.

## Credits

This repo's structure is modeled on
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

## License

MIT
