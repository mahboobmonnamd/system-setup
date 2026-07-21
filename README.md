# system-setup

Terminal-first macOS setup. Every config is small, commented, and understood —
nothing inherited blindly. Theme: **Catppuccin Latte (light)** across every tool.

## How it works

- **`brew bundle`** — `brew/Brewfile.base` (+ profile file) declares every
  package/app. `make brew` makes the machine match the files.
- **`stow`** — each folder under `stow/` mirrors `$HOME`. `make stow` symlinks
  its contents into place; live configs and the repo are the same files.

```sh
make bootstrap   # fresh Mac: CLT, Homebrew, packages, dotfiles, runtimes
make brew        # install packages   (PROFILE=work on the work machine)
make stow        # link dotfiles into $HOME
make sync        # brew + stow
make add NAME=fd              # install a formula AND append to Brewfile.base
make add NAME=discord TO=personal   # or TO=work / TO=local
make add NAME=SomeApp CASK=1 TO=personal   # force cask when name is ambiguous
```

**Rule:** no alias ever shadows a standard command (cat/ls/grep/find behave
exactly as on any machine — pasted snippets and agent-run commands stay safe).
Modern tools are used via their own names: `rg`, `fd`, `bat`, `eza`, `dust`,
`duf`, `sd`, `btop`.

## New machine bootstrap

```sh
git clone <this-repo> ~/Developer/system-setup && cd ~/Developer/system-setup
make bootstrap                          # or: ./scripts/bootstrap.sh
                                        # PROFILE=work make bootstrap  on work
./scripts/git_setup.sh --all            # ssh keys + git identities (interactive)
cp brew/Brewfile.local.example brew/Brewfile.local   # optional: add your mas apps
```

`make bootstrap` / `scripts/bootstrap.sh` handles: Xcode CLT, Homebrew, all
packages, dotfiles, node/go via mise, rust via rustup, docker CLI plugins,
nvim plugins, atuin import. Idempotent — rerun anytime.

## Daily drivers

