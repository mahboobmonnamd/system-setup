#!/bin/bash

echo "####### Installing brew and other scripts #######"

brewfile="${1:-./Brewfile}"
omzfile="${2:-./oh-my-zsh.sh}"

# Ensure the brewfile exists
if [ ! -f "$brewfile" ]; then
    echo "Brewfile not found: $brewfile"
    exit 1
fi


# Install Homebrew (if not already installed)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    sudo --validate
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# Install applications from the brewfile
echo "Installing applications from $brewfile..."
brew bundle --file="$brewfile"

# Additional setup or configurations can be added here

pyenv install 3.9

echo '##### Installing colorls#######'
if ! command -v colorls &> /dev/null; then
sudo gem install colorls
colorls --light
fi

echo '##### Npm Based install #######'

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
nvm install --lts
npm i -g typescript ts-node

echo '##### Installing oh my zsh#######'

chmod +x $omzfile

$omzfile

echo "Installation completed."
