# Install Homebrew
if ! [[ -x "$(command -v brew)" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

DOTFILES_DIR := $(shell pwd)

# Update, upgrade
brew update
brew upgrade

brew bundle --file=${DOTFILES_DIR}/Brewfile

brew cleanup
brew cask cleanup
