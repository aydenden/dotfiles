#!/usr/bin/env bash

brew update
brew install zsh

chsh -s `which zsh`
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

