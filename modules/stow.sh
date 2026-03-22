#!/usr/bin/env bash
# Symlink stow packages into $HOME.
#
# Why --adopt is NOT default: stow --adopt moves existing file *contents* into the
# stow package and replaces them with symlinks — that rewrites your repo with machine-
# specific data and is easy to commit by mistake. Use STOW_ADOPT=1 only when you
# intentionally want to absorb existing files into the package.
#
# Idempotency: plain stow is safe to re-run when targets are already correct symlinks.
# shellcheck shell=bash

set -euo pipefail

_STOW_MOD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$_STOW_MOD_DIR/lib.sh"

require_darwin

STOW_DIR="${STOW_DIR:-$REPO_ROOT/stow}"
_default_pkgs=(git zsh nvim finicky)
if [[ -n "${STOW_PACKAGES:-}" ]]; then
  read -r -a pkgs <<<"$STOW_PACKAGES"
else
  pkgs=("${_default_pkgs[@]}")
fi

cd "$STOW_DIR"

stow_one() {
  local pkg="$1"
  local -a cmd=(stow)

  if [[ -n "${DRY_RUN:-}" ]]; then
    cmd+=(-n)
  fi

  cmd+=(-v -t "$HOME" "$pkg" --ignore=".DS_Store")

  if [[ -n "${STOW_ADOPT:-}" ]]; then
    cmd+=(--adopt)
    warn "Using --adopt for $pkg (see modules/stow.sh header)."
  fi

  run "${cmd[@]}"
}

main_stow() {
  info "Stow dir: $STOW_DIR packages: ${pkgs[*]}"
  if [[ -n "${DRY_RUN:-}" ]]; then
    info "Dry-run mode: stow -n (no changes)."
  fi
  local pkg
  for pkg in "${pkgs[@]}"; do
    if [[ ! -d "$STOW_DIR/$pkg" ]]; then
      err "Missing stow package directory: $STOW_DIR/$pkg"
      exit 1
    fi
    info "Stowing $pkg"
    stow_one "$pkg"
  done

  if [[ -n "${DRY_RUN:-}" ]]; then
    success "Dry-run complete. Unset DRY_RUN to apply."
  elif [[ "${STOW_RELOAD_SHELL:-}" == 1 ]]; then
    info "Reloading shell..."
    exec "${SHELL:-/bin/zsh}" -l
  else
    success "Stow complete. Open a new shell, or: STOW_RELOAD_SHELL=1 $0"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main_stow
fi
