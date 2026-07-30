# 1. Ship as a single root Claude Code plugin

## Status

Accepted, 2026-07-29

## Context

This repo needs to be installable as one or more Claude Code plugins. The skills
collected here are likely to end up an eclectic mix — general engineering
practices, personal productivity, one-off experiments — rather than one
cohesive framework. That made partitioning the repo into several
independently-installable plugins (e.g. one per theme) a real option, not a
strawman.

## Decision

The repo root is the single plugin. `.claude-plugin/marketplace.json` defines
one marketplace (`drewjs`) with one plugin entry (`drewjs-skills`,
`source: "./"`) — the repo doubles as its own single-plugin marketplace.
Skills are organized into buckets under `skills/` (`engineering/`,
`experimental/`); those buckets are the seam a future split would cut along,
not a decision to split now.

## Consequences

- One install command (`/plugin install drewjs-skills@drewjs`) gets all
  promoted skills. No à-la-carte installation of individual skills.
- If a future split is warranted, it means moving files under `plugins/<name>/`
  and each installed user reinstalling from the new locations.
- Because the marketplace plugin entry uses `source: "./"` and also lists an
  explicit `skills` array, that array is the complete shipped set — it is what
  keeps `skills/experimental/*` from shipping. `scripts/check-skills.sh` must
  keep guarding that the `skills` arrays in both manifests stay identical and
  never point under `skills/experimental/`.

## Update, 2026-07-30: multi-tool install, still one manifest

Extended install support to Codex and to any Agent-Skills-compatible tool via
`npx skills`, without adding a second plugin manifest. Verified live (`codex
plugin marketplace add ./` against this repo with no `.codex-plugin/`
present): Codex's plugin CLI reads `.claude-plugin/plugin.json` and
`marketplace.json` directly and installs from them successfully. The repo
root remains the single manifest and the single source of truth for
`version`; "single plugin" now means "one manifest, multiple installers,"
not "one specific tool."

`npx skills` has no bucket concept — it scans the whole repo for any
`SKILL.md`, so it will also list `.agents/skills/*` repo-local dev tooling
(e.g. `new-skill`) alongside promoted skills. Unlike the `experimental/`
leak the explicit `skills` array prevents for Claude/Codex, this can't be
fixed in a manifest `npx skills` doesn't read. Accepted and documented
instead of restructuring the repo: `INSTALL.md` tells `npx skills` users to
install by explicit `--skill <name>`, not a bare `add`.
