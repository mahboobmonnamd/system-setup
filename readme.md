# Initial setup (manual)

- Sign in with Apple ID
- Remove unwanted apps from the Dock
- Open **Notes** and enable iCloud sync
- Open **Messages** → Settings → enable iCloud

## Automated install (recommended)

All automation is **macOS-only**; scripts exit on other OSes.

From the **repository root**:

```sh
make help           # targets and variables
make bootstrap      # full flow: brew (profile) + zsh theme + macOS defaults + stow
```

Or step by step:

```sh
make apps           # Homebrew (base + profile) + Oh My Zsh + bat Catppuccin theme + pyenv/nvm
make stow           # symlink stow packages into $HOME (safe default, no --adopt)
```

Refresh after editing Brewfiles or stow trees:

```sh
make sync           # make brew && make stow
```

### Personal vs work (`SETUP_PROFILE`)

Homebrew installs **`brew/Brewfile.base`** plus **`brew/Brewfile.<profile>`**.

| Profile    | Extra Brewfile        | Typical use        |
|-----------|------------------------|--------------------|
| `personal` (default) | `brew/Brewfile.personal` | Discord, Scratch, etc. |
| `work`    | `brew/Brewfile.work`   | Slack, etc.  |

Examples:

```sh
make apps PROFILE=work
make sync PROFILE=work
SETUP_PROFILE=work make bootstrap
```

Add a new machine type: create **`brew/Brewfile.<name>`** and run `PROFILE=<name> make apps`.

### Dry-run

Preview actions without changing the system (no `sudo`, no `osx.sh` during bootstrap):

```sh
DRY_RUN=1 make apps
DRY_RUN=1 make stow
DRY_RUN=1 make bootstrap
```

`stow` uses **`stow -n`**. **`osx.sh` is skipped** in a bootstrap dry-run because it mutates defaults and restarts Dock/Finder.

### Stow safety and `--adopt`

By default **stow does not use `--adopt`**. With **`--adopt`**, GNU Stow **moves existing file contents into the stow package** in the repo and replaces them with symlinks — easy to accidentally commit machine-specific data. Only use it on purpose:

```sh
STOW_ADOPT=1 make stow
```

If stow errors on conflicts, back up the conflicting path, remove or rename it, then run `make stow` again — or use `STOW_ADOPT=1` once if you intend to merge into the package.

Optional package list:

```sh
STOW_PACKAGES="git zsh" make stow
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

### Stow packages (default)

| Package   | What it links |
|-----------|----------------|
| `git`     | `~/.gitconfig` |
| `zsh`     | `~/.zshrc`, `~/.config/zsh/*` |
| `nvim`    | `~/.config/nvim` |
| `finicky` | `~/.config/finicky/finicky.js` |

After stow, open a **new terminal tab**, or:

```sh
STOW_RELOAD_SHELL=1 ./modules/stow.sh
```

### Layout

- **`modules/lib.sh`** — logging, `require_darwin`, `DRY_RUN` / `run`, profile resolution  
- **`modules/brew.sh`** — Homebrew + bundles  
- **`modules/zsh.sh`** — Oh My Zsh + bat Catppuccin  
- **`modules/setup-apps.sh`** — `brew` + `zsh` entrypoint  
- **`modules/stow.sh`** — stow driver (also invoked via `stow/stow.sh`)  
- **`brew/Brewfile.base`**, **`brew/Brewfile.personal`**, **`brew/Brewfile.work`**

### Shell notes

- **NVM** is lazy-loaded: the first `node` / `npm` / `npx` / `nvm` in a session sources NVM; later calls use normal binaries on `PATH`.
- **Listings**: `ls` uses **eza** when installed (`make brew`). Secrets: `~/.config/zsh/env.local.zsh` (run `envconfig`); that template path is gitignored.
- **Oh My Zsh** theme in stow is `bira`.

### Finicky

1. `make brew` installs the Finicky cask; `make stow` links `~/.config/finicky/finicky.js`.
2. **System Settings** → **Desktop & Dock** → **Default web browser** → **Finicky**.
3. Edit rules under `stow/finicky/` (see [Finicky wiki](https://github.com/johnste/finicky/wiki)).

# Brew

```sh
make brew
# or with profile:
make brew PROFILE=work
```

Targets invoke scripts with **`bash modules/…`**, so you do not need the executable bit on those files. You can also run `bash modules/brew.sh` from the repo root.

### `brew bundle dump` and split Brewfiles

**`brew bundle dump` always writes a single Brewfile** describing what is installed on *this* Mac (formulae, casks, `mas`, `vscode`, etc., depending on flags). It does **not** know about `Brewfile.base` vs `Brewfile.personal` / `work` — there is no automatic split.

Typical workflow:

1. Dump to a **scratch** file (do not overwrite `Brewfile.base` blindly):

   ```sh
   brew bundle dump --force --file=brew/Brewfile.dumped
   ```

2. **Manually** reconcile: keep shared lines in **`brew/Brewfile.base`**, and only machine- or role-specific lines in **`brew/Brewfile.personal`** or **`brew/Brewfile.work`**. Use `diff` / your editor; remove duplicates so each formula/cask appears in **one** place.

3. Optional: compare against what Homebrew thinks is missing for a given file:

   ```sh
   brew bundle check --file=brew/Brewfile.base
   brew bundle check --file=brew/Brewfile.personal
   ```

Lock files (`Brewfile*.lock.json`), if you use them, are per Brewfile path — generate or update them with `brew bundle dump` from the same `--file` you care about.

# Essentials (reference)

## Themes

Catppuccin hub: [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin). This repo installs the **bat** Catppuccin Latte theme via **`modules/zsh.sh`** (`BAT_THEME` in zsh exports). Warp/VS Code themes stay manual.

## Developer tools

- Xcode CLT: `xcode-select --install`
- Homebrew (if not using `make apps`): [brew.sh](https://brew.sh); then:

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

- VMware Fusion (or **UTM** from the base Brewfile) if you need VMs

## Explore
- navi
- mcfly
- tealdeer
- mise

