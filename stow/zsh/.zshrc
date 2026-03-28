# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="bira"
plugins=(git kubectl z)

# Faster compinit cache location (avoids slow compaudit on some setups)
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-${SHORT_HOST:-$HOST}"

export ZPLUG_HOME=/opt/homebrew/opt/zplug

source "$ZSH/oh-my-zsh.sh"

source "$ZPLUG_HOME/init.zsh"
source "$HOME/.config/zsh/zplug.zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

. "$HOME/.local/bin/env"
