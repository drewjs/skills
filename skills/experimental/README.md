# experimental

Drafts. Skills here are never listed in either `.claude-plugin` manifest and
never ship to plugin installers.

Test one locally with `scripts/link-skills.sh` — it symlinks
`skills/experimental/*` into your local Claude/Agents skill directories.

## Promoting a skill

1. `git mv skills/experimental/<name> skills/engineering/<name>`
2. Add `./skills/engineering/<name>` to `skills` in both
   `.claude-plugin/plugin.json` and the `drewjs-skills` entry in
   `.claude-plugin/marketplace.json`.
3. Add a line to `README.md` and `skills/engineering/README.md`.
4. Run `scripts/check-skills.sh`.
