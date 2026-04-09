#!/bin/zsh

# ===============================================================================
# Navigation Aliases
# ===============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ===============================================================================
# Enhanced ls with eza
# ===============================================================================
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -la --group-directories-first --icons=auto'
  alias la='eza -a --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'
  alias lta='eza --tree --level=2 --icons=auto -a'
else
  alias ls='ls -G'
  alias ll='ls -la'
  alias la='ls -a'
fi

# ===============================================================================
# Configuration Shortcuts
# ===============================================================================
alias json='jq .'
alias yaml='yq .'
alias lzd='lazydocker'

# ===============================================================================
# Enhanced cat with bat
# ===============================================================================
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=auto'
  alias catt='bat --style=plain'  # cat without decorations
fi

# ===============================================================================
# Enhanced grep with ripgrep
# ===============================================================================
if command -v rg >/dev/null 2>&1; then
  alias grep='rg'
else
  alias grep='grep --color=auto'
fi

# ===============================================================================
# Enhanced find with fd
# ===============================================================================
if command -v fd >/dev/null 2>&1; then
  alias find='fd'
fi

# ===============================================================================
# Git Aliases
# ===============================================================================
if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

# additional unique aliases with OMZ git plugin
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
alias gplr='git pull --rebase'
alias gprune='git remote prune origin'
alias gbr='git branch --sort=-committerdate'
alias gcontrib='git shortlog -sn'             # show contributors

# ===============================================================================
# System Utilities
# ===============================================================================
alias df='df -h'
alias du='du -h'

# ===============================================================================
# thefuck - command correction
# ===============================================================================
if command -v thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
  eval $(thefuck --alias fk)  # shorter alias
fi

# ===============================================================================
# Configuration Shortcuts
# ===============================================================================
alias zshconfig="code ~/.zshrc"
alias aliasconfig="code ~/.config/zsh/aliases.plugin.zsh"
