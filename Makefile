# Dotfiles and Homebrew automation (run from repo root)
ROOT := $(abspath .)

.PHONY: stow brew apps bootstrap sync

stow:
	cd "$(ROOT)/stow" && ./stow.sh

brew:
	brew bundle --file="$(ROOT)/apps/Brewfile" --describe -fv

# Homebrew bundle + Oh My Zsh + bat Catppuccin theme (no macOS defaults; no stow)
apps:
	"$(ROOT)/apps/install.sh" "$(ROOT)/apps/Brewfile" "$(ROOT)/apps/oh-my-zsh.sh" "$(ROOT)/apps/catppuccin-theme.sh"

bootstrap:
	cd "$(ROOT)/scripts" && ./bootstrap.sh

# After editing Brewfile or stow packages: install packages then relink dotfiles
sync: brew stow
