#!/usr/bin/env bash
set -euo pipefail

# DEV ONLY. Symlinks skills/experimental/* into ~/.claude/skills and
# ~/.agents/skills so you can test a draft skill locally before promoting it.
# Promoted skills (skills/engineering/*) reach you via the installed plugin —
# do not link those here, or they would double-load.
#
# SAFETY: on this machine ~/.claude/skills is a directory of symlinks into
# ~/.agents/skills tracked by ~/.claude/skills/.skill-lock.json. Never
# force-overwrite (`ln -sfn`) or rm -rf anything in these destinations —
# clobbering an entry could break that tracking for skills we don't own.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

resolve() {
  # Absolute, symlink-resolved path. Works even if the path doesn't exist yet.
  perl -MCwd -e 'print Cwd::abs_path(shift @ARGV) // ""' "$1"
}

is_under_root() {
  case "$1" in
    "$ROOT"|"$ROOT"/*) return 0 ;;
    *) return 1 ;;
  esac
}

shopt -s nullglob
candidates=("$ROOT"/skills/experimental/*/SKILL.md)
shopt -u nullglob

if [ ${#candidates[@]} -eq 0 ]; then
  echo "no experimental skills to link"
  exit 0
fi

for dest in "${DESTS[@]}"; do
  mkdir -p "$dest"

  # Guard: bail if the destination directory itself is a symlink resolving
  # inside this repo (would create a self-referential loop when we link
  # individual skills into it).
  if [ -L "$dest" ]; then
    dest_resolved="$(resolve "$dest")"
    if is_under_root "$dest_resolved"; then
      echo "error: $dest is a symlink resolving inside this repo ($dest_resolved); refusing to link into it" >&2
      exit 1
    fi
  fi
done

for skill_md in "${candidates[@]}"; do
  dir="$(dirname "$skill_md")"
  name="$(basename "$dir")"

  for dest in "${DESTS[@]}"; do
    target="$dest/$name"

    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ -L "$target" ]; then
        target_resolved="$(resolve "$target")"
      else
        target_resolved=""
      fi

      if [ -L "$target" ] && is_under_root "$target_resolved"; then
        # Already a symlink into this repo — refresh it silently.
        rm "$target"
        ln -s "$dir" "$target"
        echo "linked: $target -> $dir"
      else
        echo "error: $target already exists (points to ${target_resolved:-a non-symlink entry}); rename your skill or remove that entry" >&2
        exit 1
      fi
      continue
    fi

    ln -s "$dir" "$target"
    echo "linked: $target -> $dir"
  done
done
