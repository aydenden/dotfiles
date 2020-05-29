export ZSH="/Users/$USER/.oh-my-zsh"

POWERLEVEL9K_MODE='awesome-patched'
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -f ~/dotfiles/.config/.p10k.zsh ]] && source ~/dotfiles/.config/.p10k.zsh

plugins=(git docker nvm osx yarn web-search)

source $ZSH/oh-my-zsh.sh
