export ZSH="/Users/$USER/.oh-my-zsh"

POWERLEVEL9K_MODE='awesome-patched'

[[ -f ~/dotfiles/.config/.p10k.zsh ]] && source ~/dotfiles/.config/.p10k.zsh

plugins=(git docker nvm yarn)

source $ZSH/oh-my-zsh.sh

source ~/powerlevel10k/powerlevel10k.zsh-theme

eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvmsource ~/powerlevel10k/powerlevel10k.zsh-theme

alias claude="~/.claude/local/claude"
