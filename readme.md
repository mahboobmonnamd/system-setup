# Initial Setup

- Login with Apple ID
- Remove unwanted apps from the dock
- Open **Notes**, enable cloud sync
- Open **Messages**, In Menu **Messages** -> settings -> Enable icloud

## Run Commands
```sh
cd scripts
./bootstrap.sh
./git_setup.sh
```

# Brew

- Install brew
```sh
brew bundle -v
```
- Dump brew
```sh
brew bundle dump --describe -fv
```

# Essentials Setup

## Themes
https://github.com/catppuccin/catppuccin?tab=readme-ov-file

## Developer Tools

- Install xcode-select
```sh
  xcode-select --install
```
### brew
- Install brew
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- To use brew it needs to be add in path
> Run these two commands in your terminal to add Homebrew to your PATH:
```sh
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
```


- Tools under expriment
```sh
  brew install --cask maccy devtoys
```

### Shell

- Install pk10
```sh
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

## Warp
#### Appearance

- Expand alias
- Theme Light
- Update prompt (Remote Login, Working dir, git, +2, kube-context)
- Increase Font size to 14
- Font to `Iosevka`

#### Features
- Default App - vscode
- Receive desktop notification
- Working dir Advanced

## Finder
- CMD+SHIFT+. to show hidden folders
- Finder -> Settings
  - In Sidebar,
      1. Remove unwanted folders from the sidebar. (recent airdrop applications)
      2. ADD/Have (Airdrop, Home, Developer)

  
## System Settings

### Lock Screen
- Screen saver never
- Turn display off **10 mins**
- Require password **immediately**

### Desk and Dock
- Ask to keep changes while closing

### Control Center
- Show Battery Percentage
- Sound Always show in menubar
- Spotlight dont show
- App expose swipe down


### File Vault
- Enable file vault with icloud reset


## Others
- vmware fusion

