# drewjs/skills

## Vocabulary

- **Skill**: a `SKILL.md` directory invoked by name or by the model.
- **Bucket**: a top-level grouping under `skills/` — `engineering/`, `misc/`, or `experimental/`.
- **Promoted**: lives in a promoted bucket (`engineering/` for coding-related, `misc/` for everything else), listed in both manifests + `README.md`, ships to installers.
- **Experimental**: lives in `skills/experimental/`, never listed, never ships.
- **Repo-local skill**: lives in `.agents/skills/`, surfaced via the `.claude/skills` symlink, loads only when working in this repo, never ships.

## Layout

`skills/<bucket>/<skill-name>/SKILL.md`. Buckets: `engineering/` (promoted, coding), `misc/` (promoted, other), `experimental/` (not promoted).

## Invariants

- Every promoted-bucket skill MUST appear in `.claude-plugin/plugin.json` `skills`.
- Same skill MUST appear in the marketplace plugin entry `skills` — identical array to `plugin.json`.
- Same skill MUST appear in `README.md`.
- Nothing from `experimental/` may appear in either manifest or the README.
- `plugin.json`'s `skills` array must never be empty — it's the marketplace root's complete shipped-skill guarantee.

## Versioning

`.claude-plugin/plugin.json`'s `version` is the single source of truth for the release version.

## Workflow

- Run `scripts/check-skills.sh` after touching a skill or a manifest.
- Test an experimental skill locally with `scripts/link-skills.sh` (links `skills/experimental/*` only — promoted skills reach you via the installed plugin, so linking them would double-load).
- Skills default to user-invoked (`disable-model-invocation: true`) unless the agent must reach them autonomously.

## Docs

Only ADRs (`.agents/adr/`) are committed docs; other design/AI-generated docs stay transient and gitignored.

See `.agents/adr/0001-ship-as-a-single-root-claude-code-plugin.md`.
