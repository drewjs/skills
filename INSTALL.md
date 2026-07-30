# Install

<details>
<summary><strong>Claude Code</strong></summary>

### Install

```bash
claude plugin marketplace add drewjs/skills
claude plugin install drewjs-skills@drewjs
```

Type `/drewjs-skills:hello`.

### Verify

```bash
claude plugin list
```

### Update

```bash
claude plugin marketplace update drewjs
```

### Uninstall

```bash
claude plugin uninstall drewjs-skills
claude plugin marketplace remove drewjs
```

Or keep it installed and turn it off: `claude plugin disable drewjs-skills`.

</details>

<details>
<summary><strong>Codex</strong></summary>

Codex's plugin CLI reads this repo's `.claude-plugin/plugin.json` and
`marketplace.json` directly — no separate Codex manifest needed.

### Install

```bash
codex plugin marketplace add drewjs/skills
codex plugin add drewjs-skills@drewjs
```

Then, in an interactive session, type `$hello`.

### Verify

```bash
codex plugin list
```

### Update

```bash
codex plugin marketplace upgrade
codex plugin add drewjs-skills@drewjs
```

### Uninstall

```bash
codex plugin remove drewjs-skills@drewjs
codex plugin marketplace remove drewjs
```

`hello`'s own check only looks for a Claude Code plugin install
(`~/.claude/plugins`), so invoking it from Codex will report "no installed
plugin found" rather than a real answer — it's a temporary install canary,
not a general-purpose skill.

</details>

<details>
<summary><strong>Everyone else</strong> (Pi, Cursor, OpenCode, Copilot, Zed, ...)</summary>

Works with any harness that reads Agent Skills via `npx skills`.

### Install

```bash
npx skills add drewjs/skills --list          # see what's in the repo first
npx skills add drewjs/skills --skill hello   # install a specific skill
```

`npx skills` scans the whole repo for any `SKILL.md`, with no notion of
this repo's promoted-vs-draft buckets — `--list` will also show
`new-skill`, a repo-local scaffolding tool that isn't meant for external
install. Install skills by name (`--skill <name>`), not with a bare
`add drewjs/skills`, to avoid pulling in anything outside
`skills/engineering/` or `skills/misc/`.

### Verify

```bash
npx skills list
```

### Update

```bash
npx skills update hello
```

### Uninstall

```bash
npx skills remove hello
```

</details>

## How activation works

Skills default to `disable-model-invocation: true` — installed does not
mean active. Invoke explicitly (`/drewjs-skills:hello`, `$hello`, or your
harness's equivalent) each session you want to use one.

## Troubleshooting

**Not showing up in autocomplete.** Restart the agent — the plugin/skill
index is read at startup.
