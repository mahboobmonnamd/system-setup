#!/usr/bin/env zsh

set -e

REPO_STOW="$(cd "$(dirname "$0")" && pwd)"
DOT_FOLDERS=(git zsh nvim finicky)

cd "$REPO_STOW"

for folder in $DOT_FOLDERS; do
  echo "+ Stowing $folder"
  stow -v -t "$HOME" "$folder" --ignore=".DS_Store" --adopt
done

if [[ "${STOW_RELOAD_SHELL:-}" == 1 ]]; then
  echo "+ Reloading shell..."
  exec "$SHELL" -l
else
  echo "+ Done. Open a new terminal tab, or run: STOW_RELOAD_SHELL=1 $0"
fi
