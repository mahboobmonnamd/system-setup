# Environment exports — sourced from ~/.zshrc after Homebrew shellenv.
# Keep secrets and machine overrides in env.local.zsh (gitignored).

# --- Editors -----------------------------------------------------------------
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"

# --- Theme / colors (Catppuccin Latte — light) -------------------------------
# bat: built-in light theme matches the Latte terminal background
export BAT_THEME="${BAT_THEME:-GitHub}"

# LS_COLORS for completion lists / eza / fd (vivid when available)
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin-latte)"
else
  # Fallback LS_COLORS tuned for light backgrounds
  export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.zip=01;31:*.gz=01;31:*.bz2=01;31:*.xz=01;31:*.7z=01;31:*.rar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.png=01;35:*.svg=01;35:*.mp4=01;35:*.mkv=01;35:*.webm=01;35:*.mp3=00;36:*.flac=00;36:*.wav=00;36:'
fi

# BSD ls colors (macOS) — only matters if you call /bin/ls directly
export LSCOLORS='ExGxFxdaCxDaDahbadacec'

# eza metadata tones (dates/sizes stay muted on light bg)
export EZA_COLORS='da=38;5;245:sb=38;5;245:sn=38;5;245:uu=38;5;245:un=38;5;245:gu=38;5;245:gn=38;5;245'

# Autosuggestions: light gray so they don't fight the Latte prompt
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

# Optional ripgrep config (create ~/.config/ripgrep/config if you want one)
[[ -f "$HOME/.config/ripgrep/config" ]] && export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# --- PATH --------------------------------------------------------------------
# Rust: brew's rustup is keg-only — its rustc/cargo proxies live here
[[ -d "$HOMEBREW_PREFIX/opt/rustup/bin" ]] && export PATH="$PATH:$HOMEBREW_PREFIX/opt/rustup/bin"
# `cargo install` binaries land here
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# libpq client tools (psql) when installed via brew
[[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/libpq/bin" ]] && export PATH="$PATH:$HOMEBREW_PREFIX/opt/libpq/bin"

# Go binaries (mise or system go)
if command -v go >/dev/null 2>&1; then
  _gopath="$(go env GOPATH 2>/dev/null)"
  [[ -n "$_gopath" && -d "$_gopath/bin" ]] && export PATH="$PATH:$_gopath/bin"
  unset _gopath
fi
