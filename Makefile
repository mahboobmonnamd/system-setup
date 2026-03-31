# Dotfiles automation (run from repo root)
ROOT := $(abspath .)
PROFILE ?= personal
export SETUP_PROFILE ?= $(PROFILE)

# Set DRY_RUN=1 to print actions without changing the system (brew/stow simulate; osx.sh skipped in bootstrap)
DRY_RUN ?=

.PHONY: stow brew apps bootstrap sync help

help:
	@echo "Targets:"
	@echo "  make apps       Homebrew (brew/Brewfile.base + brew/Brewfile.\$$(SETUP_PROFILE)) + Oh My Zsh + bat theme"
	@echo "  make brew       Homebrew bundle only (same files as apps, no zsh theme)"
	@echo "  make stow       Symlink stow/* into \$$HOME (no --adopt unless STOW_ADOPT=1)"
	@echo "  make sync       brew + stow"
	@echo "  make bootstrap  Full scripts/bootstrap.sh (includes macOS defaults)"
	@echo ""
	@echo "Variables: PROFILE=personal|work  DRY_RUN=1  STOW_ADOPT=1  STOW_PACKAGES='git zsh'"

stow:
	env DRY_RUN="$(DRY_RUN)" STOW_ADOPT="$(STOW_ADOPT)" STOW_PACKAGES="$(STOW_PACKAGES)" \
		bash "$(ROOT)/modules/stow.sh"

brew:
	env DRY_RUN="$(DRY_RUN)" SETUP_PROFILE="$(SETUP_PROFILE)" bash "$(ROOT)/modules/brew.sh"

apps:
	env DRY_RUN="$(DRY_RUN)" SETUP_PROFILE="$(SETUP_PROFILE)" bash "$(ROOT)/modules/setup-apps.sh"

bootstrap:
	cd "$(ROOT)/scripts" && env DRY_RUN="$(DRY_RUN)" SETUP_PROFILE="$(SETUP_PROFILE)" ./bootstrap.sh

sync: brew stow
