
source ./functions.sh

setup_osx_defaults() {
    
    info "Configuring MacOS default settings"

    # Close any open System Preferences panes, to prevent them from overriding
    # settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

	# Avoid creating .DS_Store files on network volumes
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Show path bar
	defaults write com.apple.finder ShowPathbar -bool true

	# Show hidden files inside the finder
	defaults write com.apple.finder "AppleShowAllFiles" -bool true

	# Show Status Bar
	defaults write com.apple.finder "ShowStatusBar" -bool true

    # Save screenshots to the desktop
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screen\ Shots"

    # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true
}

setup_osx_defaults