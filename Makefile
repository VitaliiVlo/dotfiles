.DEFAULT_GOAL := help

.PHONY: help setup setup-all link defaults versions validate brew-install brew-install-base brew-install-work brew-cleanup brew-export flatpaks-install flatpaks-install-base flatpaks-install-work flatpaks-export

help: ## List available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "  %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: defaults link brew-install-base versions ## Base setup: configure macOS, symlink configs, install base packages, show versions

setup-all: defaults link brew-install versions ## Full setup: base setup + work packages

defaults: ## Configure macOS defaults: folders, system, screenshots, Finder, Dock
	./scripts/macos-defaults.sh

link: ## Symlink configs to home directory
	./scripts/link.sh

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

brew-install-work: ## Install work packages (work GUIs: API, K8s, DB, runtime, comms, VPN)
	brew bundle install --file=Brewfile.work

brew-cleanup: ## Clean up old versions and cache
	brew cleanup --prune=all

brew-export: ## Export installed packages to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually
	brew bundle dump --file=Brewfile --force
	@grep -E '^(brew|cask|tap|vscode|mas) "' Brewfile.work | grep -vxFf - Brewfile > Brewfile.tmp && mv Brewfile.tmp Brewfile
	@echo "Stripped Brewfile.work entries from Brewfile"

flatpaks-install: flatpaks-install-base flatpaks-install-work ## Install all flatpaks from flatpaks files (Linux only)

flatpaks-install-base: ## Install base flatpaks (Linux only; no-op on macOS)
	./scripts/flatpaks-install.sh flatpaks

flatpaks-install-work: ## Install work flatpaks (Linux only; no-op on macOS)
	./scripts/flatpaks-install.sh flatpaks.work

flatpaks-export: ## Export installed user flatpaks to flatpaks, then strip flatpaks.work entries; add new work entries to flatpaks.work manually
	@if [ "$$(uname -s)" != "Linux" ]; then echo "flatpaks-export: Linux only, skipping."; exit 0; fi; \
	flatpak list --user --app --columns=application > flatpaks && \
	grep -vE '^\s*(#|$$)' flatpaks.work | grep -vxFf - flatpaks > flatpaks.tmp && mv flatpaks.tmp flatpaks && \
	echo "Stripped flatpaks.work entries from flatpaks"
