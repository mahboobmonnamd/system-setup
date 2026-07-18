# fzf configuration — Catppuccin Mocha colors, fd-powered search, previews.

# Default input: fd (fast, respects .gitignore, includes hidden files)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Look & feel: Catppuccin Latte (light) palette + rounded border.
# Ctrl-/ toggles the preview pane in any fzf window.
export FZF_DEFAULT_OPTS="
  --height=60% --layout=reverse --border=rounded --info=inline
  --prompt='❯ ' --pointer='▶' --marker='✓'
  --bind 'ctrl-/:toggle-preview'
  --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39
  --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78
  --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39
"

# Ctrl-T (insert file path): preview the file with bat
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:300 {}'
  --preview-window=right:55%:wrap
"

# Alt-C (cd to directory): preview the tree with eza
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --level=2 --color=always --icons {}'
  --preview-window=right:50%
"

# fzf-tab: use the same look for tab completion; preview dirs when cd-ing
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons $realpath'
