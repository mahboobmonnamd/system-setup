# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

envconfig() {
  local f="${HOME}/.config/zsh/env.local.zsh"
  [[ -f $f ]] || print '# Machine-local (gitignored)\n' >"$f"
  code "$f"
}

eval "$(zoxide init zsh)"
