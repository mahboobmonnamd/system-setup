# system-setup

Terminal-first macOS setup, rebuilt from scratch — phase by phase, so every
line in here is understood, not inherited.

## How it works

Two mechanisms do all the work:

- **`brew bundle`** — `brew/Brewfile.base` (+ a profile file) declares every
  package/app on the machine. `make brew` makes the machine match the files.
- **`stow`** — each folder under `stow/` mirrors `$HOME`. `make stow` symlinks
  its contents into place, so live configs and the repo are the same files.

```sh
make help     # see all targets
make brew     # install packages (PROFILE=personal by default, PROFILE=work on work machine)
make stow     # link dotfiles into $HOME
```

## Phases

- [x] **0 — skeleton**: Makefile, Brewfiles, stow mechanism
- [ ] **1 — shell**: zsh + zinit + Starship prompt + fzf/zoxide/eza/bat
- [ ] **2 — terminal**: Ghostty
- [ ] **3 — git**: delta, lazygit, multi-account identities via SSH host aliases
- [ ] **4 — tmux**: minimal config, grown as needed
- [ ] **5 — neovim**: LazyVim, learned gradually
- [ ] **6 — languages & containers**: fnm, rustup, go, uv, colima + k8s tools
