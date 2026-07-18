# system-setup — entry points. Run `make help` to see what's available.
#
# PROFILE picks which extra Brewfile to install on top of the base one:
#   make brew                  -> base + personal (default)
#   make brew PROFILE=work     -> base + work
PROFILE ?= personal

# Which stow packages to link. Grows as we add phases (zsh, git, tmux, ...).
# Override for a subset: make stow PACKAGES="zsh"
PACKAGES ?= $(notdir $(wildcard stow/*))

.PHONY: help brew stow unstow sync macos touchid bootstrap

help:
	@echo "make brew     install everything in brew/Brewfile.base + brew/Brewfile.$(PROFILE)"
	@echo "make stow     symlink stow/* packages into \$$HOME  (currently: $(PACKAGES))"
	@echo "make unstow   remove those symlinks"
	@echo "make sync     brew + stow"
	@echo "make macos    apply macOS defaults (keyboard/Finder/Dock) — run yourself"
	@echo "make touchid  enable Touch ID for sudo — run yourself"

brew:
	brew bundle --file=brew/Brewfile.base
	brew bundle --file=brew/Brewfile.$(PROFILE)
	@# Brewfile.local: optional, gitignored, machine-specific (e.g. mas apps)
	@[ -f brew/Brewfile.local ] && brew bundle --file=brew/Brewfile.local || true

# --restow = re-link (safe to run repeatedly; picks up new files)
# --target  = where the symlinks land; --dir = where the packages live
# Pre-creating ~/.ssh (700) stops stow from symlinking the whole directory
# into the repo — only the config file inside it gets linked.
stow:
	@mkdir -p $(HOME)/.config $(HOME)/.ssh && chmod 700 $(HOME)/.ssh
	stow --dir=stow --target=$(HOME) --restow $(PACKAGES)

unstow:
	stow --dir=stow --target=$(HOME) --delete $(PACKAGES)

sync: brew stow

bootstrap:
	bash scripts/bootstrap.sh

macos:
	bash scripts/macos.sh

touchid:
	bash scripts/touchid_sudo.sh
