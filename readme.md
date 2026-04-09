# system-setup

macOS bootstrap and dotfiles for setting up a new machine with Homebrew, Zsh, Neovim, and Tmux.

## What this repo manages

- Homebrew packages from `brew/Brewfile.base` plus a profile-specific Brewfile
- Oh My Zsh and the `bat` Catppuccin theme
- Stowed config for `git`, `zsh`, `nvim`, `tmux`, and `finicky`
- Neovim full dev setup (LazyVim + LSP + formatting + light theme)
- Tmux with Catppuccin Latte theme, session persistence, and nvim integration
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
| `tmux` | `~/.config/tmux/tmux.conf`, `~/.config/tmux/plugins/tpm` |
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

## Neovim

Built on [LazyVim](https://www.lazyvim.org/) with:

- **Theme**: Catppuccin Latte (light)
- **LSP**: TypeScript (`ts_ls`), Python (`pyright`), JSON, Lua
- **Formatting**: `prettierd` for TS/JS, `black` + `isort` for Python, `stylua` for Lua
- **Linting**: `eslint_d` for TS/JS, `flake8` for Python
- **Plugins**: Treesitter, Telescope, neo-tree, Trouble, LazyGit, Toggleterm, todo-comments, autopairs

All language servers and formatters are auto-installed by Mason on first launch.

### Key bindings (on top of LazyVim defaults)

| Key | Action |
|---|---|
| `jk` | Exit insert mode |
| `<leader>w` | Save file |
| `<leader>e` | Toggle file explorer |
| `<leader>gg` | Open LazyGit |
| `<C-\>` | Toggle terminal |
| `<leader>xx` | Toggle diagnostics (Trouble) |
| `<leader>st` | Search TODOs |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-h/j/k/l>` | Navigate windows (also works across tmux panes) |

## Tmux

- **Theme**: Catppuccin Latte (matches Neovim)
- **Prefix**: `Ctrl+b` (default)
- **Plugin manager**: TPM (tracked as a git submodule)

### Plugins

| Plugin | Purpose |
|---|---|
| `tmux-sensible` | Sane defaults |
| `tmux-resurrect` | Save and restore sessions across reboots |
| `tmux-continuum` | Auto-save sessions every 15 min |
| `vim-tmux-navigator` | Seamless `Ctrl+h/j/k/l` navigation across nvim and tmux panes |

### Key bindings

| Key | Action |
|---|---|
| `Ctrl+b \|` | Split pane vertically |
| `Ctrl+b -` | Split pane horizontally |
| `Ctrl+b r` | Reload tmux config |
| `Ctrl+b h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+h/j/k/l` | Navigate panes + nvim windows seamlessly |
| `Enter` | Enter copy mode |
| `v` (copy mode) | Begin selection |
| `y` (copy mode) | Copy selection |

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
  - `stow/nvim/`: Neovim config (LazyVim-based)
  - `stow/tmux/`: Tmux config + TPM submodule
- `terminal-reference.html`: local printable terminal cheat sheet

## Recommended flow on a new Mac

```sh
git clone --recurse-submodules <repo-url>
cd system-setup
make bootstrap
```

Then:

1. open a new terminal tab
2. run `cd scripts && ./git_setup.sh`
3. open `nvim` — plugins install automatically on first launch
4. open `tmux`, press `Ctrl+b I` to install tmux plugins
5. verify your shell, git, Neovim, and Tmux config look right
