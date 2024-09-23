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

.PHONY: clean-nix-builtin-conf
clean-nix-builtin-conf:
		@if [ -f $(NIX_CONF_PATH) ] && [ ! -L $(NIX_CONF_PATH) ]; then sudo rm -rf $(NIX_CONF_PATH); fi

.PHONY: buid-nix-darwin
build-nix-darwin: install-nix
		nix --experimental-features 'nix-command flakes' build '.?submodules=true#darwinConfigurations.darwin.system'

.PHONY: apply-nix-darwin
apply-nix-darwin: clean-nix-builtin-conf build-nix-darwin
	./result/sw/bin/darwin-rebuild switch --flake .#darwin


# .PHONY: apply-nix-darwin
# apply-nix-darwin: install-nix clean-nix-builtin-conf
# 		$(call if_command_exists,darwin-rebuild,\
# 			:,\
# 			nix --experimental-features 'nix-command flakes' build '.?submodules=true#darwinConfigurations.darwinM1.system';\
#
# 		)
