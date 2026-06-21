.DEFAULT_GOAL := help

.PHONY: help setup setup-all symlinks local-overrides macos-defaults linux-defaults versions validate snapshots brew-install brew-install-base brew-install-work brew-cleanup brew-export

help: ## List available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "  %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: macos-defaults linux-defaults symlinks local-overrides brew-install-base versions ## Base setup: configure OS, symlink configs, apply local overrides, install base packages, show versions

setup-all: macos-defaults linux-defaults symlinks local-overrides brew-install versions ## Full setup: base setup + work packages

macos-defaults: ## Configure macOS defaults: folders, system, screenshots, Finder, Dock (no-op on Linux)
	./scripts/macos-defaults.sh

linux-defaults: ## Configure Linux/GNOME defaults: folders, input, Nautilus, desktop (no-op on macOS / non-GNOME)
	./scripts/linux-defaults.sh

symlinks: ## Symlink configs to home directory
	./scripts/symlinks.sh

local-overrides: ## Render per-machine overrides from .local/source.toml into tracked git/zprofile/claude/codex configs
	./scripts/local-overrides.py

versions: ## Show installed Go, Node, Python versions
	@printf '%s\n' "--- Go ---"
	@go version
	@printf '\n%s\n' "--- Node ---"
	@fnm list
	@printf '\n%s\n' "--- Python ---"
	@uv python list --only-installed

validate: ## Run full audit: parse configs, brew bundle, ghostty, shellcheck, shfmt, zsh -n, codex rules, git config, CLI flag configs, symlinks
	./scripts/validate.sh

snapshots: ## Regenerate upstream defaults snapshots in defaults/ (ghostty + starship + bat: local CLI; zed/yazi/superfile/atuin: curl upstream main; vscodium: manual)
	@mkdir -p defaults
	@printf '%s\n' "==> ghostty"
	@if command -v ghostty >/dev/null 2>&1; then \
		ghostty +show-config --default --docs > defaults/ghostty-defaults.conf && \
		echo "    wrote defaults/ghostty-defaults.conf"; \
	else echo "    SKIP (ghostty not installed)"; fi
	@printf '\n%s\n' "==> starship (nerd-font-symbols preset)"
	@if command -v starship >/dev/null 2>&1; then \
		starship preset nerd-font-symbols -o defaults/starship-nerd-font-symbols.toml && \
		echo "    wrote defaults/starship-nerd-font-symbols.toml"; \
	else echo "    SKIP (starship not installed)"; fi
	@printf '\n%s\n' "==> bat (BAT_CONFIG_PATH override to avoid clobbering ~/.config/bat/config)"
	@if command -v bat >/dev/null 2>&1; then \
		rm -f defaults/bat-defaults.conf && \
		BAT_CONFIG_PATH=defaults/bat-defaults.conf bat --generate-config-file >/dev/null && \
		echo "    wrote defaults/bat-defaults.conf"; \
	else echo "    SKIP (bat not installed)"; fi
	@printf '\n%s\n' "==> zed (upstream main, NOT installed version)"
	@if command -v curl >/dev/null 2>&1; then \
		curl -fsSL https://raw.githubusercontent.com/zed-industries/zed/main/assets/settings/default.json -o defaults/zed-defaults.jsonc && \
		echo "    wrote defaults/zed-defaults.jsonc (tracks zed-industries/zed@main)"; \
	else echo "    SKIP (curl not installed)"; fi
	@printf '\n%s\n' "==> yazi (upstream main, NOT installed version)"
	@if command -v curl >/dev/null 2>&1; then \
		curl -fsSL https://raw.githubusercontent.com/sxyazi/yazi/main/yazi-config/preset/yazi-default.toml -o defaults/yazi-defaults.toml && \
		echo "    wrote defaults/yazi-defaults.toml (tracks sxyazi/yazi@main)"; \
	else echo "    SKIP (curl not installed)"; fi
	@printf '\n%s\n' "==> superfile (upstream main, NOT installed version)"
	@if command -v curl >/dev/null 2>&1; then \
		curl -fsSL https://raw.githubusercontent.com/yorukot/superfile/main/src/superfile_config/config.toml -o defaults/superfile-defaults.toml && \
		echo "    wrote defaults/superfile-defaults.toml (tracks yorukot/superfile@main)"; \
	else echo "    SKIP (curl not installed)"; fi
	@printf '\n%s\n' "==> atuin (upstream main, NOT installed version)"
	@if command -v curl >/dev/null 2>&1; then \
		curl -fsSL https://raw.githubusercontent.com/atuinsh/atuin/main/crates/atuin-client/config.toml -o defaults/atuin-defaults.toml && \
		echo "    wrote defaults/atuin-defaults.toml (tracks atuinsh/atuin@main)"; \
	else echo "    SKIP (curl not installed)"; fi
	@printf '\n%s\n' "==> vscodium (manual)"
	@if command -v brew >/dev/null 2>&1; then \
		brew info --json=v2 --cask vscodium 2>/dev/null \
			| grep -m1 '"version"' \
			| sed 's/.*"version": *"\([^"]*\)".*/    cask version: \1/' || true; \
	fi
	@echo "    no CLI hook; in VSCodium run: Preferences: Open Default Settings (JSON)"
	@echo "    then save to: $(CURDIR)/defaults/vscodium-defaults.jsonc"

brew-install: brew-install-base brew-install-work ## Install all packages from Brewfiles

brew-install-base: ## Install base packages (shell, fonts, daily-driver apps)
	brew bundle install --file=Brewfile

brew-install-work: ## Install work packages (work GUIs: API, K8s, DB, runtime, comms, VPN, browser)
	brew bundle install --file=Brewfile.work

brew-cleanup: ## Clean up old versions and cache
	brew cleanup --prune=all

brew-export: ## Export installed packages to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually (macOS only; Linuxbrew install state would wipe macOS-only casks)
	@if [ "$$(uname -s)" != "Darwin" ]; then echo "brew-export: macOS only (current: $$(uname -s)), skipping to avoid wiping macOS-only casks."; exit 0; fi; \
	brew bundle dump --file=Brewfile --force --no-describe && \
	grep -E '^(brew|cask|tap|vscode|mas|go|uv|npm) "' Brewfile.work | grep -vxFf - Brewfile > Brewfile.tmp && mv Brewfile.tmp Brewfile && \
	echo "Stripped Brewfile.work entries from Brewfile"
