#!/usr/bin/env bash

set -o errexit

script_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$script_root/.." && pwd)

# shellcheck source=../modules/lib.sh
source "$REPO_ROOT/modules/lib.sh"

info "####### dotfiles #######"
if [[ -z "${BOOTSTRAP_NONINTERACTIVE:-}" ]]; then
  read -r -p "Press enter to start:"
fi
info "Bootstrapping (SETUP_PROFILE=${SETUP_PROFILE:-personal})..."

require_darwin

if [[ -n "${DRY_RUN:-}" ]]; then
  export DRY_RUN=1
  warn "[dry-run] Skipping sudo, Xcode CLT, and osx.sh (defaults/killall)"
  bash "$REPO_ROOT/modules/setup-apps.sh"
  bash "$REPO_ROOT/modules/stow.sh"
  success "Bootstrap dry-run finished."
  exit 0
fi

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

install_xcode() {
  if xcode-select -p >/dev/null; then
    warn "Xcode Command Line Tools already installed"
  else
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    sudo xcodebuild -license accept
  fi
}

install_xcode

bash "$REPO_ROOT/modules/setup-apps.sh"
bash "$script_root/osx.sh"
bash "$REPO_ROOT/modules/stow.sh"

success "Bootstrap finished."
