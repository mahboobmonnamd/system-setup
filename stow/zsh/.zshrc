# ===============================================================================
# Powerlevel10k Instant Prompt
# ===============================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ===============================================================================
# Homebrew setup (macOS)
# ===============================================================================
# Initialize Homebrew environment and PATH
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ===============================================================================
# zInit Plugin Manager Setup
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
# syntax highlighting
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
# load only specific OMZ plugins as snippets
zinit snippet OMZL::git.zsh             # Git library functions
zinit snippet OMZP::git                 # Git aliases and functions
zinit snippet OMZP::sudo                # Press ESC twice to add sudo to command
zinit snippet OMZP::kubectl             # kubectl aliases and completions
zinit snippet OMZP::command-not-found   # suggests package to install for missing commands

# ===============================================================================
# Completion System
# ===============================================================================
# Load and initialize the completion system
autoload -Uz compinit && compinit

# Faster compinit cache location (avoids slow compaudit on some setups)
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-${SHORT_HOST:-$HOST}"

# Replay cached completions for faster loading
zinit cdreplay -q

# ===============================================================================
# Keybindings
# ===============================================================================
# Use Emacs-style keybindings (vs vi mode)
bindkey -e

bindkey '^p' history-search-backward # ctrl+P Previous command in history
bindkey '^n' history-search-forward  # ctrl+N Next command in history
bindkey '^w' kill-region             # Alt+W Kill/cut selected region

# ===============================================================================
# History Configuration
# ===============================================================================
HISTSIZE=5000               # Number of commands to keep in memory
HISTFILE=~/.zsh_history     # History file location
SAVEHIST=$HISTSIZE          # Number of commands to save to file
HISTDUP=erase               # Erase duplicates in history

# History options for better management
setopt appendhistory        # Append to history file, don't overwrite
setopt sharehistory         # Share history across all sessions
setopt hist_ignore_space    # Ignore commands starting with space
setopt hist_ignore_all_dups # Remove older duplicates entries from history
setopt hist_save_no_dups    # Don't save duplicate entries
setopt hist_ignore_dups     # Don't record duplicate consecutive entries
setopt hist_find_no_dups    # Don't display duplicates when searching

# ===============================================================================
# Completion Styling
# ===============================================================================
# case-insensitive completion matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# colorize completion list using LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Disable default completion menu (fzf-tab provides better interface)
zstyle ':completion:*' menu no

# fzf-tab preview configurations
# show directory contents when completing cd command
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# show directory contents when completing zoxide command
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ===============================================================================
# Custom configurations
# ===============================================================================
source $HOME/.config/zsh/aliases.plugin.zsh
source $HOME/.config/zsh/exports.zsh
source $HOME/.config/zsh/functions.zsh
source $HOME/.config/zsh/env.zsh

# ===============================================================================
# iterm2 shell integration
# ===============================================================================
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
