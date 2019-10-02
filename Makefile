DOTFILES_DIR := $(shell pwd)

all: brew zsh npm docker util

brew:
	chmod +x $(DOTFILES_DIR)/brew.sh
	$(DOTFILES_DIR)/brew.sh

npm:
	chmod +x $(DOTFILES_DIR)/npm.sh
	$(DOTFILES_DIR)/npm.sh

docker:
	chmod +x $(DOTFILES_DIR)/docker.sh
	$(DOTFILES_DIR)/docker.sh

zsh:
	chmod +x $(DOTFILES_DIR)/zsh.sh
	$(DOTFILES_DIR)/zsh.sh

util:
	chmod +x $(DOTFILES_DIR)/util.sh
	$(DOTFILES_DIR)/util.sh
