#!/usr/bin/env zsh
 # nvm
brew update
brew install nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# install node
nvm install --lts
nvm use --lts
export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh

# yarn 설치
npm install -g yarn
