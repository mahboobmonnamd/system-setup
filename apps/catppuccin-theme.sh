#!/bin/bash

mkdir -p "$(bat --config-dir)/themes"

wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$HOME/.warp/themes" https://raw.githubusercontent.com/catppuccin/warp/main/themes/catppuccin_latte.yml

bat cache --build
