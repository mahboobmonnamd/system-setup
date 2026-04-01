#!/bin/zsh

# ===============================================================================
# Zinit Plugin Manager
# ===============================================================================
# zInit is faster and auto-installs on first run and supports turbo mode for lazy loading
source $HOMEBREW_PREFIX/opt/zinit/zinit.zsh

# ===============================================================================
# Theme: Powerlevel10k
# ===============================================================================
zinit ice depth=1; zinit light romkatv/powerlevel10k

# ===============================================================================
# Essential zsh plugins
# ===============================================================================
# Syntax highlighting - must be loaded after compinit
zinit light zsh-users/zsh-syntax-highlighting

# Auto completions
zinit light zsh-users/zsh-completions

# Auto suggestions
zinit light zsh-users/zsh-autosuggestions

# fzf-tab: Replaces default tab completion with fzf finder
zinit light Aloxaf/fzf-tab

# ===============================================================================
# Oh My ZSH Snippets
# ===============================================================================
# Load only specific OMZ plugins as snippets
zinit snippet OMZL::git.zsh             # Git library functions
zinit snippet OMZP::git                 # Git aliases and functions
zinit snippet OMZP::sudo                # Press ESC twice to add sudo to command
zinit snippet OMZP::kubectl             # kubectl aliases and completions
zinit snippet OMZP::command-not-found   # Suggests package to install for missing commands
