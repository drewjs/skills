# drewjs/skills

A library of agent skills, shipped as a plugin for Claude Code and Codex,
and installable in any other agent via `npx skills`.

## Install

```bash
claude plugin marketplace add drewjs/skills && claude plugin install drewjs-skills@drewjs   # Claude Code
codex plugin marketplace add drewjs/skills && codex plugin add drewjs-skills@drewjs         # Codex
npx skills add drewjs/skills --list                                                         # everyone else
```

Full instructions, verify/update/uninstall, and per-tool notes: [`INSTALL.md`](INSTALL.md).

## Skills

### User-invoked

- [`hello`](skills/misc/hello/SKILL.md) — confirm the drewjs-skills plugin is installed and report what it ships. Invoked as `/drewjs-skills:hello` (Claude Code) or `$hello` (Codex).

### Model-invoked

_None yet._

## Layout

Skills live under `skills/<bucket>/<skill-name>/SKILL.md`. Three buckets:

- `skills/engineering/` — promoted, coding-related. Every skill here is
  listed in `.claude-plugin/plugin.json` and the marketplace plugin entry
  (Codex reads the same files — no separate manifest), and this README. It
  ships to anyone who installs the plugin.
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

## License

MIT
