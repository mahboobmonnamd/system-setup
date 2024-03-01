#! /usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.

source ./functions.sh

info "####### dotfiles #######"
brew update

# Upgrade any already-installed formulae.
brew upgrade

# dev tools
brew install --cask android-studio
brew install --cask visual-studio-code

# Remove outdated versions from the cellar.
brew cleanup
