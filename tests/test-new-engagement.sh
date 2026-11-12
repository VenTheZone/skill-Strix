#!/bin/sh
set -eu

ROOT=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
WORK=$(mktemp -d "$ROOT/.mode-test.XXXXXX")
trap 'rm -rf "$WORK"' EXIT HUP INT TERM
cd "$WORK"

for pair in whitehat:whitehat white:whitehat engagement:engagement gray:engagement blackhat:blackhat black:blackhat; do
  input=${pair%:*}
  expected=${pair#*:}
  sh "$ROOT/.agents/templates/new-engagement.sh" "$input" --mode "$input" >/dev/null
  grep -F "**Mode**: $expected " "$input/scope.md" >/dev/null
  grep -F '## BlackHat research limits' "$input/scope.md" >/dev/null
  if grep -E 'ENGAGEMENT_NAME|MODE_PLACEHOLDER|DATE_PLACEHOLDER' "$input/scope.md" "$input/README.md" >/dev/null; then
    printf 'Unexpanded template in %s\n' "$input" >&2
    exit 1
  fi
done

for input in invalid lab redteam red-team; do
  if sh "$ROOT/.agents/templates/new-engagement.sh" "$input" --mode "$input" >/dev/null 2>&1; then
    printf 'Invalid mode accepted: %s\n' "$input" >&2
    exit 1
  fi
done
printf 'Mode scaffold tests passed\n'
