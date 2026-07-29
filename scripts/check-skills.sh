#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "error: $1" >&2
  exit 1
}

command -v jq >/dev/null 2>&1 || fail "jq is required but not found on PATH"

PLUGIN_JSON="$ROOT/.claude-plugin/plugin.json"
MARKETPLACE_JSON="$ROOT/.claude-plugin/marketplace.json"

[ -f "$PLUGIN_JSON" ] || fail "missing $PLUGIN_JSON"
[ -f "$MARKETPLACE_JSON" ] || fail "missing $MARKETPLACE_JSON"

# 1. Both manifests are valid JSON.
jq empty "$PLUGIN_JSON" 2>/dev/null || fail "$PLUGIN_JSON is not valid JSON"
jq empty "$MARKETPLACE_JSON" 2>/dev/null || fail "$MARKETPLACE_JSON is not valid JSON"

# 2. plugin.json .skills and the drewjs-skills marketplace entry .skills are identical arrays (sorted).
PLUGIN_SKILLS_SORTED="$(jq -c '.skills // [] | sort' "$PLUGIN_JSON")"
MARKETPLACE_ENTRY="$(jq -c '.plugins[]? | select(.name == "drewjs-skills")' "$MARKETPLACE_JSON")"
[ -n "$MARKETPLACE_ENTRY" ] || fail "no plugin entry named drewjs-skills in $MARKETPLACE_JSON"
MARKETPLACE_SKILLS_SORTED="$(echo "$MARKETPLACE_ENTRY" | jq -c '.skills // [] | sort')"
[ "$PLUGIN_SKILLS_SORTED" = "$MARKETPLACE_SKILLS_SORTED" ] || fail "plugin.json .skills and marketplace.json drewjs-skills .skills differ: $PLUGIN_SKILLS_SORTED vs $MARKETPLACE_SKILLS_SORTED"

# 3. Every path in plugin.json .skills resolves to an existing <path>/SKILL.md.
while IFS= read -r p; do
  [ -n "$p" ] || continue
  [ -f "$ROOT/$p/SKILL.md" ] || fail "listed skill path has no SKILL.md: $p"
done < <(jq -r '.skills // [] | .[]' "$PLUGIN_JSON")

# 4. Every skills/engineering/*/SKILL.md has its directory present in plugin.json .skills.
if [ -d "$ROOT/skills/engineering" ]; then
  while IFS= read -r skill_md; do
    [ -n "$skill_md" ] || continue
    dir="$(dirname "$skill_md")"
    name="$(basename "$dir")"
    rel="./skills/engineering/$name"
    jq -e --arg rel "$rel" '.skills // [] | index($rel) != null' "$PLUGIN_JSON" >/dev/null \
      || fail "promoted skill $rel is missing from plugin.json .skills"
  done < <(find "$ROOT/skills/engineering" -mindepth 2 -maxdepth 2 -name SKILL.md)
fi

# 5. No manifest skills entry points anywhere under skills/experimental/.
if jq -e '.skills // [] | any(test("skills/experimental/"))' "$PLUGIN_JSON" >/dev/null; then
  fail "plugin.json .skills references skills/experimental/"
fi
if echo "$MARKETPLACE_ENTRY" | jq -e '.skills // [] | any(test("skills/experimental/"))' >/dev/null; then
  fail "marketplace.json drewjs-skills .skills references skills/experimental/"
fi

# 6. Every promoted skill name appears in root README.md and skills/engineering/README.md.
ROOT_README="$ROOT/README.md"
ENG_README="$ROOT/skills/engineering/README.md"
[ -f "$ROOT_README" ] || fail "missing $ROOT_README"
[ -f "$ENG_README" ] || fail "missing $ENG_README"
if [ -d "$ROOT/skills/engineering" ]; then
  while IFS= read -r skill_md; do
    [ -n "$skill_md" ] || continue
    name="$(basename "$(dirname "$skill_md")")"
    grep -q "$name" "$ROOT_README" || fail "promoted skill '$name' not mentioned in README.md"
    grep -q "$name" "$ENG_README" || fail "promoted skill '$name' not mentioned in skills/engineering/README.md"
  done < <(find "$ROOT/skills/engineering" -mindepth 2 -maxdepth 2 -name SKILL.md)
fi

# 7. No skills/experimental/* skill name appears in either manifest.
if [ -d "$ROOT/skills/experimental" ]; then
  while IFS= read -r skill_md; do
    [ -n "$skill_md" ] || continue
    name="$(basename "$(dirname "$skill_md")")"
    jq -e --arg name "$name" '.skills // [] | any(test($name))' "$PLUGIN_JSON" >/dev/null \
      && fail "experimental skill '$name' referenced in plugin.json"
    echo "$MARKETPLACE_ENTRY" | jq -e --arg name "$name" '.skills // [] | any(test($name))' >/dev/null \
      && fail "experimental skill '$name' referenced in marketplace.json"
    true
  done < <(find "$ROOT/skills/experimental" -mindepth 2 -maxdepth 2 -name SKILL.md)
fi

# 8. Every SKILL.md under skills/ has frontmatter name: equal to its parent directory name.
while IFS= read -r skill_md; do
  [ -n "$skill_md" ] || continue
  dir_name="$(basename "$(dirname "$skill_md")")"
  fm_name="$(awk '/^---$/{c++; next} c==1 && /^name:/{print; exit}' "$skill_md" | sed -E 's/^name:[[:space:]]*//' | tr -d '"'"'"'\r')"
  [ "$fm_name" = "$dir_name" ] || fail "$skill_md frontmatter name '$fm_name' != directory name '$dir_name'"
done < <(find "$ROOT/skills" -mindepth 2 -name SKILL.md)

# 9. If claude CLI is on PATH, run claude plugin validate --strict.
if command -v claude >/dev/null 2>&1; then
  claude plugin validate "$ROOT" --strict || fail "claude plugin validate --strict failed"
else
  echo "skip: claude CLI not found on PATH, skipping plugin validate"
fi

echo "ok: all skill checks passed"
