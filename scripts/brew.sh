#!/usr/bin/env bash

# Install Homebrew
if ! [[ -x "$(command -v brew)" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

DOTFILES_DIR=$(pwd)

# Update, upgrade
brew update
brew upgrade

brew bundle --file=${DOTFILES_DIR}/Brewfile

brew cleanup
