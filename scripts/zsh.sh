#!/usr/bin/env bash

brew update
brew install zsh
chsh -s `which zsh`

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sudo rm -rf ~/.zshrc
ln -s ~/dotfiles/.config/.zshrc ~/

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
