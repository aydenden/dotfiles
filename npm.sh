# install nvm (script from https://github.com/creationix/nvm)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# install node
nvm install --lts
nvm install stable
# use lts to be safe for new
nvm use --lts

export NVM_DIR=~/.nvm
source ~/.nvm/nvm.sh

npm install -g \
    json-server \
    @vue/cli \
    vuepress
