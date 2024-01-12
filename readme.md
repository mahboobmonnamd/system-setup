# Initial Setup

- Login with Apple ID
- Remove unwanted apps from the dock
- Open **Notes**, enable cloud sync
- Open **Messages**, In Menu **Messages** -> settings -> Enable icloud

# Essentials Setup

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
- Install tools
```sh
  brew install --cask warp brave-browser visual-studio-code docker raycast android-studio google-drive openshift-cli appcleaner
  brew install git python3 zsh tree nvm go kubectl minikube watch discord slack rectangle
```
- Tools under expriment
```sh
  brew install --cask fig maccy devtoys
```

### Shell
1. Add `~/.zshrc` and `~/shell/env` from the repo.

```sh
  nvm install --lts
  
```

## Finder
- CMD+SHIFT+. to show hidden folders
- View -> Show Status Bar
- View -> Show Path Bar
- Finder -> Settings
  - Change "New Finder windows show:", from "Recents" to "Developer" Folder.
  - In Sidebar,
      1. Remove unwanted folders from sidebar. (recents airdrop applications)
      2. ADD/Have (Airdrop, Home, Developer)
  - In Advanced,
      1. Remove files after 30 days,
      2.  Search current folder
- View -> Show view options
      1. Icon size -> 68
      2. Text size -> 14
      3. Show Item Info
      4. Show Library Folder
      5. Sort by Name
      6. Use Defaults.
  
## System Settings

### Lock Screen
- Screen saver never
- Turn dispaly off **10 mins**
- Require password **immediately**

### Desk and Dock
- Show suggested and recent apps - Disable
  
### Trackpad
- Tap to click -> enable

### File Vault
- Enable file vault with icloud reset

# Android Studio
- In sdk manager, look for Android sdk platform and install it.
