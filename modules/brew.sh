#!/usr/bin/env bash
# Homebrew install + bundle (brew/Brewfile.base + brew/Brewfile.$SETUP_PROFILE).
# Idempotent: brew bundle, pyenv install -s, nvm LTS + global npm packages.
# shellcheck shell=bash

_BREW_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$_BREW_SH_DIR/lib.sh"

main_brew() {
  require_darwin

  local base="$REPO_ROOT/brew/Brewfile.base"
  local extra
  extra="$(brewfile_for_profile)"

  if [[ ! -f "$base" ]]; then
    err "Missing $base"
    exit 1
  fi

  info "Profile: $(setup_profile) (base + $(basename "$extra"))"

  if ! command -v brew &>/dev/null; then
    if [[ -n "${DRY_RUN:-}" ]]; then
      info "[dry-run] Would install Homebrew (official script) and append brew shellenv to ~/.zprofile"
    else
      info "Installing Homebrew..."
      sudo --validate
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      {
        echo
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
      } >>"$HOME/.zprofile"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi

  info "brew bundle install (base)..."
  run brew bundle install --file="$base"

  info "brew bundle install ($(setup_profile))..."
  run brew bundle install --file="$extra"

  if [[ -n "${DRY_RUN:-}" ]]; then
    info "[dry-run] Would run: pyenv install -s 3.9 (if pyenv on PATH)"
    info "[dry-run] Would run: nvm install --lts --default && npm install -g typescript ts-node (if nvm present)"
    return 0
  fi

  if command -v pyenv &>/dev/null; then
    pyenv install -s 3.9
  fi

  if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    # shellcheck source=/dev/null
    . "/opt/homebrew/opt/nvm/nvm.sh"
    nvm install --lts --default
    npm install -g typescript ts-node
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main_brew
fi
