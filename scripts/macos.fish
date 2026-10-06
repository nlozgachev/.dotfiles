#!/usr/bin/env -S fish --no-config
# macOS developer defaults configuration

echo "Applying macOS developer defaults..."

# ── Keyboard & Input ─────────────────────────────────────────────────────────
# Disable press-and-hold for keys in favor of key repeat (crucial for Helix/Vim)
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable smart quotes and dashes (prevents code syntax corruption)
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic spelling correction and capitalization
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# ── Finder ───────────────────────────────────────────────────────────────────
# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar at the bottom of Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar at the bottom of Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ── Screenshots & Window Animations ──────────────────────────────────────────
# Disable shadow in window screenshots (Cmd+Shift+4 + Space)
defaults write com.apple.screencapture disable-shadow -bool true

# Accelerated window resize animations
defaults write -g NSWindowResizeTime -float 0.001

# Suppress "Last login" message when opening a new terminal window
touch ~/.hushlogin

echo "Restarting affected services (Finder)..."
killall Finder 2>/dev/null; or true

echo "Done. Note: Some keyboard settings may require an app restart or re-login to take full effect across all applications."