**Muscle-memory guide:** [live on GitHub Pages](https://mahboobmonnamd.github.io/system-setup/)
· local: [`docs/guide/index.html`](docs/guide/index.html) (`make guide`).
Separate pages for shell, tmux, nvim, lazygit, lazydocker, yazi, k9s, git, and
Ghostty with keybinds and drills from *this* setup.

| Command | What |
|---|---|
| `z <name>` | jump to any directory you've visited (zoxide) |
| `Ctrl-R` | fuzzy-search all shell history (atuin) |
| `Ctrl-T` / `Alt-C` | fuzzy-pick files / cd into dirs with preview (fzf) |
| `tn` / `ta` / `tl` / `tk` / `tm` | tmux new / attach / list / kill / sesh picker |
| `ll` / `la` / `lt` | rich file listing / all / tree (eza) |
| `lg` | lazygit — full git TUI |
| `lzd` | lazydocker |
| `y` | yazi file manager (exits into the browsed dir) |
| `k` | kubectl (with completions) |
| `tldr <cmd>` | community cheatsheet for any command |
| `reload` | apply shell config edits |
| `Ctrl-G Ctrl-B / -H / -F` | fzf-pick git branches / hashes / changed files into the command line |
| `gco-fzf` / `gbd-fzf` | checkout / delete branches via fzf |
| `gpr` / `gundo` | create PR with gh / soft-undo last commit(s) |
| `Esc Esc` | prepend sudo to the current/previous command |
| `obs` / `odaily` / `ocd` / `obsync` | open vault / today’s note / jump to vault / backup vault |

The shell also *trains* you: type a command that has an alias and
`you-should-use` prints the shorter form until it sticks.

## Obsidian (personal)

Your notes vault is **`~/Documents/Brain`** — a private git repo, kept outside
this tree. The app is installed via `cask "obsidian"` in `Brewfile.personal`.

After `make stow`:

| Command | What it does |
|---|---|
| `obs` | Open the vault in Obsidian |
| `odaily` | Open today’s daily note |
| `ocd` | cd into the vault |
| `obsync` | Commit and push the vault to GitHub |

Turn on hourly backup with `make obsidian-sync-install`. How to use the vault
day to day (templates, Claude vs Bob) lives in the vault’s `GUIDE.md`. Short
cheat sheet: [`docs/guide/obsidian.html`](docs/guide/obsidian.html).

## Power tools (own names, no shadowing)

| Tool | Use |
|---|---|
| `xh` | HTTP client, httpie syntax: `xh :3000/api`, `xh POST url k=v` |
| `fx` | interactive JSON explorer: `curl ... \| fx` (jq for scripting) |
| `glow README.md` | render markdown in the terminal |
| `difft a b` | structural diff that understands syntax (difftastic) |
| `hyperfine 'cmd'` | benchmark a command properly |
| `watchexec -e go -- go test ./...` | rerun on file change |
| `tokei` | code statistics by language |
| `procs` / `gping` | modern process viewer / ping with a graph |
| `git absorb` | auto-target fixup commits to the right commit |
| `just` | per-project command runner (justfile) |

After `gh auth login`, install the PR dashboard: `gh extension install dlvhdr/gh-dash`, then `gh dash`.

## Ghostty (terminal)

Config: `stow/ghostty/.config/ghostty/config`. JetBrains Mono Nerd Font,
Latte light theme, slight blur. **Cmd+`** from anywhere = quake-style dropdown
terminal. Cmd+Up/Down jumps between past prompts (shell integration).

## tmux — prefix is `Ctrl-a`

Sessions from the shell: `tn name` / `ta name` / `tl` / `tk name`, or `tm`
for the sesh fuzzy picker. Inside tmux, `Ctrl-a T` is the same picker.

| Key / command | Action |
|---|---|
| `tn work` / `ta work` / `tl` / `tk work` | new / attach / list / kill session |
| `tm` | sesh picker from the shell |
| `Ctrl-a c` / `Ctrl-a 1..9` | new window / switch window |
| `Ctrl-a \|` / `Ctrl-a -` | split right / down (keeps current dir) |
| `Ctrl-h/j/k/l` | move across panes AND nvim splits (no prefix) |
| `Ctrl-a H/J/K/L` | resize pane by 5 |
| `Ctrl-a T` | **sesh session picker** — fzf over sessions + zoxide dirs |
| `Ctrl-a o` | jump to last sesh session |
| `Ctrl-a s` / `(`/`)` | session tree / prev / next session |
| `Ctrl-a d` | detach; `ta <name>` to return |
| `Ctrl-a r` / `Ctrl-a I` | reload config / install plugins |

Sessions auto-save every 15 min and restore on restart (resurrect+continuum).
Pane contents and nvim sessions are restored too.

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
git clone git@github.com:you/repo.git            # personal
git clone git@github.com-work:org/repo.git       # work
git clone git@github.com-freelance:c/repo.git    # freelance
git clone git@github.com-oss:proj/repo.git       # open-source
git whoami                                       # confirm active identity
```

Four accounts (personal / work / freelance / oss), each with its own SSH key
and name/email. `scripts/git_setup.sh [profiles...]` or `--all` generates keys
and identity files interactively (re-runnable — it shows current values and
lets you confirm or change them). Real identities are gitignored; there's
deliberately no global user.name — a repo matching no rule fails loudly instead
of committing as the wrong author. Identities bind to **SSH** remotes
(`git@github.com-work:...`); HTTPS remotes won't match and commits fail until
you switch the remote to the SSH alias. Diffs use delta; `git lg` for graph
log; `git undo` un-commits keeping changes.

### Always-on git safety (passive — nothing to remember)

- **Secret guard**: every new clone/init gets a pre-commit hook (via
  `init.templateDir`) that runs **gitleaks** on staged changes and blocks
  commits containing API keys/tokens. Existing repo? Run `git init` inside it
  once to adopt the hook. False positive? `git commit --no-verify`.
- **Signed commits**: each identity signs with its SSH key (`gpg.format=ssh`)
  — commits show **Verified** on GitHub. Upload each public key twice: as an
  *Authentication Key* AND a *Signing Key* (git_setup.sh reminds you).
  Signing turns on per-identity, so a fresh machine can commit before keys exist.
- **Global gitignore** (`~/.config/git/ignore`): `.DS_Store`, `.env.local`,
  editor junk excluded from every repo automatically.

## Install when needed (deliberately NOT installed)

Policy: tools get installed when a real need appears, not "just in case".
Everything below is one command away and license-safe for work; move it into
the Brewfile once it earns frequent use.

| Need | Install |
|---|---|
| Terraform work | `brew install opentofu tflint` (MPL fork; license-safe) |
| Scan image/IaC for CVEs & secrets | `brew install trivy` |
| Dockerfile linting | `brew install hadolint` |
| Validate k8s manifests offline | `brew install kubeconform` |
| Cluster sanity audit | `brew install popeye` |
| Encrypt secrets in a git repo (GitOps) | `brew install sops age` |
| Shared per-project git hooks | `brew install lefthook` |
| Large files in a repo | `brew install git-lfs && git lfs install` |
| Release Go binaries | `brew install goreleaser` |
| Rust watch-mode / faster tests | `brew install bacon cargo-nextest` |
| Node package manager | `brew install pnpm` (or `bun`) |
| Postman-style API TUI | `uv tool install posting` |
| Database TUI | `brew install lazysql` |
| gRPC / websocket testing | `brew install grpcurl websocat` |
| Local HTTPS certs | `brew install mkcert` |
| Quick tunnel to localhost | `brew install cloudflared` |

(`delve` and `ruff` are absent on purpose — Mason inside Neovim installs its
own copies for debugging/linting.)

## Finicky (browser routing)

Set Finicky as the default browser (System Settings > Desktop & Dock). It then
routes each link by rule — config in `stow/finicky/.config/finicky/finicky.js`.
The starter sends everything to **Browserino** (the per-click picker). Browserino
is personal-only (`Brewfile.personal`); trust the tap once first — see that
file. On a work machine without Browserino, set `defaultBrowser` to `"Safari"`
(or your work browser) so links still open. Add private-domain rules locally;
keep them out of the public repo.

## Machine-specific packages

`brew/Brewfile.local` (gitignored) holds entries that shouldn't be public —
mainly Mac App Store apps, whose numeric IDs are account-specific. Copy
`Brewfile.local.example` to `Brewfile.local`, uncomment the apps you want, and
`make brew` installs them after base + profile.

## Runtimes — mise

One tool for node/go/python versions. Per-project: drop a `.mise.toml` or
`.nvmrc` and mise auto-switches. `mise ls` shows installed. Rust via rustup;
python packaging via uv.

## Containers & k8s

**License policy:** `Brewfile.base` contains only open-source / free-for-
commercial-use tools (it's shared with the work machine). **Colima (MIT) is
the container VM on both machines** — no Docker Desktop, no Rancher Desktop.
The docker CLI + compose + buildx are Apache-2.0; only Docker *Desktop* is
the commercial product.

```sh
colima start                    # start the VM (add --kubernetes for k3s)
docker ps                       # docker CLI talks to colima; lazydocker for the TUI
kind create cluster             # local k8s in docker
k9s                             # cluster TUI — the lazygit of k8s (vim keys,
                                #   logs, exec, port-forward; `:pods`, `?` help)
k <anything>                    # kubecolor-wrapped kubectl with completions
kubectx / kubens                # switch cluster / namespace
stern <pod-prefix>              # tail logs across pods
kubectl krew install <plugin>   # plugin manager (e.g. tree, neat, ctx)
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
Makefile            brew / stow / sync / add / guide entry points
brew/               Brewfile.base + Brewfile.{personal,work}
stow/               one package per tool: zsh, starship, ghostty, git,
                    lazygit, tmux, nvim, atuin, ssh
docs/guide/         HTML muscle-memory cheatsheets (make guide)
scripts/brew_add.sh   make add — install a pkg and record it in a Brewfile
scripts/git_setup.sh  interactive ssh-key + git-identity bootstrap
```

Machine-local secrets: `~/.config/zsh/env.local.zsh` and
`~/.ssh/config.local` (both gitignored, sourced/Included automatically).
