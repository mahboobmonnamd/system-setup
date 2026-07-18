#!/usr/bin/env bash
# Bootstrap git identities (personal / work). Run interactively:
#   ./scripts/git_setup.sh              # personal only
#   ./scripts/git_setup.sh personal work
#
# For each profile this:
#   1. Generates an ed25519 SSH key at ~/.ssh/id_ed25519_<profile> (if missing)
#   2. Adds it to the ssh-agent + macOS Keychain
#   3. Creates ~/.config/git/identity-<profile>.gitconfig from the tracked
#      .example template and prompts for your real name/email
#   4. Prints the public key to paste into that account's GitHub settings
#
# Re-running is safe: existing keys/identity files are left untouched.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES="$REPO_ROOT/stow/git/.config/git"
LIVE_DIR="$HOME/.config/git"

info() { printf '\033[34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[33mWARN:\033[0m %s\n' "$*" >&2; }

host_alias() {
  case "$1" in
    personal) echo "github.com" ;;
    *)        echo "github.com-$1" ;;
  esac
}

setup_one() {
  local profile="$1"
  local key="$HOME/.ssh/id_ed25519_${profile}"
  local identity="$LIVE_DIR/identity-${profile}.gitconfig"
  local template="$TEMPLATES/identity-${profile}.gitconfig.example"

  info "Profile: $profile"

  if [[ -e "$identity" ]]; then
    ok "identity exists: $identity (leaving as-is)"
  elif [[ ! -f "$template" ]]; then
    warn "no template $template — skipping identity file"
  else
    mkdir -p "$LIVE_DIR"
    cp "$template" "$identity"
    local name email
    printf 'Name for %s: ' "$profile"; read -r name
    printf 'Email for %s: ' "$profile"; read -r email
    git config -f "$identity" user.name "$name"
    git config -f "$identity" user.email "$email"
    git config -f "$identity" core.sshCommand "ssh -i $key -o IdentitiesOnly=yes"
    ok "wrote $identity"
  fi

  if [[ -f "$key" ]]; then
    ok "ssh key exists: $key (leaving as-is)"
  else
    ssh-keygen -t ed25519 -C "${profile}@$(hostname -s)" -f "$key"
    ok "generated $key"
  fi

  ssh-add --apple-use-keychain "$key" 2>/dev/null || warn "could not add $key to agent"

  info "Add this public key at https://github.com/settings/ssh/new ($profile account):"
  cat "${key}.pub"
  command -v pbcopy >/dev/null && { pbcopy < "${key}.pub"; ok "copied to clipboard"; }
  info "Clone $profile repos with:  git clone git@$(host_alias "$profile"):OWNER/REPO.git"
  echo
}

main() {
  local -a profiles=("${@:-personal}")
  eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
  for p in "${profiles[@]}"; do setup_one "$p"; done
  ok "Done. In any repo, confirm identity with:  git whoami"
}

main "$@"
