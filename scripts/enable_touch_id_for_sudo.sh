#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script is for macOS only." >&2
  exit 1
fi

sudo_local="/etc/pam.d/sudo_local"
touch_id_line="auth       sufficient     pam_tid.so"

if [[ ! -e "$sudo_local" ]]; then
  echo "This macOS install does not expose $sudo_local." >&2
  echo "Touch ID for sudo may require manual PAM configuration on this machine." >&2
  exit 1
fi

if sudo grep -Fqx "$touch_id_line" "$sudo_local" 2>/dev/null; then
  echo "Touch ID for sudo is already enabled in $sudo_local."
  exit 0
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

if sudo test -f "$sudo_local"; then
  sudo cat "$sudo_local" > "$tmp_file"
fi

printf '%s\n' "$touch_id_line" >> "$tmp_file"
sudo install -m 644 "$tmp_file" "$sudo_local"

echo "Enabled Touch ID for sudo via $sudo_local."
echo "Test with:"
echo "  sudo -k"
echo "  sudo true"
