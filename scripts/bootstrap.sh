#!/usr/bin/env bash

set -o errexit

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

install_homebrew() {
	export HOMEBREW_CASK_OPTS="--appdir=/Applications"
	if hash brew &>/dev/null; then
		warn "Homebrew already installed"
	else
		info "Installing homebrew..."
		sudo --validate # reset `sudo` timeout to use Homebrew install in noninteractive mode
		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi
}

info "####### dotfiles #######"
read -p "Press enter to start:"
info "Bootstraping..."

./osx.sh

install_xcode
install_homebrew

cd ../apps && ./brew.sh
