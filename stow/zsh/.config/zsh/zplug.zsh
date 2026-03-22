# Extra plugins only (git/kubectl/z come from Oh My Zsh — avoids cloning OMZ twice via zplug)
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2

source "$HOME/.config/zsh/aliases.plugin.zsh"
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/functions.zsh"
source "$HOME/.config/zsh/env.zsh"

if ! zplug check; then
  zplug install
fi

zplug load
