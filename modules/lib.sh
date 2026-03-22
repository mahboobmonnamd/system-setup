#!/usr/bin/env bash
# Shared helpers: logging, macOS guard, dry-run, profile resolution.
# shellcheck shell=bash

set -o errexit
set -o nounset
set -o pipefail

MODULES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
REPO_ROOT="$(cd "$MODULES_DIR/.." && pwd)"

reset_color=$(tput sgr0 2>/dev/null || true)
info() { printf "%s[*] %s%s\n" "$(tput setaf 4 2>/dev/null || true)" "$1" "$reset_color"; }
success() { printf "%s[*] %s%s\n" "$(tput setaf 2 2>/dev/null || true)" "$1" "$reset_color"; }
err() { printf "%s[*] %s%s\n" "$(tput setaf 1 2>/dev/null || true)" "$1" "$reset_color" >&2; }
warn() { printf "%s[*] %s%s\n" "$(tput setaf 3 2>/dev/null || true)" "$1" "$reset_color"; }

require_darwin() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    err "This setup targets macOS only (Darwin). Refusing to run on $(uname -s)."
    exit 1
  fi
}

# SETUP_PROFILE names brew/Brewfile.<name> (e.g. personal, work). Add new files under brew/.
setup_profile() {
  local p="${SETUP_PROFILE:-personal}"
  local f="$REPO_ROOT/brew/Brewfile.$p"
  if [[ ! -f "$f" ]]; then
    err "No brew/Brewfile.$p — set SETUP_PROFILE or create that file."
    exit 1
  fi
  echo "$p"
}

# Run a command, or print it when DRY_RUN is non-empty.
run() {
  if [[ -n "${DRY_RUN:-}" ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

brewfile_for_profile() {
  echo "$REPO_ROOT/brew/Brewfile.$(setup_profile)"
}
