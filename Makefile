.DEFAULT_GOAL := help

.PHONY: help setup setup-all symlinks defaults linux-defaults versions validate brew-install brew-install-base brew-install-work brew-cleanup brew-export flatpaks-install flatpaks-install-base flatpaks-install-work flatpaks-export

help: ## List available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "  %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: defaults linux-defaults symlinks brew-install-base flatpaks-install-base versions ## Base setup: configure OS, symlink configs, install base packages + flatpaks, show versions

setup-all: defaults linux-defaults symlinks brew-install flatpaks-install versions ## Full setup: base setup + work packages + work flatpaks

defaults: ## Configure macOS defaults: folders, system, screenshots, Finder, Dock (no-op on Linux)
	./scripts/macos-defaults.sh

linux-defaults: ## Configure Linux/GNOME defaults: folders, input, Nautilus, desktop (no-op on macOS / non-GNOME)
	./scripts/linux-defaults.sh

symlinks: ## Symlink configs to home directory
	./scripts/symlinks.sh

versions: ## Show installed Go, Node, Python versions
	@printf '%s\n' "--- Go ---"
	@go version
	@printf '\n%s\n' "--- Node ---"
	@fnm list
	@printf '\n%s\n' "--- Python ---"
	@uv python list --only-installed

validate: ## Run full audit: parse all TOML/JSON/YAML/JSONC, brew bundle check, flatpaks lint, shellcheck, symlink verification
	./scripts/validate.sh

brew-install: brew-install-base brew-install-work ## Install all packages from Brewfiles

brew-install-base: ## Install base packages (shell, fonts, daily-driver apps)
	brew bundle install --file=Brewfile

brew-install-work: ## Install work packages (work GUIs: API, K8s, DB, runtime, comms, VPN, browser)
	brew bundle install --file=Brewfile.work

brew-cleanup: ## Clean up old versions and cache
	brew cleanup --prune=all

brew-export: ## Export installed packages to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually (macOS only; Linuxbrew install state would wipe macOS-only casks)
	@if [ "$$(uname -s)" != "Darwin" ]; then echo "brew-export: macOS only (current: $$(uname -s)), skipping to avoid wiping macOS-only casks."; exit 0; fi; \
	brew bundle dump --file=Brewfile --force && \
	grep -E '^(brew|cask|tap|vscode|mas) "' Brewfile.work | grep -vxFf - Brewfile > Brewfile.tmp && mv Brewfile.tmp Brewfile && \
	echo "Stripped Brewfile.work entries from Brewfile"

flatpaks-install: flatpaks-install-base flatpaks-install-work ## Install all flatpaks from flatpaks files (Linux only)

flatpaks-install-base: ## Install base flatpaks (Linux only; no-op on macOS)
	./scripts/flatpaks-install.sh flatpaks

flatpaks-install-work: ## Install work flatpaks (Linux only; no-op on macOS)
	./scripts/flatpaks-install.sh flatpaks.work

flatpaks-export: ## Export installed user flatpaks to flatpaks, then strip flatpaks.work entries; add new work entries to flatpaks.work manually
	@if [ "$$(uname -s)" != "Linux" ]; then echo "flatpaks-export: Linux only, skipping."; exit 0; fi; \
	flatpak list --user --app --columns=application \
	  | awk 'NR==1 && $$0=="Application" {next} {print}' > flatpaks && \
	grep -vE '^\s*(#|$$)' flatpaks.work | grep -vxFf - flatpaks > flatpaks.tmp && mv flatpaks.tmp flatpaks && \
	echo "Stripped flatpaks.work entries from flatpaks"
