#!/usr/bin/env bash
# Oh My Zsh (non-interactive) + bat Catppuccin theme. Safe to re-run.
# shellcheck shell=bash

_ZSH_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$_ZSH_SH_DIR/lib.sh"

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    info "Oh My Zsh already present — skipping clone."
    return 0
  fi
  if [[ -n "${DRY_RUN:-}" ]]; then
    info "[dry-run] Would install Oh My Zsh (CHSH=no RUNZSH=no KEEP_ZSHRC=yes)"
    return 0
  fi
  info "Installing Oh My Zsh (non-interactive)..."
  export CHSH=no
  export RUNZSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh installed. ~/.zshrc is managed by stow."
}

install_bat_catppuccin_theme() {
  if [[ -n "${DRY_RUN:-}" ]]; then
    info "[dry-run] Would download Catppuccin Latte for bat and run bat cache --build"
    return 0
  fi
  if ! command -v bat &>/dev/null; then
    warn "bat not on PATH — skip Catppuccin bat theme (run brew bundle first)."
    return 0
  fi
  local theme_dir
  theme_dir="$(bat --config-dir)/themes"
  mkdir -p "$theme_dir"
  local dest="$theme_dir/Catppuccin Latte.tmTheme"
  local url="https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme"
  if command -v curl &>/dev/null; then
    curl -fsSL -o "$dest" "$url"
  else
    wget -q -O "$dest" "$url"
  fi
  bat cache --build
  success "bat Catppuccin Latte theme installed."
}

main_zsh() {
  require_darwin
  install_oh_my_zsh
  install_bat_catppuccin_theme
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main_zsh
fi
