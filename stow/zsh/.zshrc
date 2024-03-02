# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bira"

export ZPLUG_HOME=/opt/homebrew/opt/zplug

source $ZSH/oh-my-zsh.sh

source $ZPLUG_HOME/init.zsh
source $HOME/.config/zsh/zplug.zsh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

