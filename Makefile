.DEFAULT_GOAL := help

NIX_CONF_PATH := /etc/nix/nix.conf

fail = \
		@echo "$(1)" >&2; \
		exit 1

if_command_exists = \
		@echo "Checking if $(1) exists..."; \
		if command -v $(1) > /dev/null 2>&1; then \
			$(2); \
		else \
			$(3); \
		fi

.PHONY: help
help:
		@echo "dotfiles v5"

.PHONY: install-nix
install-nix:
		$(call if_command_exists,nix,\
			:,\
			$(call fail,"TODO: setup `install-nix`"))

.PHONY: install-rosetta
install-rosetta:
		@if /usr/bin/pgrep oahd >/dev/null 2>&1; then \
				softwareupdate --install-rosetta --agree-to-license; \
		else \
				:; \
		fi

.PHONY: setup-default-key-binding-dict
setup-default-key-binding-dict:
		@if [ ! -f /Library/KeyBindings/DefaultKeyBinding.dict ]; then \
				sudo mkdir -p /Library/KeyBindings; \
				sudo cp Library/KeyBindings/DefaultKeyBinding.dict /Library/KeyBindings/DefaultKeyBinding.dict; \
		fi

.PHONY: setup-launch-agents-neovide
setup-launch-agents-neovide:
		@if [ ! -f /Library/LaunchAgents/Neovide.plist ]; then \
				sudo mkdir -p /Library/LaunchAgents; \
				sudo cp Library/LaunchAgents/Neovide.plist /Library/LaunchAgents/Neovide.plist; \
		fi

.PHONY: update-dotfiles-nvim
update-dotfiles-nvim: install-nix
		nix flake lock --update-input dotfiles-nvim

.PHONY: clean-nix-builtin-conf
clean-nix-builtin-conf:
		@if [ -f $(NIX_CONF_PATH) ] && [ ! -L $(NIX_CONF_PATH) ]; then sudo rm -rf $(NIX_CONF_PATH); fi

.PHONY: build-nix-darwin
build-nix-darwin: install-nix install-rosetta setup-default-key-binding-dict setup-launch-agents-neovide
		nix --experimental-features 'nix-command flakes' build '.?submodules=true#darwinConfigurations.darwin.system'

.PHONY: build-nix-darwin-with-trace
build-nix-darwin-with-trace: install-nix install-rosetta
		nix --experimental-features 'nix-command flakes' build '.?submodules=true#darwinConfigurations.darwin.system' --show-trace

.PHONY: apply-nix-darwin
apply-nix-darwin: clean-nix-builtin-conf build-nix-darwin
		./result/sw/bin/darwin-rebuild switch --flake .#darwin

.PHONY: apply-nix-darwin-with-trace
apply-nix-darwin-with-trace: clean-nix-builtin-conf build-nix-darwin-with-trace
		./result/sw/bin/darwin-rebuild switch --flake .#darwin

.PHONY: apply-latest-nvim-darwin
apply-latest-nvim-darwin: update-dotfiles-nvim apply-nix-darwin
