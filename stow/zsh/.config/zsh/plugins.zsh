# Plugins, loaded by zinit. Each `zinit light <repo>` pulls a GitHub repo the
# first time (cached after that) and sources it.

# ${HOMEBREW_PREFIX:-/opt/homebrew}: use the var if set, else fall back to the
# standard Apple Silicon path — so this works even if brew's env wasn't loaded.
source "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zinit/zinit.zsh"

# Fish-style suggestions: as you type, the rest of a past command appears in
# grey. Press the right arrow (→) to accept it.
zinit light zsh-users/zsh-autosuggestions

# Extra completion definitions for many CLI tools.
zinit light zsh-users/zsh-completions

# fzf-tab: replaces the plain tab-completion menu with an fzf fuzzy picker.
zinit light Aloxaf/fzf-tab

# Syntax highlighting: valid commands turn green, unknown ones red, as you type.
# MUST be loaded last of the plugins (it hooks every keystroke).
zinit light zsh-users/zsh-syntax-highlighting
