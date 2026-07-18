# Aliases & small functions — NEW names only. Standard commands (ls, cat,
# grep, find, du, df) are never shadowed: pasted snippets and agent-run
# commands must behave exactly as on any machine.

# --- Navigation ------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'

# --- eza views (ls itself stays untouched) ---------------------------------
alias ll='eza -la --icons --group-directories-first --git'  # long + hidden + git
alias lt='eza --tree --level=2 --icons'                     # tree, 2 levels

# --- TUIs ------------------------------------------------------------------
alias lg='lazygit'
alias lzd='lazydocker'

# --- Git (gst/gco/glog are not system commands, safe as new names) ---------
alias gst='git status -sb'
alias gco='git checkout'
alias glog="git log --graph --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gplr='git pull --rebase'

# --- Kubernetes ------------------------------------------------------------
alias k='kubectl'          # completions carry over via compdef below
compdef k=kubectl 2>/dev/null

# --- Config shortcuts ------------------------------------------------------
alias reload='exec zsh'                       # apply config edits
alias zshconfig='$EDITOR ~/.zshrc'
alias aliasconfig='$EDITOR ~/.config/zsh/aliases.zsh'

# --- Functions -------------------------------------------------------------
# mkdir + cd in one step
mkcd() { mkdir -p "$@" && cd "$_"; }

# kill whatever listens on a port:  kill_port 3000
kill_port() { lsof -ti:"$@" | xargs kill -9; }

# yazi file manager: exit with `q` and your shell cd's to where you browsed
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
