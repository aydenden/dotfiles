DOTFILES_DIR := $(shell pwd)

all: brew docker zsh npm

brew:
	chmod +x $(DOTFILES_DIR)/brew.sh
	$(DOTFILES_DIR)/brew.sh

docker:
	chmod +x $(DOTFILES_DIR)/docker.sh
	$(DOTFILES_DIR)/docker.sh

zsh:
	chmod +x $(DOTFILES_DIR)/zsh.sh
	$(DOTFILES_DIR)/zsh.sh

npm:
	chmod +x $(DOTFILES_DIR)/npm.sh
	$(DOTFILES_DIR)/npm.sh
