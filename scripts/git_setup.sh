#!/usr/bin/env bash
# Bootstrap one or more git identities (personal / work / freelance / oss).
#
# Identity is chosen per repo by the REMOTE URL (see the [includeIf hasconfig:]
# rules in stow/git/.gitconfig). Clone with the matching SSH host alias and the
# right name/email + key apply automatically — no per-folder setup, and nothing
# identifying lives in the public repo.
#
# For each chosen profile this:
#   1. Generates an ed25519 SSH key at ~/.ssh/id_ed25519_<profile> (if missing).
#   2. Adds it to the ssh-agent + macOS Keychain.
#   3. Materializes ~/.config/git/identity-<profile>.gitconfig from the tracked
#      .example template, then prompts for the real name/email.
#   4. Prints the public key to register on that account's GitHub.
#
# Re-running is safe: existing keys/identity files are left untouched.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GIT_CONF_SRC="$REPO_ROOT/stow/git/.config/git"   # tracked .example templates
GIT_CONF_DIR="$HOME/.config/git"                 # live identity files

ALL_PROFILES=(personal work freelance oss)

info()  { printf '\033[34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[33mWARN:\033[0m %s\n' "$*" >&2; }
ok()    { printf '\033[32m✓\033[0m %s\n' "$*"; }

# The SSH host alias each profile clones with. 'personal' uses plain github.com;
# the rest use github.com-<profile> (defined in stow/ssh/.ssh/config).
host_alias() {
  case "$1" in
    personal) echo "github.com" ;;
    *)        echo "github.com-$1" ;;
  esac
}

setup_one() {
  local profile="$1"
  local key="$HOME/.ssh/id_ed25519_${profile}"
  local identity="$GIT_CONF_DIR/identity-${profile}.gitconfig"
  local template="$GIT_CONF_SRC/identity-${profile}.gitconfig.example"

  info "Profile: $profile"

  # 1. Identity file (name/email) — copy template if missing, then prompt.
  if [[ -e "$identity" ]]; then
    ok "identity exists: $identity (leaving as-is)"
  elif [[ ! -f "$template" ]]; then
    warn "no template $template — skipping identity file"
  else
    mkdir -p "$GIT_CONF_DIR"
    cp "$template" "$identity"
    local name email
    printf 'Name for %s: ' "$profile"; read -r name
    printf 'Email for %s: ' "$profile"; read -r email
    git config -f "$identity" user.name "$name"
    git config -f "$identity" user.email "$email"
    git config -f "$identity" core.sshCommand "ssh -i $key -o IdentitiesOnly=yes"
    ok "wrote $identity"
  fi

  # 2. SSH key — generate if missing (ssh-keygen prompts for a passphrase).
  if [[ -f "$key" ]]; then
    ok "ssh key exists: $key (leaving as-is)"
  else
    ssh-keygen -t ed25519 -C "${profile}@$(hostname -s)" -f "$key"
    ok "generated $key"
  fi

  # 3. Agent + Keychain.
  ssh-add --apple-use-keychain "$key" 2>/dev/null || ssh-add "$key" 2>/dev/null || \
    warn "could not add $key to agent (is ssh-agent running?)"

  # 4. Show the public key to register on the matching account.
  info "Add this public key to the $profile GitHub account (https://github.com/settings/ssh/new):"
  cat "${key}.pub"
  command -v pbcopy >/dev/null && { pbcopy < "${key}.pub"; ok "copied to clipboard"; }
  info "Clone $profile repos with:  git clone git@$(host_alias "$profile"):OWNER/REPO.git"
  echo
}

main() {
  command -v git >/dev/null || { warn "git not found"; exit 1; }

  local -a profiles
  if [[ $# -gt 0 ]]; then
    profiles=("$@")
  else
    info "Usage: git_setup.sh [profile ...]   (default: personal)"
    info "Known profiles: ${ALL_PROFILES[*]}"
    profiles=(personal)
  fi

  eval "$(ssh-agent -s)" >/dev/null 2>&1 || true

  local p
  for p in "${profiles[@]}"; do
    setup_one "$p"
  done

  ok "Done. In any repo, confirm the active identity with:  git whoami"
}

main "$@"
