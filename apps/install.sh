#!/usr/bin/env bash

set -euo pipefail

echo "####### Installing brew and other scripts #######"

brewfile="${1:-./Brewfile}"
omzfile="${2:-./oh-my-zsh.sh}"
batfile="${3:-./catppuccin-theme.sh}"

if [[ ! -f "$brewfile" ]]; then
  echo "Brewfile not found: $brewfile"
  exit 1
fi

if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  sudo --validate
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  {
    echo
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  } >>"$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing applications from $brewfile..."
brew bundle --file="$brewfile"

if command -v pyenv &>/dev/null; then
  pyenv install -s 3.9
fi

if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  # shellcheck source=/dev/null
  . "/opt/homebrew/opt/nvm/nvm.sh"
  nvm install --lts --default
  npm i -g typescript ts-node
fi

chmod +x "$omzfile"
"$omzfile"

chmod +x "$batfile"
"$batfile"

echo "Installation completed."
