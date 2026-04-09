# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

function envconfig() {
  local f="${HOME}/.config/zsh/env.local.zsh"
  [[ -f $f ]] || print '# Machine-local (gitignored)\n' >"$f"
  code "$f"
}

function kill_port() { lsof -ti:"$@" | xargs kill -9 }

# Github util functions
function gstats() {
  echo "Repo statistics"
  echo "======================"
  git log --shortstat --pretty=format:"" | \
    awk '/files? changed/ {
      files+=$1
      inserted+=$4
      deleted+=$6
    } END {
      print "Files changed: " files
      print "Lines added: " inserted
      print "Lines deleted: " deleted
    }'
}

# Interactive branch delete (with fzf)
function gbd-fzf() {
    local branches=$(git branch | grep -v "^\*" | fzf --multi --preview 'git log --oneline --graph --color=always {}')
    if [ -n "$branches" ]; then
        echo "$branches" | xargs git branch -d
    fi
}

# Checkout branch with fzf
function gco-fzf() {
    local branch=$(git branch -a | grep -v "^\*" | sed 's/remotes\/origin\///' | sort -u | fzf --preview 'git log --oneline --graph --color=always {}')
    if [ -n "$branch" ]; then
        git checkout $(echo "$branch" | sed 's/^[* ]*//')
    fi
}

# Show files changed in last commit
function glast() {
    git diff-tree --no-commit-id --name-only -r HEAD
}

# Create PR with gh (if available)
function gpr() {
 if command -v gh >/dev/null 2>&1; then
      gh pr create --fill
  else
      echo "gh CLI not installed. Install with: brew install gh"
  fi
}

# undo last N commits
function gundo() {
  local n=${1:-1}
  git reset --soft HEAD~$n
}

# eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
