# drewjs/skills

## Vocabulary

- **Skill**: a `SKILL.md` directory invoked by name or by the model.
- **Bucket**: a top-level grouping under `skills/` — `engineering/` or `experimental/`.
- **Promoted**: lives in `skills/engineering/`, listed in both manifests + `README.md`, ships to installers.
- **Experimental**: lives in `skills/experimental/`, never listed, never ships.

## Layout

`skills/<bucket>/<skill-name>/SKILL.md`. Buckets: `engineering/` (promoted), `experimental/` (not promoted).

## Invariants

- Every `skills/engineering/*` skill MUST appear in `.claude-plugin/plugin.json` `skills`.
- Same skill MUST appear in the marketplace plugin entry `skills` — identical array to `plugin.json`.
- Same skill MUST appear in `README.md`.
- Nothing from `experimental/` may appear in either manifest or the README.

## Versioning

`.claude-plugin/plugin.json`'s `version` is the single source of truth for the release version.

## Workflow

- Run `scripts/check-skills.sh` after touching a skill or a manifest.
- Test an experimental skill locally with `scripts/link-skills.sh` (links `skills/experimental/*` only — promoted skills reach you via the installed plugin, so linking them would double-load).
- Skills default to user-invoked (`disable-model-invocation: true`) unless the agent must reach them autonomously.

## Docs

Only ADRs (`.agents/adr/`) are committed docs; other design/AI-generated docs stay transient and gitignored.

See `.agents/adr/0001-ship-as-a-single-root-claude-code-plugin.md`.
