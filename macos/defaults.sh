#!/usr/bin/env bash
# =============================================================================
# macOS 개발자 필수 시스템 설정
# =============================================================================

# System Preferences 종료 (설정 충돌 방지)
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null

# sudo 유효성 유지
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- 키보드 ---
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false

# --- Finder ---
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
chflags nohidden ~/Library

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 36

# --- 스크린샷 ---
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"

# --- 시스템 ---
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write com.apple.LaunchServices LSQuarantine -bool false

# --- 적용 ---
killall Finder 2>/dev/null
killall Dock 2>/dev/null

echo "macOS defaults 적용 완료! 일부 설정은 재로그인 후 적용됩니다."
