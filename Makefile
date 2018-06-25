DOTFILES_DIR := $(shell pwd)

brew:
	chmod +x $(DOTFILES_DIR)/brew.sh
	source $(DOTFILES_DIR)/brew.sh

docker:
	source $(DOTFILES_DIR)/docker.sh
