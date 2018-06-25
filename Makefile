DOTFILES_DIR := $(shell pwd)

brew:
	chmod +x $(DOTFILES_DIR)/brew.sh
	$(DOTFILES_DIR)/brew.sh

docker:
	$(DOTFILES_DIR)/docker.sh
