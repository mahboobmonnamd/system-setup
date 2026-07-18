# system-setup

Terminal-first macOS setup. Every config is small, commented, and understood —
nothing inherited blindly. Theme: **Catppuccin Latte (light)** across every tool.

## How it works

- **`brew bundle`** — `brew/Brewfile.base` (+ profile file) declares every
  package/app. `make brew` makes the machine match the files.
- **`stow`** — each folder under `stow/` mirrors `$HOME`. `make stow` symlinks
  its contents into place; live configs and the repo are the same files.

```sh
make brew     # install packages   (PROFILE=work on the work machine)
make stow     # link dotfiles into $HOME
make sync     # both
```

**Rule:** no alias ever shadows a standard command (cat/ls/grep/find behave
exactly as on any machine — pasted snippets and agent-run commands stay safe).
Modern tools are used via their own names: `rg`, `fd`, `bat`, `eza`, `dust`,
`duf`, `sd`, `btop`.

## New machine bootstrap

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone <this-repo> ~/Developer/system-setup && cd ~/Developer/system-setup
make sync
mise use -g node@lts go@latest     # language runtimes
rustup default stable
./scripts/git_setup.sh personal work   # ssh keys + git identities (interactive)
```

## Daily drivers

| Command | What |
|---|---|
| `z <name>` | jump to any directory you've visited (zoxide) |
| `Ctrl-R` | fuzzy-search all shell history (atuin) |
| `Ctrl-T` / `Alt-C` | fuzzy-pick files / cd into dirs with preview (fzf) |
| `ll` / `lt` | rich file listing / tree (eza) |
| `lg` | lazygit — full git TUI |
| `lzd` | lazydocker |
| `y` | yazi file manager (exits into the browsed dir) |
| `k` | kubectl (with completions) |
| `tldr <cmd>` | community cheatsheet for any command |
| `reload` | apply shell config edits |

## Ghostty (terminal)

Config: `stow/ghostty/.config/ghostty/config`. JetBrains Mono Nerd Font,
Latte light theme, slight blur. **Cmd+`** from anywhere = quake-style dropdown
terminal. Cmd+Up/Down jumps between past prompts (shell integration).

## tmux — prefix is `Ctrl-a`

| Key | Action |
|---|---|
| `Ctrl-a c` / `Ctrl-a 1..9` | new window / switch window |
| `Ctrl-a \|` / `Ctrl-a -` | split right / down (keeps current dir) |
| `Ctrl-h/j/k/l` | move across panes AND nvim splits (no prefix) |
| `Ctrl-a T` | **sesh session picker** — fzf over sessions + zoxide dirs |
| `Ctrl-a d` | detach; `tmux attach` to return |
| `Ctrl-a r` / `Ctrl-a I` | reload config / install plugins |

Sessions auto-save every 15 min and restore on restart (resurrect+continuum).

## Neovim — LazyVim

`<Space>` is the leader; pressing it shows a menu of everything.

| Key | Action |
|---|---|
| `<Space><Space>` | fuzzy-find files |
| `<Space>/` | grep across the project |
| `<Space>e` | file explorer |
| `<Space>gg` | lazygit inside nvim |
| `jk` | exit insert mode |
| `<Space>w` | save |
| `Shift-h/l` | previous / next buffer |

Language support (LSP, formatting, debugging) comes from LazyVim extras —
TypeScript, Go, Rust, Python, YAML, Docker, JSON, Markdown — configured in
`stow/nvim/.config/nvim/lazyvim.json`. Servers auto-install on first launch.
Claude Code integration via the `ai.claudecode` extra.

## Git — multi-account identities

The **clone URL** decides the identity (name/email/SSH key), not the folder:

```sh
git clone git@github.com:you/repo.git         # personal
git clone git@github.com-work:org/repo.git    # work
git whoami                                    # confirm active identity
```

`scripts/git_setup.sh` generates keys and identity files. Real identities are
gitignored; there's deliberately no global user.name — a repo matching no rule
fails loudly instead of committing as the wrong author. Diffs use delta;
`git lg` for graph log; `git undo` un-commits keeping changes.

## Runtimes — mise

One tool for node/go/python versions. Per-project: drop a `.mise.toml` or
`.nvmrc` and mise auto-switches. `mise ls` shows installed. Rust via rustup;
python packaging via uv.

## Containers & k8s

**License policy:** `Brewfile.base` contains only open-source / free-for-
commercial-use tools (it's shared with the work machine). The docker CLI +
compose + buildx are Apache-2.0; only Docker *Desktop* is commercial, and we
don't use it. The VM behind the CLI differs per machine:

- **personal**: colima (`colima start`; `colima start --kubernetes` for k3s)
- **work**: Rancher Desktop (provides the docker socket + k8s)

```sh
docker ps                 # same CLI on both machines
kind create cluster       # local k8s in docker
k9s                       # cluster TUI; kubectx/kubens to switch contexts
stern <pod-prefix>        # tail logs across pods
```

## Mac-level setup

Deliberately minimal: Spotlight stays as the launcher.

- **Loop** — open-source window snapping (halves/thirds via keyboard);
  grant Accessibility permission on first launch
- `make macos` — keyboard (fast repeat, no press-and-hold popup — vital for
  vim), tap-to-click, three-finger drag, Finder path/status bars + list view,
  Dock autohide, screenshots to ~/Screenshots. Run it yourself; log out/in after.
- `make touchid` — Touch ID for sudo (update-safe via /etc/pam.d/sudo_local)

## Repo layout

```
Makefile            brew / stow / sync entry points
brew/               Brewfile.base + Brewfile.{personal,work}
stow/               one package per tool: zsh, starship, ghostty, git,
                    lazygit, tmux, nvim, atuin, ssh
scripts/git_setup.sh  interactive ssh-key + git-identity bootstrap
```

Machine-local secrets: `~/.config/zsh/env.local.zsh` and
`~/.ssh/config.local` (both gitignored, sourced/Included automatically).
