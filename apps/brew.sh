#! /usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.

source ./functions.sh

info "####### dotfiles #######"
brew update

# Upgrade any already-installed formulae.
brew upgrade

brew install git 
brew install iterm2
brew install stow
brew install zplug
brew install python
brew install neovim

# Remove outdated versions from the cellar.
brew cleanup

info '##### Installting oh my zsh#######'

./oh-my-zsh.sh
