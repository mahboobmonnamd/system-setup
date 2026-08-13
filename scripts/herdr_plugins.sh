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

# Ctrl-a q → on-pane 1–9 badges (tmux display-panes twin). Local plugin
# stowed at ~/.config/herdr/plugins/pane-numbers. Needs kitty_graphics.
# Replace the old letter-hint picker if it was installed earlier.
herdr plugin uninstall ugurtarlig.pane-picker --yes >/dev/null 2>&1 || true
herdr plugin unlink ugurtarlig.pane-picker >/dev/null 2>&1 || true
herdr plugin unlink system-setup.pane-numbers >/dev/null 2>&1 || true
PANE_NUMBERS="${HOME}/.config/herdr/plugins/pane-numbers"
if [[ ! -f "${PANE_NUMBERS}/herdr-plugin.toml" ]]; then
  echo "herdr pane-numbers plugin missing — run: make stow" >&2
  exit 1
fi
herdr plugin link "${PANE_NUMBERS}" --yes 2>/dev/null || herdr plugin link "${PANE_NUMBERS}"

echo "Herdr plugins installed. Reload keys with: hrr   (or Ctrl-a r inside Herdr)"
echo "If pane-number badges are blank: Ctrl-a d, then hr  (relaunch client for kitty graphics)"
