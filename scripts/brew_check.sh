#!/usr/bin/env bash
# Drift check: list Homebrew packages/casks installed on this machine but NOT
# tracked in any Brewfile (base + current profile + local). READ-ONLY — it
# never uninstalls anything. Complements `make add`.
#
#   make check                 # checks base + personal + local
#   make check PROFILE=work    # checks base + work + local

set -euo pipefail

PROFILE="${PROFILE:-personal}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREW="$(command -v brew || true)"; [[ -x "$BREW" ]] || BREW=/opt/homebrew/bin/brew

tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
for f in base "$PROFILE" local; do
  [[ -f "$REPO_ROOT/brew/Brewfile.$f" ]] && cat "$REPO_ROOT/brew/Brewfile.$f" >> "$tmp"
done

echo "Installed but NOT in Brewfile.{base,$PROFILE,local}:"
echo "(record one with:  make add NAME=<pkg> [TO=personal])"
echo
# `cleanup` without --force is a dry run: it only PRINTS what is untracked.
"$BREW" bundle cleanup --file="$tmp" || true
