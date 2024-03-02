zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "ohmyzsh/ohmyzsh", use:"plugins/git", defer:2
zplug "ohmyzsh/ohmyzsh", use:"plugins/kubectl", defer:2
# source
# zplug "$HOME/.config/zsh/aliases.plugin.zsh", from:local, as:plugin, use:"zsh/*.zsh", defer:2
# zplug "$HOME/.config/zsh/exports.zsh", from:local, as:plugin, use:"zsh/*.zsh", defer:2
# zplug "$HOME/.config/zsh/functions.zsh", from:local, as:plugin, use:"zsh/*.zsh", defer:2

source "$HOME/.config/zsh/aliases.plugin.zsh"
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/functions.zsh"

if ! zplug check; then
    zplug install
fi

zplug load

