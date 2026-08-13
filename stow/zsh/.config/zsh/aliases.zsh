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
# Classic shell multiplexer. Agent-first work prefers Herdr (below).
alias tn='tmux new -s'              # tn work          → new named session
alias ta='tmux attach -t'           # ta work          → attach by name
alias tl='tmux ls'                  # list sessions
alias tk='tmux kill-session -t'     # tk work          → kill by name
alias tksv='tmux kill-server'       # kill all sessions
alias tmuxconf='$EDITOR ~/.config/tmux/tmux.conf'

# --- Herdr (agent multiplexer; inside Herdr use Ctrl-a like tmux) ----------
alias hr='herdr'                    # attach / launch Herdr
alias hrs='herdr server'            # server subcommands
alias hrr='herdr server reload-config'  # after editing ~/.config/herdr/config.toml
alias herdrconf='$EDITOR ~/.config/herdr/config.toml'
alias cmuxconf='$EDITOR ~/.config/cmux/cmux.json'

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

# Config / context (who am I talking to?)
alias kcc='k config current-context'                         # current context name
alias kgctx='k config get-contexts'                          # list contexts
alias kuc='k config use-context'                             # kuc my-cluster
alias kns='k config set-context --current --namespace'       # kns default
alias kgns='k config view --minify -o jsonpath="{..namespace}"'  # current ns
alias kgc='k config view --minify'                           # active kubeconfig slice

# Common get / describe / logs / apply
alias kg='k get'
alias kgp='k get pods'
alias kgpa='k get pods -A'
alias kgs='k get svc'
alias kgd='k get deploy'
alias kgn='k get nodes'
alias kd='k describe'
alias kdp='k describe pod'
alias kl='k logs'
alias klf='k logs -f'
alias kaf='k apply -f'
alias kdel='k delete'
alias kex='k exec -it'

# --- Config shortcuts ------------------------------------------------------
alias reload='exec zsh'                       # apply config edits
alias zshconfig='$EDITOR ~/.zshrc'
alias aliasconfig='$EDITOR ~/.config/zsh/aliases.zsh'
alias envConfig='$EDITOR ~/.config/zsh/env.local.zsh'
# Extra git helpers (gco-fzf, gbd-fzf, gpr, gundo, gstats) live in functions.zsh
