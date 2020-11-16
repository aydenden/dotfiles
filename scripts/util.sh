#!/usr/bin/env bash
# jadda java version manager
if ! [[ -x "$(command -v jabba)" ]]; then
    curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
fi

# hammerspoon
rm -rf ~/.hammerspoon
ln -s ~/dotfiles/.config/.hammerspoon ~/


# .finicky.js
rm -rf ~/.finicky.js
ln -s ~/dotfiles/.config/.finicky.js ~/

