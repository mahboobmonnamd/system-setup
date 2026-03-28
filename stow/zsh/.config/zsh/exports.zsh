#!/bin/zsh

export NVM_DIR="$HOME/.nvm"

_lazy_nvm_load() {
  unset -f nvm node npm npx _lazy_nvm_load
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
}

nvm() {
  _lazy_nvm_load
  nvm "$@"
}

node() {
  _lazy_nvm_load
  command node "$@"
}

npm() {
  _lazy_nvm_load
  command npm "$@"
}

npx() {
  _lazy_nvm_load
  command npx "$@"
}

export EDITOR=vim
export BAT_THEME="Catppuccin Latte"
export PATH="/Users/mahboob/.local/bin:$PATH"
# Added by Antigravity
export PATH="/Users/mahboob/.antigravity/antigravity/bin:$PATH"
