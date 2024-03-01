#! /usr/bin/env bash


echo "####### dotfiles #######"

brew update
brew bundle -v
brew cleanup
brew doctor —verbose

sudo gem install colorls
colorls --light

nvm install --lts
npm i -g typescript ts-node

info '##### Installting oh my zsh#######'

./oh-my-zsh.sh
