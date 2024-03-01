#!/bin/bash

# Check if Oh My Zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
    exit 0
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Oh My Zsh has been successfully installed."
else
    echo "Failed to install Oh My Zsh."
    exit 1
fi
