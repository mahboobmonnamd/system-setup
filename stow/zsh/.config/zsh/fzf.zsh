#!/bin/zsh

# Load fzf keybindings/completions installed by Homebrew so Ctrl-T / Alt-C work.
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
  [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
fi

# ===============================================================================
# FZF-Tab Multi-Select Configuration
# ===============================================================================
# Improved keybindings for multi-select without breaking space in search
# - Ctrl-Space: Toggle selection (allows typing spaces in search)
# - TAB: Move down (navigation only)
# - Shift-TAB: Move up (navigation only)
# - Ctrl-A: Select all items
# - Ctrl-D: Deselect all items
# - Arrow keys / Ctrl-J/K: Navigate up/down

# Enable multi-select for ALL fzf-tab completions
zstyle ':fzf-tab:*' fzf-flags --multi --bind='ctrl-space:toggle,tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-j:down,ctrl-k:up'

# Specific multi-select for kill command (processes)
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags --multi --bind='ctrl-space:toggle,tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all'

# Multi-select for git branch operations
zstyle ':fzf-tab:complete:git-checkout:*' fzf-flags --multi --bind='ctrl-space:toggle,tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all'
zstyle ':fzf-tab:complete:git-branch:*' fzf-flags --multi --bind='ctrl-space:toggle,tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all'

# Multi-select for docker operations
zstyle ':fzf-tab:complete:docker-stop:*' fzf-flags --multi --bind='ctrl-space:toggle,tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all'
zstyle ':fzf-tab:complete:docker-rm:*' fzf-flags --multi --bind='ctrl-space:toggle,tab:down,shift-tab:up,ctrl-a:select-all,ctrl-d:deselect-all'

# ===============================================================================
# FZF-Tab Preview Configurations
# ===============================================================================
# Show directory contents when completing cd command
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Show directory contents when completing zoxide command
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# ===============================================================================
# FZF Configuration - Multi-Select & Enhanced Features
# ===============================================================================
# Enable multi-select mode by default for all fzf operations
# Improved keybindings for better UX:
#   - SPACE: Toggle selection (without moving cursor)
#   - TAB: Move down (navigation only)
#   - Shift-TAB: Move up (navigation only)
#   - Ctrl-A: Select all items
#   - Ctrl-D: Deselect all items
#   - Ctrl-/: Toggle preview window
#   - Ctrl-J/K: Navigate down/up (vim-style)
#   - Arrow keys: Navigate up/down
#   - Enter: Confirm selection(s)
export FZF_DEFAULT_OPTS="
  --multi
  --height=50%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
  --bind 'ctrl-space:toggle'
  --bind 'tab:down'
  --bind 'shift-tab:up'
  --bind 'ctrl-a:select-all'
  --bind 'ctrl-d:deselect-all'
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-j:down'
  --bind 'ctrl-k:up'
  --bind 'ctrl-u:preview-half-page-up'
  --bind 'ctrl-f:preview-half-page-down'
  --color=fg:#4c4f69,bg:#eff1f5,hl:#1e66f5
  --color=fg+:#4c4f69,bg+:#ccd0da,hl+:#1e66f5
  --color=info:#179299,prompt:#d20f39,pointer:#df8e1d
  --color=marker:#40a02b,spinner:#df8e1d,header:#1e66f5
"

# FZF completion trigger (default is '**')
export FZF_COMPLETION_TRIGGER='**'

# FZF command for file/directory search (respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# FZF command for Ctrl-T (file search)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  --preview-window=right:60%:wrap
"

# FZF command for Alt-C (directory search)
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always {}'
  --preview-window=right:60%
"
