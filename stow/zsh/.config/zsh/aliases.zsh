# Aliases & small functions — NEW names only. Standard commands (ls, cat,
# grep, find, du, df) are never shadowed: pasted snippets and agent-run
# commands must behave exactly as on any machine.

# --- Navigation ------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- eza views (ls itself stays untouched) ---------------------------------
alias ll='eza -la --icons --group-directories-first --git'  # long + hidden + git
alias la='eza -a --icons --group-directories-first'         # all, short
alias lt='eza --tree --level=2 --icons'                     # tree, 2 levels
alias lta='eza --tree --level=2 --icons -a'                 # tree + hidden

# --- Pretty printers (own names) -------------------------------------------
alias json='jq .'
alias yaml='yq .'

# --- TUIs ------------------------------------------------------------------
alias lg='lazygit'
alias lzd='lazydocker'

# --- tmux sessions (CLI; inside tmux use Ctrl-a T for sesh) ----------------
# Matches the session card from the terminal reference cheat sheet.
alias tn='tmux new -s'              # tn work          → new named session
alias ta='tmux attach -t'           # ta work          → attach by name
alias tl='tmux ls'                  # list sessions
alias tk='tmux kill-session -t'     # tk work          → kill by name
alias tksv='tmux kill-server'       # kill all sessions
alias tmuxconf='$EDITOR ~/.config/tmux/tmux.conf'

# --- Git (gst/gco/glog are not system commands, safe as new names) ---------
alias gst='git status -sb'
alias gco='git checkout'
alias glog="git log --graph --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gplr='git pull --rebase'
alias gprune='git remote prune origin'
alias gbr='git branch --sort=-committerdate'
alias gcontrib='git shortlog -sn'

# --- Kubernetes ------------------------------------------------------------
# `k` = kubecolor (colored kubectl wrapper, same args). Plain kubectl stays
# untouched for scripts/pasted commands.
alias k='kubecolor'
compdef kubecolor=kubectl 2>/dev/null
compdef k=kubectl 2>/dev/null

# --- Config shortcuts ------------------------------------------------------
alias reload='exec zsh'                       # apply config edits
alias zshconfig='$EDITOR ~/.zshrc'
alias aliasconfig='$EDITOR ~/.config/zsh/aliases.zsh'
alias envConfig='$EDITOR ~/.config/zsh/env.local.zsh'
# Extra git helpers (gco-fzf, gbd-fzf, gpr, gundo, gstats) live in functions.zsh
