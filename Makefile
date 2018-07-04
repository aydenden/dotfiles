DOTFILES_DIR := $(shell pwd)

all: brew zsh

brew:
	chmod +x $(DOTFILES_DIR)/brew.sh
	$(DOTFILES_DIR)/brew.sh

docker:
	chmod +x $(DOTFILES_DIR)/docker.sh
	$(DOTFILES_DIR)/docker.sh

zsh:
	$(DOTFILES_DIR)/zsh.sh
