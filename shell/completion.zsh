# --- Completion ---
autoload -U compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
