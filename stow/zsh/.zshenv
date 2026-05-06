# ===============================================================================
# Homebrew setup (macOS)
# ===============================================================================
# Initialize Homebrew environment and PATH
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export NVM_DIR="$HOME/.nvm"

# Add NVM default node bin to PATH for ALL shells (interactive, non-interactive,
# scripts, Claude Code agent shells). Resolves the alias chain: default -> lts/* -> vX.Y.Z
() {
  local v="default" dir="$NVM_DIR/alias" i=0
  while [[ -f "$dir/$v" && $i -lt 5 ]]; do
    v=$(< "$dir/$v")
    (( i++ ))
  done
  [[ -d "$NVM_DIR/versions/node/$v/bin" ]] && export PATH="$NVM_DIR/versions/node/$v/bin:$PATH"
}
