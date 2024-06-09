#!/bin/zsh

set -e

DOT_FOLDERS=("zsh" "nvim")

for folder in "${DOT_FOLDERS[@]}"; do
    echo "+ Folder :: $folder"
    stow -v -t $HOME $folder --ignore=".DS_Store" --adopt
done

echo "+ Reloading shell..."
exec $SHELL -l
