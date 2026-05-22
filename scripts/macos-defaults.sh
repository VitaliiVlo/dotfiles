#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "macos-defaults: macOS only (current: $(uname -s)), skipping."
    exit 0
fi

heading() { printf "\n\033[1;34m%s\033[0m\n" "$*"; }

heading "→ Creating folders…"
mkdir -p "$HOME/Projects"
mkdir -p "$HOME/Screenshots"

heading "→ Configuring system defaults…"
# Input
defaults write NSGlobalDomain ApplePressAndHoldEnabled            -bool   false  # Key repeat instead of accent menu
defaults write NSGlobalDomain com.apple.swipescrolldirection      -bool   true   # Natural scrolling
# Save dialogs
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud   -bool   false  # Save to disk by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool   false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool   false

heading "→ Setting screenshot location…"
# Location
defaults write com.apple.screencapture location       "$HOME/Screenshots"
# Capture options
defaults write com.apple.screencapture disable-shadow -bool   true
defaults write com.apple.screencapture show-thumbnail -bool   true
defaults write com.apple.screencapture type           -string "png"
killall SystemUIServer >/dev/null 2>&1 || true

heading "→ Configuring Finder…"
# View
defaults write com.apple.finder FXPreferredViewStyle             -string "Nlsv"  # List view
# Path & status bar
defaults write com.apple.finder ShowPathbar                      -bool   true
defaults write com.apple.finder ShowStatusBar                    -bool   true
# File extensions
defaults write com.apple.finder AppleShowAllExtensions           -bool   true
defaults write com.apple.finder FXEnableExtensionChangeWarning   -bool   true
# Desktop items
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop  -bool   true
defaults write com.apple.finder ShowHardDrivesOnDesktop          -bool   false
defaults write com.apple.finder ShowMountedServersOnDesktop      -bool   true
defaults write com.apple.finder ShowRemovableMediaOnDesktop      -bool   true
# Search
defaults write com.apple.finder FXDefaultSearchScope             -string "SCcf"  # Search current folder
# Sort
defaults write com.apple.finder _FXSortFoldersFirst              -bool   true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop     -bool   true
# Hidden files
defaults write com.apple.finder AppleShowAllFiles                -bool   true
# DS_Store on network/USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores     -bool true
killall Finder >/dev/null 2>&1 || true

heading "→ Configuring Dock…"
# Appearance
defaults write com.apple.dock orientation             -string "bottom"
defaults write com.apple.dock show-process-indicators -bool   true
defaults write com.apple.dock show-recents            -bool   false
defaults write com.apple.dock tilesize                -int    64
# Behavior
defaults write com.apple.dock autohide                -bool   true
defaults write com.apple.dock autohide-delay          -float  0
defaults write com.apple.dock autohide-time-modifier  -float  0.25
defaults write com.apple.dock launchanim              -bool   true
defaults write com.apple.dock mineffect               -string "scale"
defaults write com.apple.dock minimize-to-application -bool   false
# Mission Control & Spaces
defaults write com.apple.dock expose-group-apps       -bool   true
defaults write com.apple.dock mru-spaces              -bool   false
# Hot corners (Cmd-gated to prevent accidental triggers; modifier 1048576 = Cmd)
# Actions: 2=Mission Control, 4=Desktop, 12=Notification Center, 14=Quick Note
defaults write com.apple.dock wvous-tl-corner         -int    2
defaults write com.apple.dock wvous-tl-modifier       -int    1048576
defaults write com.apple.dock wvous-tr-corner         -int    12
defaults write com.apple.dock wvous-tr-modifier       -int    1048576
defaults write com.apple.dock wvous-bl-corner         -int    4
defaults write com.apple.dock wvous-bl-modifier       -int    1048576
defaults write com.apple.dock wvous-br-corner         -int    14
defaults write com.apple.dock wvous-br-modifier       -int    1048576
killall Dock >/dev/null 2>&1 || true

heading "Finished applying defaults."
