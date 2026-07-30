# system-setup — entry points. Run `make help` to see what's available.
#
# PROFILE picks which extra Brewfile to install on top of the base one:
#   make brew                  -> base + personal (default)
#   make brew PROFILE=work     -> base + work
PROFILE ?= personal

# Which stow packages to link. Grows as we add phases (zsh, git, tmux, ...).
# Override for a subset: make stow PACKAGES="zsh"
PACKAGES ?= $(notdir $(wildcard stow/*))

# Where `make add` records a package. Override: make add NAME=foo TO=personal
TO ?= base

.PHONY: help brew stow unstow sync macos touchid bootstrap guide add check \
	obsidian-sync obsidian-sync-install obsidian-sync-uninstall

help:
	@echo "make bootstrap  full fresh-machine setup (scripts/bootstrap.sh)"
	@echo "make brew       install brew/Brewfile.base + brew/Brewfile.\$$(PROFILE)"
	@echo "make add        install + record in a Brewfile: make add NAME=ripgrep [TO=personal] [CASK=1]"
	@echo "make check      list installed pkgs NOT tracked in any Brewfile (read-only)"
	@echo "make stow       symlink stow/* into \$$HOME  (currently: $(PACKAGES))"
	@echo "make unstow     remove those symlinks"
	@echo "make sync       brew + stow"
	@echo "make guide      open the terminal muscle-memory HTML guide"
	@echo "make macos      apply macOS defaults (keyboard/Finder/Dock) — run yourself"
	@echo "make touchid    enable Touch ID for sudo — run yourself"
	@echo "make obsidian-sync            backup Brain vault to GitHub now"
	@echo "make obsidian-sync-install    enable hourly vault backup"
	@echo "make obsidian-sync-uninstall  disable hourly vault backup"
	@echo ""
	@echo "Variables: PROFILE=personal|work  (default: $(PROFILE))"
	@echo "           TO=base|personal|work|local  (for make add; default: $(TO))"

brew:
	brew bundle --file=brew/Brewfile.base
	brew bundle --file=brew/Brewfile.$(PROFILE)
	@# Brewfile.local: optional, gitignored, machine-specific (e.g. mas apps)
	@[ -f brew/Brewfile.local ] && brew bundle --file=brew/Brewfile.local || true

# --restow = re-link (safe to run repeatedly; picks up new files)
# --target  = where the symlinks land; --dir = where the packages live
# Pre-creating ~/.ssh (700) stops stow from symlinking the whole directory
# into the repo — only the config file inside it gets linked.
# Touch config.local so `Include ~/.ssh/config.local` always resolves.
stow:
	@mkdir -p $(HOME)/.config $(HOME)/.config/zsh $(HOME)/.ssh && chmod 700 $(HOME)/.ssh
	@touch $(HOME)/.ssh/config.local
	@# Seed machine-local env overrides (gitignored) from the example once
	@if [ ! -f $(HOME)/.config/zsh/env.local.zsh ]; then \
		cp stow/zsh/.config/zsh/env.local.zsh.example $(HOME)/.config/zsh/env.local.zsh; \
	fi
	@# OrbStack (installed during `make brew`) may write a real ~/.ssh/config
	@# before stow runs. This package owns that path — back up and replace.
	@if [ -e $(HOME)/.ssh/config ] && [ ! -L $(HOME)/.ssh/config ]; then \
		bak="$(HOME)/.ssh/config.pre-stow.$$(date +%Y%m%d%H%M%S).bak"; \
		mv $(HOME)/.ssh/config "$$bak"; \
		echo "Moved existing ~/.ssh/config -> $$bak (merge into ~/.ssh/config.local if needed)"; \
	fi
	stow --dir=stow --target=$(HOME) --restow $(PACKAGES)

unstow:
	stow --dir=stow --target=$(HOME) --delete $(PACKAGES)

sync: brew stow

check:
	@PROFILE="$(PROFILE)" bash scripts/brew_check.sh

# Install a formula/cask and append it to a Brewfile (default: base) in one
# step, so installed != tracked never happens. CASK=1 forces cask when a name
# exists as both a formula and a cask.
add:
	@test -n "$(NAME)" || { echo "usage: make add NAME=<pkg> [TO=base|personal|work|local] [CASK=1]"; exit 1; }
	@CASK="$(CASK)" bash scripts/brew_add.sh "$(NAME)" "$(TO)"

bootstrap:
	bash scripts/bootstrap.sh

macos:
	bash scripts/macos.sh

touchid:
	bash scripts/touchid_sudo.sh

guide:
	open docs/guide/index.html

obsidian-sync:
	bash scripts/obsidian_vault_sync.sh

obsidian-sync-install:
	bash scripts/obsidian_sync_install.sh install

obsidian-sync-uninstall:
	bash scripts/obsidian_sync_install.sh uninstall
