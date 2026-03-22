# Initial setup (manual)

- Sign in with Apple ID
- Remove unwanted apps from the Dock
- Open **Notes** and enable iCloud sync
- Open **Messages** → Settings → enable iCloud

## Automated install (recommended)

From the **repository root**:

```sh
make bootstrap    # full flow: brew bundle, apps script, macOS defaults, stow
```

Or step by step:

```sh
make apps         # Homebrew bundle, Oh My Zsh (non-interactive), bat Catppuccin theme, pyenv/nvm hooks
make stow         # symlink dotfiles: git, zsh, nvim, finicky
```

To refresh packages and dotfiles after editing `apps/Brewfile` or `stow/*`:

```sh
make sync         # make brew && make stow
```

Non-interactive bootstrap (skips “press enter”):

```sh
BOOTSTRAP_NONINTERACTIVE=1 make bootstrap
```

Git identity (still separate):

```sh
cd scripts && ./git_setup.sh
```

`bootstrap` runs `scripts/osx.sh` (Finder/Dock defaults, etc.) and ends with stow. It does not replace one-off UI steps below (Warp appearance, Lock Screen, and so on).

### Stow packages

| Package  | What it links |
|----------|----------------|
| `git`    | `~/.gitconfig` |
| `zsh`    | `~/.zshrc`, `~/.config/zsh/*` |
| `nvim`   | `~/.config/nvim` |
| `finicky`| `~/.config/finicky/finicky.js` |

After stow, open a **new terminal tab** (or run `STOW_RELOAD_SHELL=1 ./stow/stow.sh` to replace the current shell).

### Shell notes

- **NVM** is lazy-loaded: the first `node` / `npm` / `npx` / `nvm` in a session sources NVM; later calls are normal binaries on `PATH`.
- **Listings**: `ls` uses **eza** when installed (`make brew`). Put secrets in `~/.config/zsh/env.local.zsh` (run `envconfig` to create/edit); that file is gitignored in this repo.
- **Oh My Zsh** theme in stow is `bira`. Powerlevel10k is optional and not installed by this repo unless you add it yourself.

### Finicky

1. `make brew` installs the Finicky cask; `make stow` links `~/.config/finicky/finicky.js`.
2. **System Settings** → **Desktop & Dock** → **Default web browser** → **Finicky**.
3. Edit rules in `stow/finicky/.config/finicky/finicky.js` (see [Finicky wiki](https://github.com/johnste/finicky/wiki)).

# Brew

Install or sync from the Brewfile (from repo root):

```sh
make brew
```

Dump the current machine back into a Brewfile-style list (run where you want the file):

```sh
brew bundle dump --describe --force --file=apps/Brewfile
```

# Essentials (reference)

## Themes

Catppuccin hub: [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin). This repo installs the **bat** Catppuccin Latte theme via `apps/catppuccin-theme.sh` (`BAT_THEME` is set in zsh exports). Warp/VS Code themes are manual or via their own settings/extensions.

## Developer tools

- Xcode CLT: `xcode-select --install`
- Homebrew (if not using `make apps`): [install script](https://brew.sh); then add to `PATH`:

```sh
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Warp (manual)

**Appearance:** expand aliases; theme **Catppuccin Latte** if you want; prompt fields you like; font **Nerd**, size ~15.

**Features:** default app VS Code; desktop notifications; working directory “advanced” if you use it.

## Finder

- **⌘⇧.** to show hidden files
- **Finder → Settings → Sidebar:** trim clutter; keep **AirDrop**, **Home**, **Developer** as you prefer

## System Settings

**Lock Screen:** screen saver as you like; display off ~10 minutes; require password immediately.

**Desktop & Dock:** “Ask to keep changes when closing documents” if you want that behavior.

**Control Center:** battery percentage; sound in menu bar; Spotlight visibility; App Exposé gesture as you like.

**FileVault:** enable with recovery you trust (e.g. iCloud recovery key).

## Others

- VMware Fusion (or UTM from the Brewfile) if you need VMs
