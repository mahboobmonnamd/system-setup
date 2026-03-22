#!/usr/bin/env bash

set -euo pipefail

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "Oh My Zsh is already installed."
  exit 0
fi

echo "Installing Oh My Zsh (non-interactive)..."
export CHSH=no
export RUNZSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Oh My Zsh installed. Your ~/.zshrc is managed by stow; open a new shell after stow."
