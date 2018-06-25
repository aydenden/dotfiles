# Install Homebrew
if ! [[ -x "$(command -v brew)" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update, upgrade
brew update
brew upgrade

#tap
tap "homebrew/core"
tap "homebrew/bundle"
tap "homebrew/services"
tap "homebrew/dupes"
tap "homebrew/cask"
tap "homebrew/cask-versions"
tap "homebrew/cask-fonts"

#vcs
brew "git"
brew "subversion"

#node
brew "nvm"

#editor
cask 'visual-studio-code'

#ide
cask 'intellij-idea'

#font
cask "homebrew/cask-fonts/font-d2coding"

#util
brew "zsh"
cask "zazu"
cask 'iterm2'
cask 'google-chrome'
cask 'firefox'

#appstore util
brew "mas"
mas "Irvue", id: 1039633667
mas "Monosnap", id: 540348655
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Trello", id: 1278508951
mas "Wunderlist", id: 410628904
mas "KakaoTalk", id: 869223134
