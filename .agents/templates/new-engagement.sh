#!/bin/sh
# new-engagement.sh <name> --mode whitehat|engagement|lab
# Scaffolds an engagement workspace from the bundled template.
set -eu

usage() { echo "usage: $0 <name> --mode whitehat|engagement|lab" >&2; exit 2; }

[ "${1:-}" ] || usage
NAME=$1; shift
case $NAME in */*) { echo "error: name must not contain /" >&2; exit 2; } ;; esac
MODE=
while [ $# -gt 0 ]; do
  case $1 in
    --mode) [ -n "${2:-}" ] || usage; MODE=$2; shift 2 ;;
    *) usage ;;
  esac
done
case $MODE in whitehat|engagement|lab) ;; *) usage ;; esac
[ -e "$NAME" ] && { echo "error: $NAME exists" >&2; exit 1; }

TEMPLATE=$(CDPATH='' cd -- "$(dirname -- "$0")/engagement" && pwd)
cp -r "$TEMPLATE" "$NAME"
sed -i '' "s/ENGAGEMENT_NAME/$NAME/g; s/MODE_PLACEHOLDER/$MODE/g; s/DATE_PLACEHOLDER/$(date +%F)/g" \
  "$NAME/scope.md" "$NAME/README.md" 2>/dev/null \
|| sed -i "s/ENGAGEMENT_NAME/$NAME/g; s/MODE_PLACEHOLDER/$MODE/g; s/DATE_PLACEHOLDER/$(date +%F)/g" \
  "$NAME/scope.md" "$NAME/README.md"

echo "created $NAME/ (mode: $MODE)"
echo "next: fill $NAME/scope.md — no scope, no recon"
