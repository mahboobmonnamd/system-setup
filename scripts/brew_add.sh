#!/usr/bin/env bash
# Install a formula/cask AND record it in a Brewfile, in one step — so what's
# installed and what's tracked never drift apart.
#
#   scripts/brew_add.sh <name> [base|personal|work|local]   (default: base)
#   make add NAME=<pkg> [TO=base|personal|work|local] [CASK=1]
#
# Auto-detects formula vs cask, adopts an already-installed cask instead of
# erroring, and skips the append if the line is already there.

set -euo pipefail

NAME="${1:?usage: brew_add.sh <name> [base|personal|work|local]}"
TARGET="${2:-base}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREW_DIR="$REPO_ROOT/brew"
FILE="$BREW_DIR/Brewfile.$TARGET"

case "$TARGET" in
  base|personal|work|local) ;;
  *)
    echo "target must be base|personal|work|local (got: $TARGET)" >&2
    exit 1
    ;;
esac

# Resolve brew even if PATH isn't set up (make runs a bare shell).
BREW="$(command -v brew || true)"
[[ -x "$BREW" ]] || BREW=/opt/homebrew/bin/brew
[[ -x "$BREW" ]] || { echo "brew not found" >&2; exit 1; }

# Brewfile.local is gitignored — create from the example on first use.
if [[ "$TARGET" == local && ! -f "$FILE" ]]; then
  cp "$BREW_DIR/Brewfile.local.example" "$FILE"
  echo "created brew/Brewfile.local from example"
fi

[[ -f "$FILE" ]] || { echo "no such Brewfile: $FILE" >&2; exit 1; }

# Detect kind. Prefer formula when a name exists as both (base is CLI-first),
# unless the caller forces a cask via CASK=1.
if [[ "${CASK:-}" == 1 ]]; then
  KIND=cask
elif "$BREW" info --formula "$NAME" >/dev/null 2>&1; then
  KIND=formula
elif "$BREW" info --cask "$NAME" >/dev/null 2>&1; then
  KIND=cask
else
  echo "unknown formula or cask: $NAME  (try CASK=1 make add NAME=$NAME ... to force cask)" >&2
  exit 1
fi

if [[ "$KIND" == cask ]]; then
  "$BREW" install --cask --adopt "$NAME"
  LINE="cask \"$NAME\""
else
  "$BREW" install "$NAME"
  LINE="brew \"$NAME\""
fi

# Warn if the same name is already tracked in a different Brewfile.
shopt -s nullglob
for other in "$BREW_DIR"/Brewfile.*; do
  [[ "$other" == "$FILE" ]] && continue
  [[ "$other" == *.example ]] && continue
  [[ "$other" == *.dumped ]] && continue
  if grep -qF "\"$NAME\"" "$other"; then
    echo "warning: \"$NAME\" also listed in $(basename "$other")" >&2
  fi
done
shopt -u nullglob

# Record it (dedup on the quoted name so `brew "x"`/`cask "x"` both match).
if grep -qF "\"$NAME\"" "$FILE"; then
  echo "already tracked in Brewfile.$TARGET — nothing to add"
  exit 0
fi

# Keep a single trailing newline before appending.
if [[ -s "$FILE" ]] && [[ "$(tail -c1 "$FILE" | wc -l)" -eq 0 ]]; then
  printf '\n' >>"$FILE"
fi
printf '%s\n' "$LINE" >>"$FILE"
echo "added  $LINE  ->  brew/Brewfile.$TARGET"
