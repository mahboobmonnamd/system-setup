# Shell functions — NEW names only (never shadow standard commands).

# mkdir + cd in one step
mkcd() { mkdir -p "$@" && cd "$_"; }

# kill whatever listens on a port:  kill_port 3000
kill_port() { lsof -ti:"$@" | xargs kill -9; }

# Edit machine-local env overrides (gitignored)
envconfig() {
  local f="${HOME}/.config/zsh/env.local.zsh"
  [[ -f $f ]] || printf '# Machine-local (gitignored)\n' >"$f"
  ${EDITOR:-nvim} "$f"
}

# Repo line-change stats
gstats() {
  echo "Repo statistics"
  echo "======================"
  git log --shortstat --pretty=format:"" |
    awk '/files? changed/ {
      files+=$1; inserted+=$4; deleted+=$6
    } END {
      print "Files changed: " files
      print "Lines added: " inserted
      print "Lines deleted: " deleted
    }'
}

# Interactive multi-branch delete (fzf)
gbd-fzf() {
  local branches
  branches="$(git branch | grep -v '^\*' | fzf --multi --preview 'git log --oneline --graph --color=always {1}')" || return
  [[ -n "$branches" ]] && echo "$branches" | xargs git branch -d
}

# Checkout branch with fzf (local + remotes)
gco-fzf() {
  local branch
  branch="$(
    git branch -a | grep -v '^\*' | sed 's|remotes/origin/||' | sort -u |
      fzf --preview 'git log --oneline --graph --color=always {1}'
  )" || return
  [[ -n "$branch" ]] && git checkout "$(echo "$branch" | sed 's/^[* ]*//')"
}

# Soft-undo last N commits (keep changes staged)
gundo() {
  local n=${1:-1}
  git reset --soft "HEAD~$n"
}

# Open a PR with gh (fills from commits/branch)
gpr() {
  if command -v gh >/dev/null 2>&1; then
    gh pr create --fill
  else
    echo "gh CLI not installed. Install with: brew install gh" >&2
    return 1
  fi
}

# yazi file manager: exit with `q` and your shell cd's to where you browsed
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# --- Obsidian Brain vault (override path in env.local.zsh) --------------------
: "${OBSIDIAN_VAULT:=$HOME/Documents/Brain}"

obs() {
  open -a Obsidian "$OBSIDIAN_VAULT"
}

ocd() {
  builtin cd -- "$OBSIDIAN_VAULT"
}

odaily() {
  local day note
  day="$(date +%Y-%m-%d)"
  note="$OBSIDIAN_VAULT/06-Daily/${day}.md"
  mkdir -p "$OBSIDIAN_VAULT/06-Daily"
  [[ -f $note ]] || printf '%s\n' "# ${day}" "" >"$note"
  open -a Obsidian "$note"
}

obsync() {
  local setup="${SYSTEM_SETUP:-$HOME/Developer/system-setup}"
  if [[ -x $setup/scripts/obsidian_vault_sync.sh ]]; then
    OBSIDIAN_VAULT="$OBSIDIAN_VAULT" bash "$setup/scripts/obsidian_vault_sync.sh"
  else
    echo "obsidian_vault_sync.sh not found at $setup/scripts/" >&2
    return 1
  fi
}
