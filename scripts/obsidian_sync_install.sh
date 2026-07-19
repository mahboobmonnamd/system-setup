#!/usr/bin/env bash
# Install / uninstall the hourly Brain vault sync LaunchAgent.
#   ./scripts/obsidian_sync_install.sh          # install
#   ./scripts/obsidian_sync_install.sh uninstall
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SYNC="$ROOT/scripts/obsidian_vault_sync.sh"
LABEL="com.mahboob.obsidian-vault-sync"
PLIST="$HOME/Library/LaunchAgents/${LABEL}.plist"
UID_NUM="$(id -u)"

chmod +x "$SYNC"

uninstall() {
  if launchctl print "gui/${UID_NUM}/${LABEL}" >/dev/null 2>&1; then
    launchctl bootout "gui/${UID_NUM}/${LABEL}" 2>/dev/null || true
  fi
  rm -f "$PLIST"
  echo "uninstalled $LABEL"
}

install() {
  mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
  uninstall >/dev/null 2>&1 || true

  cat >"$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${SYNC}</string>
  </array>
  <key>StartInterval</key>
  <integer>3600</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>${HOME}/Library/Logs/obsidian-vault-sync.launchd.out.log</string>
  <key>StandardErrorPath</key>
  <string>${HOME}/Library/Logs/obsidian-vault-sync.launchd.err.log</string>
</dict>
</plist>
EOF

  launchctl bootstrap "gui/${UID_NUM}" "$PLIST"
  echo "installed $LABEL (hourly) → $SYNC"
  echo "manual run: make obsidian-sync"
  echo "logs: ~/Library/Logs/obsidian-vault-sync.log"
}

case "${1:-install}" in
  install) uninstall >/dev/null 2>&1 || true; install ;;
  uninstall) uninstall ;;
  *)
    echo "usage: $0 [install|uninstall]" >&2
    exit 1
    ;;
esac
