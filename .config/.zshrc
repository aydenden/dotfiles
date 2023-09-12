export ZSH="/Users/$USER/.oh-my-zsh"

POWERLEVEL9K_MODE='awesome-patched'

[[ -f ~/dotfiles/.config/.p10k.zsh ]] && source ~/dotfiles/.config/.p10k.zsh

plugins=(git docker nvm macos yarn)

source $ZSH/oh-my-zsh.sh

source ~/powerlevel10k/powerlevel10k.zsh-theme

eval "$(/opt/homebrew/bin/brew shellenv)"