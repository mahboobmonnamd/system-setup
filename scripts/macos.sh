#!/usr/bin/env bash
# macOS defaults for a terminal-first developer machine.
# RUN THIS YOURSELF:  make macos   (then log out/in for everything to apply)
# Every line is safe, cosmetic/productivity only — no security settings are
# touched. Re-running is harmless (idempotent).

set -euo pipefail
[[ "$(uname -s)" == "Darwin" ]] || { echo "macOS only" >&2; exit 1; }

echo "==> Keyboard (the biggest win for terminal/vim work)"
# Holding a key REPEATS it (jjjj) instead of showing the accent popup — vital for vim
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Fastest key repeat + shortest delay (System Settings only goes half this fast)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Don't "correct" code: no auto-capitalize, smart quotes, autocorrect, or
# period-on-double-space
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "==> Trackpad"
# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Three-finger drag (move windows/select text without pressing down)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

echo "==> Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true   # always show .ext
defaults write com.apple.finder ShowPathbar -bool true            # path at bottom
defaults write com.apple.finder ShowStatusBar -bool true          # item count/space
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"  # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true    # folders on top
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # search current dir
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# New windows open in ~/Developer
mkdir -p "${HOME}/Developer"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Developer/"
# Don't litter .DS_Store on network shares / USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "==> Dock"
defaults write com.apple.dock autohide -bool false          # reclaim screen space
defaults write com.apple.dock autohide-delay -float 0      # appears instantly
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock show-recents -bool false     # no recent-apps section

echo "==> Screenshots -> ~/Screenshots (not the Desktop), no window shadows"
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo "==> Save panels: expanded by default, save to disk (not iCloud)"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Apply what can be applied live
killall Finder Dock SystemUIServer 2>/dev/null || true
echo "Done. Log out and back in for keyboard/trackpad changes to fully apply."
echo "Manual (worth doing): System Settings > Spotlight > exclude dev folders"
echo "(node_modules etc.) from indexing; Login Items — remove what you don't need."
