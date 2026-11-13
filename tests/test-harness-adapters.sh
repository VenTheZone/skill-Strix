#!/bin/sh
# Packaging checks for harness copy sources. Does not run a harness or a pentest.
set -eu

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)

READS="
.agents/SKILL.md
.agents/skills/coordination/scope_and_modes.md
.agents/skills/coordination/engagement_lifecycle.md
.agents/skills/coordination/target_workflow.md
.agents/skills/coordination/run_state.md
"

ADAPTERS="
adapters/claude-code/CLAUDE.md
adapters/codex/AGENTS.md
adapters/opencode/AGENTS.md
adapters/pi/AGENTS.md
adapters/hermes/AGENTS.md
adapters/freebuff/AGENTS.md
adapters/kilo/AGENTS.md
"

fail=0

# Full phrases, one per line. A word-splitting loop would accept the split-phrase fixture.
read_markers() {
  while IFS= read -r marker; do
    [ -n "$marker" ] || continue
    printf '%s\n' "$marker"
  done <<'EOF'
filled authorized scope
When this session has no delegation tool
Do not invent tool names
Report missing tools
not present merely because these instructions are loaded
EOF
}

for rel in $READS .agents/skills/strix-pentest/SKILL.md .agents/templates/new-engagement.sh; do
  [ -f "$ROOT/$rel" ] || { printf 'missing shared file: %s\n' "$rel" >&2; fail=1; }
done
[ -f "$ROOT/LICENSE" ] && [ -f "$ROOT/NOTICE" ] || { printf 'missing LICENSE or NOTICE\n' >&2; fail=1; }

check_copy() {
  file=$1
  label=$2
  [ -f "$file" ] || { printf 'missing adapter: %s\n' "$label" >&2; return 1; }
  set -- $(wc -l < "$file")
  if [ "$1" -gt 160 ]; then
    printf 'adapter too large (%s lines): %s\n' "$1" "$label" >&2
    return 1
  fi
  if grep -q -F '## 1. Agent Orchestration' "$file"; then
    printf 'adapter forks methodology: %s\n' "$label" >&2
    return 1
  fi
  if grep -q -F 'enforced by this file' "$file"; then
    printf 'adapter claims enforcement: %s\n' "$label" >&2
    return 1
  fi
  while IFS= read -r req; do
    [ -n "$req" ] || continue
    grep -q -F "$req" "$file" || { printf 'missing path %s in %s\n' "$req" "$label" >&2; return 1; }
  done <<EOF
$READS
EOF
  while IFS= read -r marker; do
    grep -q -F "$marker" "$file" || { printf 'missing marker in %s: %s\n' "$label" "$marker" >&2; return 1; }
  done <<EOF
$(read_markers)
EOF
  return 0
}

for rel in $ADAPTERS; do
  check_copy "$ROOT/$rel" "$rel" || fail=1
  grep -q -F '.agents/skills/strix-pentest/SKILL.md' "$ROOT/$rel" \
    || { printf 'missing wrapper path in %s\n' "$rel" >&2; fail=1; }
done

check_copy "$ROOT/.agents/skills/strix-pentest/SKILL.md" "wrapper" || fail=1

wrapper=$ROOT/.agents/skills/strix-pentest/SKILL.md
awk '
  NR == 1 && $0 == "---" { fm = 1; next }
  fm && $0 == "---" { exit }
  fm && $0 == "name: strix-pentest" { name = 1 }
  fm && $0 ~ /^description: .+/ { desc = 1 }
  END { exit !(name && desc) }
' "$wrapper" || { printf 'wrapper frontmatter name/description\n' >&2; fail=1; }

grep -q -F '.agents/templates/new-engagement.sh' "$wrapper" \
  || { printf 'wrapper missing engagement scaffold\n' >&2; fail=1; }
grep -q -F 'Do not rely on `.opencode`' "$ROOT/adapters/opencode/AGENTS.md" \
  || { printf 'opencode adapter missing .opencode warning\n' >&2; fail=1; }
grep -q -F 'avoid duplicate loading' "$ROOT/adapters/pi/AGENTS.md" \
  || { printf 'pi adapter missing duplicate-loading warning\n' >&2; fail=1; }
