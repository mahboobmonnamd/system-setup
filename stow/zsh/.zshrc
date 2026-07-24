# ~/.zshrc — runs for every interactive shell. Read top to bottom.
# Layout:  brew -> exports -> history -> plugins -> completion -> keys ->
#          aliases -> fzf -> tool hooks -> prompt -> env.local

# --- Homebrew --------------------------------------------------------------
# Puts brew's tools on PATH and sets HOMEBREW_PREFIX. Must come first.
# Apple Silicon: /opt/homebrew — Intel: /usr/local
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Exports (EDITOR, colors, PATH: rustup / cargo / ~/.local/bin) ---------
source "$HOME/.config/zsh/exports.zsh"

# --- History (file-based; atuin adds the searchable DB on top) -------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history        # every terminal sees the same history live
setopt hist_ignore_space    # leading space = don't record (for sensitive cmds)
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt append_history

# --- Plugins (zinit) -------------------------------------------------------
source "$HOME/.config/zsh/plugins.zsh"

# --- Completion ------------------------------------------------------------
# compinit builds tab-completion. -C skips the audit check for faster startup.
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colored entries
zstyle ':completion:*' menu no                            # fzf-tab owns the menu

# kubectl completion, loaded lazily: the real `kubectl completion zsh` takes
# ~100ms, so we only pay that cost the first time kubectl is actually used.
kubectl() {
  unfunction kubectl
  source <(command kubectl completion zsh)
  command kubectl "$@"
}

# --- Keybindings (emacs + zle widgets) -------------------------------------
autoload -Uz edit-command-line
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e                       # emacs-style line editing (default-friendly)
WORDCHARS=''                     # word-jumps stop at / _ - . (path-friendly)

# Prefix-aware history: ↑/↓ (and Ctrl-P/N) only cycle commands that share
# the current line as a prefix. Empty line → full history. Atuin still owns Ctrl-R.
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search   # ↑
bindkey '^[[B' down-line-or-beginning-search # ↓
bindkey '^[OA' up-line-or-beginning-search   # ↑ (application cursor mode)
bindkey '^[OB' down-line-or-beginning-search # ↓ (application cursor mode)

bindkey '^[[1;3C' forward-word         # Option+Right
bindkey '^[[1;3D' backward-word        # Option+Left
bindkey '^[^?' backward-kill-word      # Option+Delete (ESC+DEL)
bindkey '^[\b' backward-kill-word      # Option+Delete (ESC+Backspace)
bindkey '^[[3;3~' kill-word            # Option+Fn+Delete (forward word)
bindkey '^X^E' edit-command-line       # Ctrl-X Ctrl-E → edit line in $EDITOR

# VSCode/Cursor terminal sends ^W for Ctrl+Backspace instead of ESC+DEL.
# Re-bind so it stops at word boundaries, not the whole line.
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  bindkey '^W' backward-kill-word
fi

# --- Aliases & functions ---------------------------------------------------
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

# --- fzf configuration (theme, previews, defaults) -------------------------
source "$HOME/.config/zsh/fzf.zsh"

# --- Tool hooks ------------------------------------------------------------
# Each prints shell code we eval. Order matters: atuin after fzf so atuin
# owns Ctrl-R (fzf keeps Ctrl-T files / Alt-C dirs). Up/Down stay prefix-aware
# because atuin is started with --disable-up-arrow.
eval "$(mise activate zsh)"                    # runtime versions (node/go/py)
eval "$(zoxide init zsh)"                      # `z <dir>` smart jumping
eval "$(direnv hook zsh)"                      # auto-load .envrc per project
eval "$(fzf --zsh)"                            # Ctrl-T, Alt-C, **<Tab>
eval "$(atuin init zsh --disable-up-arrow)"    # Ctrl-R history search
eval "$(starship init zsh)"                    # the prompt — keep last

# --- Machine-local overrides (gitignored — secrets live here) --------------
# Seeded by `make stow` from env.local.zsh.example if missing.
[[ -f "$HOME/.config/zsh/env.local.zsh" ]] && source "$HOME/.config/zsh/env.local.zsh"
