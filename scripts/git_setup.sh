#!/usr/bin/env bash
# Bootstrap git identities (personal / work / freelance / oss).
#   ./scripts/git_setup.sh                    # personal only
#   ./scripts/git_setup.sh personal work      # several at once
#   ./scripts/git_setup.sh --all              # all four
#
# For each profile this, in order:
#   1. Generates an ed25519 SSH key (asks for a passphrase) if missing
#   2. Asks for your name + email, shows them back, and lets you confirm/redo
#   3. Writes ~/.config/git/identity-<profile>.gitconfig (gitignored)
#   4. Adds the key to ssh-agent + Keychain and prints the public key
#
# Safe to re-run: it detects existing values and lets you keep or change them.
# Nothing is skipped silently — the old "file exists so I'll jump to the
# passphrase" behavior is gone.

set -uo pipefail   # NOTE: no -e — we handle errors ourselves so a mistyped
                   # answer re-prompts instead of killing the whole script.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATES="$REPO_ROOT/stow/git/.config/git"
LIVE_DIR="$HOME/.config/git"
ALL_PROFILES=(personal work freelance oss)

info() { printf '\n\033[34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[33m!\033[0m %s\n' "$*" >&2; }

host_alias() { case "$1" in personal) echo "github.com";; *) echo "github.com-$1";; esac; }

# Read a required, non-empty value. $1 = prompt, $2 = current value (may be
# empty/placeholder). Pressing Enter keeps the current value if one exists.
ask() {
  local prompt="$1" current="$2" reply
  while true; do
    if [[ -n "$current" && "$current" != "Your Name" && "$current" != *".example" ]]; then
      printf '%s [%s]: ' "$prompt" "$current" >&2
      IFS= read -r reply
      reply="${reply:-$current}"
    else
      printf '%s: ' "$prompt" >&2
      IFS= read -r reply
    fi
    [[ -n "$reply" ]] && { printf '%s' "$reply"; return 0; }
    warn "cannot be empty — try again"
  done
}

setup_one() {
  local profile="$1"
  local key="$HOME/.ssh/id_ed25519_${profile}"
  local identity="$LIVE_DIR/identity-${profile}.gitconfig"
  local template="$TEMPLATES/identity-${profile}.gitconfig.example"

  info "Profile: $profile"

  # 1. SSH key first, so the passphrase prompt is clearly its own step.
  if [[ -f "$key" ]]; then
    ok "ssh key exists: $key (keeping it)"
  else
    info "Generating SSH key (you'll be asked for a passphrase — can be blank):"
    if ! ssh-keygen -t ed25519 -C "${profile}@$(hostname -s)" -f "$key"; then
      warn "key generation failed/cancelled for $profile — skipping this profile"
      return 1
    fi
    ok "generated $key"
  fi

  # 2. Name + email, with confirmation loop.
  local cur_name="" cur_email=""
  if [[ -f "$identity" ]]; then
    cur_name="$(git config -f "$identity" user.name 2>/dev/null || true)"
    cur_email="$(git config -f "$identity" user.email 2>/dev/null || true)"
  fi
  local name email
  while true; do
    name="$(ask "Name for $profile"  "$cur_name")"
    email="$(ask "Email for $profile" "$cur_email")"
    printf '\n  name:  %s\n  email: %s\n' "$name" "$email" >&2
    printf 'Correct? [Y/n] ' >&2; local yn; IFS= read -r yn
    [[ -z "$yn" || "$yn" == [Yy]* ]] && break
    cur_name="$name"; cur_email="$email"   # keep as editable defaults, retry
  done

  # 3. Write the identity file (from the tracked template, then fill in).
  mkdir -p "$LIVE_DIR"
  [[ -f "$identity" ]] || { [[ -f "$template" ]] && cp "$template" "$identity"; }
  git config -f "$identity" user.name  "$name"
  git config -f "$identity" user.email "$email"
  git config -f "$identity" user.signingkey "$key.pub"
  git config -f "$identity" core.sshCommand "ssh -i $key -o IdentitiesOnly=yes"
  git config -f "$identity" commit.gpgsign true
  git config -f "$identity" tag.gpgsign true
  ok "wrote $identity"

  # 3b. allowed_signers: lets `git log --show-signature` verify locally.
  local signers="$LIVE_DIR/allowed_signers"
  touch "$signers"
  if ! grep -qF "$(command cat "${key}.pub")" "$signers" 2>/dev/null; then
    printf '%s %s\n' "$email" "$(command cat "${key}.pub")" >> "$signers"
    ok "registered key in allowed_signers"
  fi

  # 4. Agent + Keychain, then show the public key to register on GitHub.
  ssh-add --apple-use-keychain "$key" 2>/dev/null || warn "couldn't add $key to agent"
  info "On GitHub ($profile account) add this public key TWICE at"
  info "https://github.com/settings/ssh/new — once as an 'Authentication Key'"
  info "and once as a 'Signing Key' (so commits show Verified):"
  cat "${key}.pub"
  command -v pbcopy >/dev/null && { pbcopy < "${key}.pub"; ok "copied to clipboard"; }
  info "Clone $profile repos with:  git clone git@$(host_alias "$profile"):OWNER/REPO.git"
}

main() {
  local -a profiles
  if [[ "${1:-}" == "--all" ]]; then profiles=("${ALL_PROFILES[@]}")
  elif [[ $# -gt 0 ]]; then profiles=("$@")
  else profiles=(personal); fi

  eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
  local p
  for p in "${profiles[@]}"; do setup_one "$p"; done
  echo
  ok "Done. In any repo, confirm the active identity with:  git whoami"
}

main "$@"
