#!/usr/bin/env bash
# Idempotent commit + push for the Obsidian Brain vault.
# Safe to run from LaunchAgent or: make obsidian-sync
set -euo pipefail

VAULT="${OBSIDIAN_VAULT:-$HOME/Documents/Brain}"
LOG="${OBSIDIAN_VAULT_SYNC_LOG:-$HOME/Library/Logs/obsidian-vault-sync.log}"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

log() {
  mkdir -p "$(dirname "$LOG")"
  printf '%s %s\n' "$TS" "$*" | tee -a "$LOG"
}

if [[ ! -d "$VAULT/.git" ]]; then
  log "skip: not a git repo: $VAULT"
  exit 0
fi

cd "$VAULT"

if ! git remote get-url origin >/dev/null 2>&1; then
  log "skip: no origin remote in $VAULT"
  exit 0
fi

# Avoid clobbering a mid-rebase / merge state
if [[ -d .git/rebase-merge || -d .git/rebase-apply || -f .git/MERGE_HEAD ]]; then
  log "skip: rebase/merge in progress"
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  log "ok: nothing to commit"
  exit 0
fi

git commit -m "vault sync: $TS"
if git push; then
  log "ok: pushed $(git rev-parse --short HEAD)"
else
  log "error: push failed"
  exit 1
fi
