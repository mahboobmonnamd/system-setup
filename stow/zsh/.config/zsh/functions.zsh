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

# Fuzzy tmux session picker from the shell (sesh + fzf).
# Inside tmux, prefer Ctrl-a T — same picker, popup layout.
tm() {
  if ! command -v sesh >/dev/null 2>&1; then
    echo "sesh not installed — brew install sesh (or make brew)" >&2
    return 1
  fi
  local session
  session="$(
    sesh list --icons | fzf --ansi \
      --no-sort --prompt='⚡ ' \
      --header '  ^a all  ^t tmux  ^x zoxide  ^d kill' \
      --bind 'ctrl-a:change-prompt(⚡ )+reload(sesh list --icons)' \
      --bind 'ctrl-t:change-prompt(🪟 )+reload(sesh list -t --icons)' \
      --bind 'ctrl-x:change-prompt(📁 )+reload(sesh list -z --icons)' \
      --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)' \
      --preview 'sesh preview {}' \
      --preview-window 'right:55%'
  )" || return
  [[ -n "$session" ]] && sesh connect "$session"
}

# Herdr attach with optional session picker (tmux `tm` twin).
#   hr                 → attach default, or fzf-pick when multiple sessions exist
#   hr --session work  → pass through to herdr (any args)
#   hn work / ha work  → create-or-attach / attach by name (aliases)
hr() {
  if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr not installed — brew install herdr (or make brew)" >&2
    return 1
  fi

  # Any args → normal herdr CLI (flags, --session, --remote, …).
  if (( $# > 0 )); then
    command herdr "$@"
    return $?
  fi

  local json rows count selected name
  json="$(command herdr session list --json 2>/dev/null)" || {
    command herdr
    return $?
  }

  if command -v jq >/dev/null 2>&1; then
    rows="$(
      printf '%s\n' "$json" | jq -r '
        .sessions
        | sort_by((.running | not), .name)
        | .[]
        | [
            .name,
            (if .running then "running" else "stopped" end),
            (if .default then "*" else "" end)
          ]
        | @tsv
      '
    )"
  else
    # No jq: fall back to default attach (hl still lists sessions).
    command herdr
    return $?
  fi

  count="$(printf '%s\n' "$rows" | awk 'NF {n++} END {print n+0}')"
  if (( count <= 1 )); then
    command herdr
    return $?
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    echo "Multiple Herdr sessions — install fzf, or: ha <name> / hl" >&2
    command herdr session list
    return 1
  fi

  selected="$(
    printf '%s\n' "$rows" | fzf --delimiter=$'\t' --with-nth=1,2,3 \
      --nth=1 \
      --prompt='herdr ❯ ' \
      --header 'enter attach · ctrl-d stop · esc cancel' \
      --bind 'ctrl-d:execute-silent(herdr session stop {1})+reload(herdr session list --json | jq -r ".sessions | sort_by((.running | not), .name) | .[] | [.name, (if .running then \"running\" else \"stopped\" end), (if .default then \"*\" else \"\" end)] | @tsv")'
  )" || return

  name="${selected%%$'\t'*}"
  [[ -z "$name" ]] && return 1
  if [[ "$name" == "default" ]]; then
    command herdr
  else
    command herdr --session "$name"
  fi
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
