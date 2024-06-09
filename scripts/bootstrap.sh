#!/usr/bin/env bash

set +v -o errexit

script_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source ./functions.sh

install_xcode() {
	if xcode-select -p >/dev/null; then
		warn "xCode Command Line Tools already installed"
	else
		info "Installing xCode Command Line Tools..."
		xcode-select --install
		sudo xcodebuild -license accept
	fi
}

info "####### dotfiles #######"
read -p "Press enter to start:"
info "Bootstraping..."

    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until `.macos` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

install_xcode

$script_root/../apps/install.sh "$script_root/../apps/Brewfile" "$script_root/../apps/oh-my-zsh.sh"

./osx.sh

cd ../stow && ./stow.sh