grep -q -F 'hermes skills trust' "$ROOT/adapters/hermes/AGENTS.md" \
  || { printf 'hermes adapter missing trust step\n' >&2; fail=1; }
grep -q -F 'If the skill is not in the skill index, read the files below directly.' "$ROOT/adapters/hermes/AGENTS.md" \
  || { printf 'hermes adapter missing manual-read fallback\n' >&2; fail=1; }
grep -q -F '`.agents/SKILL.md` is not auto-discovered.' "$ROOT/adapters/freebuff/AGENTS.md" \
  || { printf 'freebuff adapter missing discovery limit\n' >&2; fail=1; }
grep -q -F '.claude/skills/strix-pentest/SKILL.md' "$ROOT/adapters/claude-code/CLAUDE.md" \
  || { printf 'claude adapter missing skill dest\n' >&2; fail=1; }

for a in $ADAPTERS; do
  for b in $ADAPTERS; do
    [ "$a" = "$b" ] && continue
    if cmp -s "$ROOT/$a" "$ROOT/$b"; then
      printf 'duplicate adapter body: %s and %s\n' "$a" "$b" >&2
      fail=1
    fi
  done
done

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

bad=$ROOT/tests/fixtures/bad-harness-adapter/AGENTS.md
if [ ! -f "$bad" ]; then
  printf 'negative fixture missing\n' >&2
  fail=1
else
  while IFS= read -r marker; do
    grep -q -F "$marker" "$bad" || {
      printf 'negative fixture is not meaningful, missing: %s\n' "$marker" >&2
      fail=1
    }
  done <<EOF
$(read_markers)
EOF
  grep -q -F 'enforced by this file' "$bad" \
    || { printf 'negative fixture lost the enforcement claim\n' >&2; fail=1; }
  if check_copy "$bad" "negative-fixture" 2>"$work/neg.err"; then
    printf 'negative fixture passed; it must fail\n' >&2
    fail=1
  fi
  grep -q -F 'adapter claims enforcement: negative-fixture' "$work/neg.err" \
    || { printf 'negative fixture did not fail on the enforcement claim\n' >&2; fail=1; }
  if grep -q -F 'missing marker in negative-fixture:' "$work/neg.err"; then
    printf 'negative fixture failed on a missing phrase, not the false claim\n' >&2
    fail=1
  fi
fi

printf 'false\n' > "$work/bare-false.md"
if check_copy "$work/bare-false.md" "bare-false" 2>"$work/bare-false.err"; then
  printf 'bare false marker claim was accepted\n' >&2
  fail=1
fi
if grep -q -F 'missing marker in bare-false: false' "$work/bare-false.err"; then
  printf 'false is not a marker phrase\n' >&2
  fail=1
fi

# A missing fixture path must fail closed. Do not treat absence as a pass.
if check_copy "$ROOT/tests/fixtures/bad-harness-adapter/no-such.md" "missing-fixture" 2>/dev/null; then
  printf 'missing fixture was accepted\n' >&2
  fail=1
fi

readme=$ROOT/README.md
for needle in \
  'docs-verified' \
  'runtime-tested' \
  'CLAUDE.md.example' \
  'AGENTS.md.example' \
  'cp -a .agents' \
  'cp -a LICENSE NOTICE' \
  'avoid duplicate loading' \
  'Do not rely on `.opencode`' \
  'hermes skills trust' \
  'not auto-discovered'
 do
  grep -q -F "$needle" "$readme" || { printf 'README missing: %s\n' "$needle" >&2; fail=1; }
done

