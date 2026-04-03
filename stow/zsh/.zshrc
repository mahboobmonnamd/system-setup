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
# Plugins (zinit, themes, zsh plugins, OMZ snippets)
# ===============================================================================
source $HOME/.config/zsh/plugins.zsh

# ===============================================================================
# Completion System
# ===============================================================================
# Load and initialize the completion system
autoload -Uz compinit && compinit

# ===============================================================================
# Replay cached completions for faster loading
# ===============================================================================
zinit cdreplay -q

# Faster compinit cache location (avoids slow compaudit on some setups)
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-${SHORT_HOST:-$HOST}"

# ===============================================================================
# Keybindings
# ===============================================================================
# Use Emacs-style keybindings (vs vi mode)
bindkey -e

bindkey '^p' history-search-backward   # ctrl+P Previous command in history
bindkey '^n' history-search-forward    # ctrl+N Next command in history
bindkey '^w' kill-region               # Alt+W Kill/cut selected region
bindkey '^[[A' history-search-backward # ↑ Previous command in history
bindkey '^[[B' history-search-forward  # ↓ Next command in history

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

# ===============================================================================
# Load FZF-tab config (muli-select previews keybindings)
# ===============================================================================
source $HOME/.config/zsh/fzf.zsh

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
