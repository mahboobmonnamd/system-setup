#!/bin/zsh

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/Developer/.go"

# export GOPATH=$HOME/Developer/.go
# export MAKEPATH="/opt/homebrew/Cellar/make/4.4.1/libexec/gnubin"
# # export PATH="$PATH:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$GOROOT/bin:$GOPATH/bin:$MAKEPATH"
# export PATH=$MAKEPATH:$GOPATH/bin:/opt/homebrew/opt/openjdk/bin:${KREW_ROOT:-$HOME/.krew}/bin:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# Specify default editor. Possible values: vim, nano, ed etc.
export EDITOR=vim



