# Install Homebrew
if ! [[ -x "$(command -v brew)" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

dir=${pwd}

# Update, upgrade
brew update
brew upgrade

brew bundle --file=${dir}/Brewfile

brew cleanup
brew cask cleanup
