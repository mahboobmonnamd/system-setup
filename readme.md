# system-setup

macOS bootstrap and dotfiles for setting up a new machine with Homebrew, Zsh, Neovim, and a small set of stowed configs.

## What this repo manages

- Homebrew packages from `brew/Brewfile.base` plus a profile-specific Brewfile
- Oh My Zsh and the `bat` Catppuccin theme
- Stowed config for `git`, `zsh`, `nvim`, and `finicky`
- macOS defaults applied by `scripts/osx.sh` during bootstrap

## Requirements

- macOS
- Xcode Command Line Tools available, or let bootstrap prompt for them
- Admin access for Homebrew install and macOS defaults during bootstrap

## Quick start

From the repo root:

```sh
make help
make bootstrap
```

`make bootstrap` runs the full setup:

1. installs Homebrew packages for your selected profile
2. installs Oh My Zsh and the `bat` theme
3. applies macOS defaults
4. stows the managed dotfiles into `$HOME`

## Common commands

```sh
make apps
make brew
make stow
make sync
make bootstrap
```

- `make apps`: Homebrew + shell/theme setup
- `make brew`: Homebrew packages only
- `make stow`: link dotfiles into `$HOME`
- `make sync`: rerun brew and stow
- `make bootstrap`: full machine setup

## Profiles

The default profile is `personal`.

Homebrew installs:

- `brew/Brewfile.base`
- `brew/Brewfile.<profile>`

Examples:

```sh
make apps PROFILE=work
make sync PROFILE=work
SETUP_PROFILE=work make bootstrap
```

If you want another profile, add `brew/Brewfile.<name>` and run with `PROFILE=<name>`.

## Dry run

Preview changes without applying them:

```sh
DRY_RUN=1 make apps
DRY_RUN=1 make stow
DRY_RUN=1 make bootstrap
```

Notes:

- `make stow` uses `stow -n` in dry-run mode
- `scripts/osx.sh` is skipped during bootstrap dry-runs

## Stow packages

Default stow packages:

| Package | Links |
|---|---|
| `git` | `~/.gitconfig` |
| `zsh` | `~/.zshrc`, `~/.config/zsh/*` |
| `nvim` | `~/.config/nvim` |
| `finicky` | `~/.config/finicky/finicky.js` |

Run a subset if needed:

```sh
STOW_PACKAGES="git zsh" make stow
```

If you hit conflicts, either move the existing file out of the way or intentionally adopt it once:

```sh
STOW_ADOPT=1 make stow
```

After stow, open a new terminal tab, or reload with:

```sh
STOW_RELOAD_SHELL=1 ./modules/stow.sh
```

## Shell notes

- `fzf` keybindings are configured for terminal use
- `Ctrl-T` opens file search with preview
- `Alt-C` opens directory search with tree preview
- `nvm` is lazy-loaded on first use
- `ls` uses `eza` when available
- local machine-only env values belong in `~/.config/zsh/env.local.zsh`

## Finicky

`make brew` installs Finicky and `make stow` links its config.

To use it:

1. Open macOS System Settings
2. Go to `Desktop & Dock`
3. Set default browser to `Finicky`

## Git identity

Git identity setup is separate:

```sh
cd scripts
./git_setup.sh
```

## Repo layout

- `Makefile`: main entrypoints
- `modules/brew.sh`: Homebrew install and bundle flow
- `modules/zsh.sh`: Oh My Zsh and `bat` theme setup
- `modules/stow.sh`: stow driver
- `modules/setup-apps.sh`: brew + zsh entrypoint
- `scripts/bootstrap.sh`: full bootstrap flow
- `scripts/osx.sh`: macOS defaults
- `brew/`: shared and profile-specific Brewfiles
- `stow/`: managed dotfiles
- `terminal-reference.html`: local printable terminal cheat sheet

## Recommended flow on a new Mac

```sh
git clone <repo-url>
cd system-setup
make bootstrap
```

Then:

1. open a new terminal tab
2. run `cd scripts && ./git_setup.sh`
3. verify your shell, git, and Neovim config look right
