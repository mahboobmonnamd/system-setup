# ~/.zshrc — runs for every interactive shell. Read top to bottom.
# Layout:  plugins -> completion -> aliases -> fzf -> tool hooks -> prompt

# --- Homebrew --------------------------------------------------------------
# Puts brew's tools on PATH and sets HOMEBREW_PREFIX. Must come first.
# Apple Silicon: /opt/homebrew — Intel: /usr/local
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Basics ----------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
# bat: built-in light theme (matches the Latte terminal background)
export BAT_THEME="GitHub"
# Rust: brew's rustup is keg-only — its rustc/cargo proxies live here
[[ -d "$HOMEBREW_PREFIX/opt/rustup/bin" ]] && export PATH="$PATH:$HOMEBREW_PREFIX/opt/rustup/bin"
# `cargo install` binaries land here
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# --- History (file-based; atuin adds the searchable DB on top) -------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history        # every terminal sees the same history live
setopt hist_ignore_space    # leading space = don't record (for sensitive cmds)
setopt hist_ignore_all_dups

# --- Plugins (zinit) -------------------------------------------------------
source "$HOME/.config/zsh/plugins.zsh"

# --- Completion ------------------------------------------------------------
# compinit builds tab-completion. -C skips the audit check for faster startup.
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # colored entries

# kubectl completion, loaded lazily: the real `kubectl completion zsh` takes
# ~100ms, so we only pay that cost the first time kubectl is actually used.
kubectl() {
  unfunction kubectl
  source <(command kubectl completion zsh)
  command kubectl "$@"
}

# --- Keybindings -----------------------------------------------------------
bindkey -e                       # emacs-style line editing (default-friendly)
WORDCHARS=''                     # word-jumps stop at / _ - . (path-friendly)
bindkey '^[[1;3C' forward-word   # Option+Right
bindkey '^[[1;3D' backward-word  # Option+Left

# --- Aliases & functions ---------------------------------------------------
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

# --- fzf configuration (theme, previews, defaults) -------------------------
source "$HOME/.config/zsh/fzf.zsh"

# --- Tool hooks ------------------------------------------------------------
# Each prints shell code we eval. Order matters: atuin after fzf so atuin
# owns Ctrl-R (fzf keeps Ctrl-T files / Alt-C dirs).
eval "$(mise activate zsh)"                    # runtime versions (node/go/py)
eval "$(zoxide init zsh)"                      # `z <dir>` smart jumping
eval "$(direnv hook zsh)"                      # auto-load .envrc per project
eval "$(fzf --zsh)"                            # Ctrl-T, Alt-C, **<Tab>
eval "$(atuin init zsh --disable-up-arrow)"    # Ctrl-R history search
eval "$(starship init zsh)"                    # the prompt — keep last

# --- Machine-local overrides (gitignored — secrets live here) --------------
[[ -f "$HOME/.config/zsh/env.local.zsh" ]] && source "$HOME/.config/zsh/env.local.zsh"
