echo "loading Plugins"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:"2"
zplug "ohmyzsh/ohmyzsh", use:"plugins/git", defer:"2"

if ! zplug check; then
    zplug install
fi


# source
zplug "$HOME/.config/zsh/aliases.zsh", use:zsh
zplug "$HOME/.config/zsh/exports.zsh", use:zsh
zplug "$HOME/.config/zsh/functions.zsh", use:zsh, defer:"2"

zplug load