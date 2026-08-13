#!/usr/bin/env bash
# Install Herdr plugins required by stow/herdr (idempotent).
# Usage: make herdr-plugins   or   ./scripts/herdr_plugins.sh
set -euo pipefail

if ! command -v herdr >/dev/null 2>&1; then
  echo "herdr not on PATH — run: make brew   (or brew install herdr)" >&2
  exit 1
fi

# Seamless Ctrl-h/j/k/l across Herdr panes + Vim/Neovim (tmux twin of
# christoomey/vim-tmux-navigator). Bound in stow/herdr/.../config.toml.
herdr plugin install paulbkim-dev/vim-herdr-navigation --yes

# On-pane a/s/d/f hints → focus (tmux display-panes twin). Needs
# [experimental] kitty_graphics = true (already in our config.toml).
# Pin a reviewed release; after first install, detach + reattach Herdr once
# so the client picks up pixel geometry for the badges.
herdr plugin install ugurtarlig/herdr-pane-picker --ref v0.1.1 --yes

echo "Herdr plugins installed. Reload keys with: hrr   (or Ctrl-a r inside Herdr)"
echo "If pane-picker badges are blank: Ctrl-a d, then hr  (relaunch client for kitty graphics)"
