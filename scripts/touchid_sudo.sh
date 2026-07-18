#!/usr/bin/env bash
# Enable Touch ID for `sudo` in the terminal (no more typing your password).
# RUN THIS YOURSELF:  make touchid   (asks for your password once, via sudo)
#
# Uses /etc/pam.d/sudo_local — Apple's supported mechanism (macOS 13+) that
# SURVIVES OS updates (editing /etc/pam.d/sudo directly gets reset).

set -euo pipefail
if [[ -f /etc/pam.d/sudo_local ]] && grep -q '^auth.*pam_tid.so' /etc/pam.d/sudo_local; then
  echo "Touch ID for sudo is already enabled."
  exit 0
fi
sudo sh -c 'sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template > /etc/pam.d/sudo_local'
echo "Enabled. Test with:  sudo -k && sudo echo it-works   (should prompt Touch ID)"
