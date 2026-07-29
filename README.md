# drewjs/skills

Andrew Galvan's personal library of Claude Code skills.

## Install

```
/plugin marketplace add drewjs/skills
/plugin install drewjs-skills@drewjs
```

## Skills

### User-invoked

- [`hello`](skills/misc/hello/SKILL.md) — confirm the drewjs-skills plugin is installed and report what it ships. Invoked as `/drewjs-skills:hello`.

### Model-invoked

_None yet._

## Layout

Skills live under `skills/<bucket>/<skill-name>/SKILL.md`. Three buckets:

- `skills/engineering/` — promoted, coding-related. Every skill here is
  listed in `.claude-plugin/plugin.json`, the marketplace plugin entry, and
  this README. It ships to anyone who installs the plugin.
- `skills/misc/` — promoted, everything else. Same guarantees as
  `engineering/`.
- `skills/experimental/` — drafts. Never listed anywhere, never shipped. Test
  locally, then promote when ready.

## Development

- `.agents/skills/new-skill/` — repo-local skill that scaffolds a new
  experimental skill in this repo. Surfaced to Claude Code via the
  `.claude/skills` symlink; invoke as `/new-skill` (not namespaced — it's not
  plugin-provided, so it only loads when working in this repo).
- `scripts/link-skills.sh` — symlink experimental skills into your local
  Claude/Agents skill directories for testing.
- `scripts/check-skills.sh` — validate manifests, buckets, and READMEs stay
  consistent.

## Credits

This repo's structure is modeled on
[mattpocock/skills](https://github.com/mattpocock/skills) (MIT).

## License

MIT
