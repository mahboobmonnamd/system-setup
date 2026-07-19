#!/usr/bin/env bash
# macOS defaults for a terminal-first developer machine.
# RUN THIS YOURSELF:  make macos   (then log out/in for everything to apply)
# Every line is safe, cosmetic/productivity only — no security settings are
# touched. Re-running is harmless (idempotent).

set -euo pipefail
[[ "$(uname -s)" == "Darwin" ]] || { echo "macOS only" >&2; exit 1; }

# Close System Settings so it can't overwrite keys we change mid-run.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

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
# Tab through EVERY control in dialogs, not just text boxes (keyboard-first)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

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
chflags nohidden "${HOME}/Library"                                # un-hide ~/Library
# New windows open in ~/Developer
mkdir -p "${HOME}/Developer"
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Developer/"
# Don't litter .DS_Store on network shares / USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Show mounted drives/servers on the Desktop (handy for USB installers, shares)
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

echo "==> Dock"
defaults write com.apple.dock autohide -bool false          # reclaim screen space
defaults write com.apple.dock autohide-delay -float 0      # appears instantly
defaults write com.apple.dock autohide-time-modifier -float 0.4
defaults write com.apple.dock show-recents -bool false     # no recent-apps section
defaults write com.apple.dock showhidden -bool true         # hidden apps' icons go translucent
defaults write com.apple.dock mru-spaces -bool false        # don't auto-rearrange Spaces/desktops

# OPT-IN: reset the Dock to a curated app list. Commented out because it WIPES
# your current Dock and hardcodes apps — uncomment/edit only if you want that.
# defaults write com.apple.dock persistent-apps -array
# for app in \
#   "/Applications/Ghostty.app" \
#   "/Applications/Brave Browser.app" \
#   "/Applications/Obsidian.app" \
#   "/System/Applications/System Settings.app"; do
#   [[ -d "$app" ]] && defaults write com.apple.dock persistent-apps -array-add \
#     "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
# done

echo "==> Screenshots -> ~/Screenshots (not the Desktop), no window shadows"
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

echo "==> Save panels + snappier animations"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Faster window open/resize animations (feels snappier, not disabled entirely)
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "==> Apps (Activity Monitor / Printer / Photos)"
# Activity Monitor: open its window on launch, show ALL processes, sort by CPU
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5          # CPU-usage Dock icon
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
# Quit the printer queue app automatically once jobs finish
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Don't auto-launch Photos when a phone/camera/SD card is connected
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "==> Menu bar / Control Center"
# Show the battery PERCENTAGE in the menu bar (Big Sur..Tahoe live under
# Control Center; the second key covers older builds — harmless either way).
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Apply what can be applied live
killall Finder Dock SystemUIServer ControlCenter 2>/dev/null || true
echo "Done. Log out and back in for keyboard/trackpad changes to fully apply."
echo "Manual (worth doing): System Settings > Spotlight > exclude dev folders"
echo "(node_modules etc.) from indexing; Login Items — remove what you don't need."
