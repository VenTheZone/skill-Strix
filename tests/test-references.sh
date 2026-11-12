#!/bin/sh
# test-references.sh — every skill name referenced in .agents/ resolves to a file.
set -eu

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
SKILLS="$ROOT/.agents/skills"
# Known-accepted dangling references (verbatim upstream files; port on demand).
KNOWN="gcp npx_confusion agentic_system_security semantic_confusion"
# Tool names, not skills.
TOOLS="load_skill"

fail=0

# Qualified references: `category/name` where category is a shipped skill category.
refs=$(grep -rhoE '`[a-z_]+/[a-z_]+`' "$ROOT/.agents" --include='*.md' | tr -d '`' | sort -u)
for ref in $refs; do
  cat=${ref%/*}
  [ -d "$SKILLS/$cat" ] || continue
  [ -f "$SKILLS/$ref.md" ] || { printf 'missing: %s\n' "$ref"; fail=1; }
done

# Bare names on lines that load a skill.
names=$(grep -rhE 'load_skill|Load `|load the `' "$ROOT/.agents" --include='*.md' \
  | grep -oE '[`"'"'"'][a-z_]+[`"'"'"']?' | tr -d '`"'"'"'' | sort -u)
for name in $names; do
  case " $KNOWN $TOOLS " in *" $name "*) continue ;; esac
  [ -f "$SKILLS/$name" ] && continue   # skip non-skill tokens that are paths
  find "$SKILLS" -name "$name.md" -print -quit | grep -q . \
    || { printf 'missing: %s\n' "$name"; fail=1; }
done

[ "$fail" -eq 0 ] && printf 'Reference integrity tests passed\n'
exit "$fail"
