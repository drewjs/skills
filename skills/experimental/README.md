# experimental

Drafts. Skills here are never listed in either `.claude-plugin` manifest and
never ship to plugin installers.

Test one locally with `scripts/link-skills.sh` — it symlinks
`skills/experimental/*` into your local Claude/Agents skill directories.

## Promoting a skill

1. `git mv skills/experimental/<name> skills/<bucket>/<name>`, where
   `<bucket>` is `engineering/` (coding-related) or `misc/` (everything else).
2. Add `./skills/<bucket>/<name>` to `skills` in both
   `.claude-plugin/plugin.json` and the `drewjs-skills` entry in
   `.claude-plugin/marketplace.json`.
3. Add a line to `README.md` and `skills/<bucket>/README.md`.
4. Run `scripts/check-skills.sh`.
