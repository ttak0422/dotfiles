.DEFAULT_GOAL := help

# Fail before Make runs prerequisites, even for parallel builds.
legacy_darwin_goals := update-homebrew clean-nix-builtin-conf \
	install-rosetta setup-default-key-binding-dict setup-launch-agents-neovide \
	build-nix-darwin build-nix-darwin-with-trace apply-nix-darwin \
	apply-nix-darwin-with-trace apply-latest-nvim-darwin

# A standalone input update at the root also fetches legacy inputs on macOS.
ifneq ($(filter update-dotfiles-nvim,$(MAKECMDGOALS)),)
ifeq ($(shell uname -s),Darwin)
legacy_darwin_goals += update-dotfiles-nvim
endif
endif

ifneq ($(filter $(legacy_darwin_goals),$(MAKECMDGOALS)),)
ifneq ($(ALLOW_LEGACY_DARWIN),1)
$(error Legacy macOS targets require ALLOW_LEGACY_DARWIN=1. For next use ./next/scripts/macbook build or switch)
endif
endif

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

.PHONY: preflight-next
preflight-next:
		@./next/scripts/preflight

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
		nix flake update dotfiles-nvim

.PHONY: update-homebrew
update-homebrew: install-nix
		nix flake update nix-homebrew homebrew-core homebrew-cask homebrew-bundle brew-nix brew-api

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
		sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin

.PHONY: apply-nix-darwin-with-trace
apply-nix-darwin-with-trace: clean-nix-builtin-conf build-nix-darwin-with-trace
		sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin

.PHONY: apply-latest-nvim-darwin
apply-latest-nvim-darwin: update-dotfiles-nvim apply-nix-darwin

.PHONY: apply-nix-linux-laptop
apply-nix-linux-laptop:
	sudo nixos-rebuild switch --flake .#laptop

.PHONY: apply-latest-nvim-linux-laptop
apply-latest-nvim-linux-laptop: update-dotfiles-nvim apply-nix-linux-laptop
