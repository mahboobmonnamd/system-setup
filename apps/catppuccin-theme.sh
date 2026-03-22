#!/usr/bin/env bash

set -euo pipefail

mkdir -p "$(bat --config-dir)/themes"

wget -q -O "$(bat --config-dir)/themes/Catppuccin Latte.tmTheme" \
  "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme"

bat cache --build
