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

# fzf-git: Ctrl-G then a second key opens an fzf picker for git objects —
#   Ctrl-G Ctrl-B branches   Ctrl-G Ctrl-H commit hashes   Ctrl-G Ctrl-T tags
#   Ctrl-G Ctrl-F changed files   Ctrl-G Ctrl-S stashes
# Pick one and it's inserted into your command line.
zinit ice pick"fzf-git.sh"
zinit light junegunn/fzf-git.sh

# Trainer: when you type a command that has an alias, prints a reminder
# (e.g. `git status -sb` -> "you-should-use: gst"). Helps the aliases stick.
zinit light MichaelAquilina/zsh-you-should-use

# Esc Esc — prepends sudo to the current (or previous) command
zinit snippet OMZP::sudo

# Syntax highlighting: valid commands turn green, unknown ones red, as you type.
# MUST be loaded last of the plugins (it hooks every keystroke).
zinit light zsh-users/zsh-syntax-highlighting
