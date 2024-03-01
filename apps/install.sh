#! /usr/bin/env bash


echo "####### dotfiles #######"

brew update
brew bundle -v
brew cleanup
brew doctor —verbose

sudo gem install colorls
colorls --light

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
nvm install --lts
npm i -g typescript ts-node

info '##### Installting oh my zsh#######'

chmod +x ./oh-my-zsh.sh

./oh-my-zsh.sh
