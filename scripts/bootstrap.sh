#!/usr/bin/env bash
# One command from a fresh Mac to the full setup:
#   git clone <repo> ~/Developer/system-setup && cd ~/Developer/system-setup
#   ./scripts/bootstrap.sh              # personal machine
#   PROFILE=work ./scripts/bootstrap.sh # work machine
#
# Idempotent — safe to rerun anytime; it only installs what's missing.

set -euo pipefail
PROFILE="${PROFILE:-personal}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() { printf '\n\033[34m==>\033[0m %s\n' "$*"; }

[[ "$(uname -s)" == "Darwin" ]] || {
  echo "This setup targets macOS only (Darwin). Refusing to run on $(uname -s)." >&2
  exit 1
}

ensure_brew_shellenv() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return
  fi
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then
      eval "$("$candidate" shellenv)"
      return
    fi
  done
  return 1
}

info "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Finish the CLT install dialog, then rerun this script."; exit 1
fi

info "Homebrew"
if ! ensure_brew_shellenv; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ensure_brew_shellenv || {
    echo "Homebrew installed but brew is not on PATH. Open a new terminal and rerun." >&2
    exit 1
  }
fi
BREW_PREFIX="$(brew --prefix)"

info "Packages (base + $PROFILE)"
make -C "$REPO_ROOT" brew PROFILE="$PROFILE"

info "Dotfiles"
make -C "$REPO_ROOT" stow
# SSH Include ~/.ssh/config.local — create empty file so missing Include never fails
# on older OpenSSH; put machine-local hosts here (gitignored in the stow tree).
[[ -f "$HOME/.ssh/config.local" ]] || touch "$HOME/.ssh/config.local"

info "Language runtimes"
mise use -g node@lts go@latest
rustup show active-toolchain 2>/dev/null | grep -q stable || rustup default stable

info "Docker CLI plugins (compose/buildx) via brew"
mkdir -p "$HOME/.docker"
DOCKER_PLUGINS="$BREW_PREFIX/lib/docker/cli-plugins"
if [[ -f "$HOME/.docker/config.json" ]]; then
  jq --arg dir "$DOCKER_PLUGINS" '.cliPluginsExtraDirs = [$dir]' \
    "$HOME/.docker/config.json" > "$HOME/.docker/config.json.tmp" \
    && mv "$HOME/.docker/config.json.tmp" "$HOME/.docker/config.json"
else
  printf '{\n  "cliPluginsExtraDirs": ["%s"]\n}\n' "$DOCKER_PLUGINS" \
    > "$HOME/.docker/config.json"
fi

info "Neovim plugins (headless first run)"
nvim --headless "+Lazy! sync" +qa || true

info "Shell history import into atuin"
atuin import auto || true

cat <<'EOF'

Done. Remaining (interactive, run yourself):
  ./scripts/git_setup.sh --all           # ssh keys + git identities (or list profiles)
  make macos                             # macOS defaults (log out/in after)
  make touchid                           # Touch ID for sudo
  colima start                           # when you first need docker
  gh auth login                          # then optionally: gh extension install dlvhdr/gh-dash
Open Ghostty — everything is themed and ready.
EOF
