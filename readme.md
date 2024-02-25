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
  brew install --cask warp brave-browser visual-studio-code docker raycast android-studio google-drive appcleaner
  brew install git python3 zsh nvm go kubectl minikube watch discord slack rectangle openshift-cli bat
  sudo gem install colorls
```

- Tools under expriment
```sh
  brew install --cask fig maccy devtoys
```

### Shell
- Install `oh my zsh`
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
- Install pk10
```sh
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

- Install fonts
```sh
brew tap homebrew/cask-fonts
brew install font-iosevka
```
[Few other Fonts.](https://fonts.google.com/specimen/Source+Code+Pro)
- Add `~/.zshrc` and `~/shell/env.sh` from the repo.
```sh
  code ~/.zshrc
  code ~/shell/env.sh
  nvm install --lts
```

- Install other tools
```sh
npm i -g typescript ts-node
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
- View -> Show Status Bar
- View -> Show Path Bar
- Finder -> Settings
  - Change "New Finder windows show:", from "Recents" to "Developer" Folder.
  - In Sidebar,
      1. Remove unwanted folders from the sidebar. (recent airdrop applications)
      2. ADD/Have (Airdrop, Home, Developer)
  - In Advanced,
      1. Remove files after 30 days,
      2.  Search the current folder
  - In View -> Show view options
      1. Icon size -> 68
      1. Text size -> 14
      1. Show Item Info
      1. Show Library Folder
      1. Sort by Name
      1. Use Defaults.
  
## System Settings

### Lock Screen
- Screen saver never
- Turn display off **10 mins**
- Require password **immediately**

### Desk and Dock
- Show suggested and recent apps - Disable
- Default Browser - Brave
- Ask to keep changes while closing

### Control Center
- Show Battery Percentage
- Sound Always show in menubar
- Spotlight dont show
- App expose swipe down

### Trackpad
- Tap to click -> enable

### File Vault
- Enable file vault with icloud reset

# Android Studio
- In sdk manager, look for Android sdk platform create vm.
or install android-platform-tools for adb
```sh
brew install android-platform-tools
```

# GO
configure go
```sh
mkdir -p $HOME/Developer/.go/{bin,pkg}
export GOPATH=$HOME/Developer/go
```

# Git
- Create ssh

# Apps

## App store
- numbers
- pages
- keynote
- bitwarden
- Hp Smart

## Others
- vmware fusion