for rel in $ADAPTERS; do
  base=${rel#adapters/}
  base=${base%/*}
  grep -q -F "$base" "$readme" || { printf 'README missing harness: %s\n' "$base" >&2; fail=1; }
done

grep -q -F 'Working here is not authorization' "$ROOT/AGENTS.md" \
  || { printf 'root AGENTS.md missing maintainer boundary\n' >&2; fail=1; }
grep -q -F '@AGENTS.md' "$ROOT/CLAUDE.md" \
  || { printf 'root CLAUDE.md missing import\n' >&2; fail=1; }
grep -q -F 'not an authorized engagement' "$ROOT/CLAUDE.md" \
  || { printf 'root CLAUDE.md missing boundary\n' >&2; fail=1; }

split=$work/split.md
cat > "$split" <<'EOF'
.agents/SKILL.md
.agents/skills/coordination/scope_and_modes.md
.agents/skills/coordination/engagement_lifecycle.md
.agents/skills/coordination/target_workflow.md
.agents/skills/coordination/run_state.md
filled
authorized
scope
When this session has no delegation tool
Do not invent tool names
Report missing tools
not present merely because these instructions are loaded
EOF
if check_copy "$split" "split-phrase" 2>"$work/split.err"; then
  printf 'split phrase was accepted\n' >&2
  fail=1
fi
grep -q -F 'missing marker in split-phrase: filled authorized scope' "$work/split.err" \
  || { printf 'split phrase did not fail on the full marker\n' >&2; fail=1; }

# Install fences are syntax-checked and phrase-checked. They are not executed.
n=0
while IFS= read -r line; do
  case $line in
    '```bash')
      n=$((n + 1))
      block=$work/block-$n.sh
      : > "$block"
      capture=1
      ;;
    '```')
      capture=0
      ;;
    *)
      if [ "${capture:-0}" -eq 1 ]; then
        printf '%s\n' "$line" >> "$block"
      fi
      ;;
  esac
done < "$readme"
[ "$n" -ge 1 ] || { printf 'README has no bash install blocks\n' >&2; fail=1; }
i=1
while [ "$i" -le "$n" ]; do
  block=$work/block-$i.sh
  sh -n "$block" || { printf 'README bash block syntax: %s\n' "$block" >&2; fail=1; }
  grep -q -F 'set -eu' "$block" || { printf 'README bash block missing set -eu\n' >&2; fail=1; }
  if grep -q -F 'test ! -e' "$block"; then
    printf 'README bash block uses test ! -e\n' >&2
    fail=1
  fi
  awk '
    /set -eu/ { armed = 1 }
    /(^|[[:space:]])(cp|mv|mkdir)[[:space:]]/ && !armed { bad = 1 }
    END { exit bad ? 1 : 0 }
  ' "$block" || { printf 'README copy runs before set -eu\n' >&2; fail=1; }
  i=$((i + 1))
done
for phrase in \
  'HARNESS=codex' \
  'case "$HARNESS" in' \
  'claude-code)' \
  'cp -a .agents' \
  'cp -a LICENSE NOTICE' \
  '[ -L' \
  'Merge the shared tree by hand. This copy does not merge or replace it.' \
  'inactive until' \
  'Do not install both `AGENTS.md` and `CLAUDE.md`.' \
  'Refusing to write through a symlink. Merge by hand.'
 do
  grep -q -F "$phrase" "$readme" || { printf 'README missing install phrase: %s\n' "$phrase" >&2; fail=1; }
done
awk '
  /cp -a \.agents/ { agents = NR }
  /cp -a LICENSE NOTICE/ { lic = NR }
  END { exit !(agents && lic && agents < lic) }
' "$readme" || { printf 'LICENSE copy does not follow the shared tree\n' >&2; fail=1; }

guard=$work/guard
mkdir "$guard"
ln -s missing "$guard/.agents"
if (
  set -eu
  if [ -e "$guard/.agents" ] || [ -L "$guard/.agents" ]; then
    exit 1
  fi
  cp -a "$ROOT/.agents" "$guard/.agents"
); then
  printf 'symlink guard did not stop copy\n' >&2
  fail=1
fi
[ -L "$guard/.agents" ] || { printf 'symlink guard replaced .agents\n' >&2; fail=1; }

printf 'example\n' > "$guard/AGENTS.md.example"
ln -s missing "$guard/AGENTS.md"
if (
  set -eu
  if [ -e "$guard/AGENTS.md" ] || [ -L "$guard/AGENTS.md" ]; then
    exit 1
  fi
  mv "$guard/AGENTS.md.example" "$guard/AGENTS.md"
); then
  printf 'rename guard replaced a dangling symlink\n' >&2
  fail=1
fi
[ -L "$guard/AGENTS.md" ] && [ -f "$guard/AGENTS.md.example" ] \
  || { printf 'rename guard clobbered the example or the link\n' >&2; fail=1; }

[ "$fail" -eq 0 ] && printf 'Harness adapter tests passed\n'
exit "$fail"
