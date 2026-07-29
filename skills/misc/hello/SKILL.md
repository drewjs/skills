---
name: hello
description: Confirm the drewjs-skills plugin is installed and report what it ships.
disable-model-invocation: true
---

# hello

1. Find the installed `plugin.json`, falling back to this repo if run from
   inside it:

   ```
   /usr/bin/find "$HOME/.claude/plugins" -path '*drewjs-skills*/.claude-plugin/plugin.json' -print 2>/dev/null
   [ -f ./.claude-plugin/plugin.json ] && echo ./.claude-plugin/plugin.json
   ```

   Call `find` by absolute path — a shell function named `find` may shadow it
   and return output that looks like a result but isn't. Treat a line as a hit
   only if it starts with `/` or `./` and ends in `plugin.json`; otherwise
   report that no installed plugin was found. Use the first hit, preferring the
   plugin-tree one.

2. Report: `name` and `version` from that file, the marketplace it came from
   (`drewjs`), and each path in its `skills` array — with that skill's
   frontmatter `description`.

3. Compare versions: if this repo's working copy is available locally, read
   `.claude-plugin/plugin.json` on `main` there and state whether the running
   plugin's `version` matches it. If the repo isn't available, say the
   comparison was skipped — don't guess.

4. Print: this skill is a temporary install canary; delete it once real
   skills ship.

Do not modify anything.
