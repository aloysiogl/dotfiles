# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./set-defaults.sh and you'll be good to go.

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Set dock to autohide
defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock

# Cmd+Q acctually closes finder
defaults write com.apple.finder QuitMenuItem -bool YES && killall Finder

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Shows the betttery percentage
defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true

# Disable press and hold to allow for vim key repeat on vscode-like editors
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false # VSCode
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false # Cursor

# Aerospace needed defaults
defaults write com.apple.dock expose-group-apps -bool true && killall Dock # fix mission control
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer # fix stability issues and allows for windows to span displays
