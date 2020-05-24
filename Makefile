DOTFILES_DIR := $(shell pwd)

all: brew zsh npm docker util

brew:
	chmod +x $(DOTFILES_DIR)/scripts/brew.sh
	$(DOTFILES_DIR)/brew.sh

npm:
	chmod +x $(DOTFILES_DIR)/scripts/npm.sh
	$(DOTFILES_DIR)/npm.sh

docker:
	chmod +x $(DOTFILES_DIR)/scripts/docker.sh
	$(DOTFILES_DIR)/docker.sh

zsh:
	chmod +x $(DOTFILES_DIR)/scripts/zsh.sh
	$(DOTFILES_DIR)/zsh.sh

util:
	chmod +x $(DOTFILES_DIR)/scripts/util.sh
	$(DOTFILES_DIR)/util.sh
