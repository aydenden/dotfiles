# install nvm (script from https://github.com/creationix/nvm)
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
# install node
nvm install lts/carbon
nvm install stable
# use lts to be safe for new
nvm use lts/carbon

npm install -g \
    json-server \
    @vue/cli
