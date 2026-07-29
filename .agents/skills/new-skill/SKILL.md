---
name: new-skill
description: Scaffold a new experimental skill in this repo.
disable-model-invocation: true
---

# new-skill

1. Locate Matt Pocock's `writing-great-skills` reference and read it first. Apply its principles throughout. Find it with:

   ```
   for p in ~/.claude/skills/writing-great-skills/SKILL.md ~/.agents/skills/writing-great-skills/SKILL.md; do [ -f "$p" ] && echo "$p"; done; /usr/bin/find "$HOME/.claude/plugins" -path '*/skills/*/writing-great-skills/SKILL.md' -print 2>/dev/null
   ```

   Read the first match — a line starting with `/` and ending in `SKILL.md`
   (`find` is called by absolute path because a shell function may shadow it). Also read its sibling `GLOSSARY.md` if present.
   If nothing is found: tell the user out loud, then fall back to
   `## Conventions` below and continue — do not stop.

2. Interview the user, one question at a time:
   - What is the skill's purpose?
   - What is its trigger — who invokes it, and when?
   - Must the agent be able to reach it autonomously?

3. Default to user-invoked: `disable-model-invocation: true`, one-line
   human-facing description. Only produce a model-invoked skill (omit
   `disable-model-invocation`, write a rich trigger-phrased description) if the
   user says the agent must reach it on its own, or another skill must reach
   it.

4. Scaffold to `skills/experimental/<kebab-name>/SKILL.md` — never into
   `skills/engineering/` or any other promoted bucket. `name:` in the
   frontmatter must equal the directory name, kebab-case. Single `SKILL.md`
   only — no `references/`, `GLOSSARY.md`, or other subfiles unless the user
   explicitly asks for them.

5. Never edit `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`,
   or any `README.md`. Promotion is a separate, deliberate act.

6. Run `scripts/check-skills.sh` before finishing. Report its result.

7. Finish by printing exactly two things:
   - How to test it: run `scripts/link-skills.sh`, then invoke the skill by
     name in a new session.
   - The promote checklist: `git mv` into a promoted bucket —
     `skills/engineering/` (coding-related) or `skills/misc/` (everything
     else) — add the path to BOTH manifests' `skills` arrays, add a line to
     `README.md` and the bucket's `README.md`, re-run
     `scripts/check-skills.sh`.

## Conventions

Fallback conventions when `writing-great-skills` isn't found:

- Default every skill to user-invoked: `disable-model-invocation: true` plus a
  one-line, human-facing `description`.
- Model-invoked only when necessary: omit `disable-model-invocation`, write a
  `description` rich with trigger phrasing (who/when this fires).
- `name:` in frontmatter == directory name, kebab-case.
- One `SKILL.md` per skill unless more files are explicitly requested.
- New skills start in `skills/experimental/`; promotion is manual and
  deliberate.

Builds on Matt Pocock's
[`writing-great-skills`](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-great-skills/SKILL.md) (MIT).
