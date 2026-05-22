#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Creating symbolic links from $DOTFILES_DIR to $HOME..."

# Shell
ln -sf "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Shell tools (history, pager, system monitor, terminal, search, prompt)
mkdir -p "$HOME/.config/atuin"
ln -sf "$DOTFILES_DIR/.config/atuin/config.toml" "$HOME/.config/atuin/config.toml"

mkdir -p "$HOME/.config/bat"
ln -sf "$DOTFILES_DIR/.config/bat/config" "$HOME/.config/bat/config"

mkdir -p "$HOME/.config/bottom"
ln -sf "$DOTFILES_DIR/.config/bottom/bottom.toml" "$HOME/.config/bottom/bottom.toml"

mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"

mkdir -p "$HOME/.config/ripgrep"
ln -sf "$DOTFILES_DIR/.config/ripgrep/ripgreprc" "$HOME/.config/ripgrep/ripgreprc"

ln -sf "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# Git/file tools
mkdir -p "$HOME/.config/gh"
ln -sf "$DOTFILES_DIR/.config/gh/config.yml" "$HOME/.config/gh/config.yml"

mkdir -p "$HOME/.config/git"
ln -sf "$DOTFILES_DIR/.config/git/config" "$HOME/.config/git/config"
ln -sf "$DOTFILES_DIR/.config/git/ignore" "$HOME/.config/git/ignore"

mkdir -p "$HOME/.config/lazygit"
ln -sf "$DOTFILES_DIR/.config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

mkdir -p "$HOME/.config/yazi"
ln -sf "$DOTFILES_DIR/.config/yazi/yazi.toml" "$HOME/.config/yazi/yazi.toml"

# Editors
mkdir -p "$HOME/.config/micro"
ln -sf "$DOTFILES_DIR/.config/micro/settings.json" "$HOME/.config/micro/settings.json"

mkdir -p "$HOME/.config/zed"
ln -sf "$DOTFILES_DIR/.config/zed/settings.json" "$HOME/.config/zed/settings.json"

# macOS-native config paths (tools that ignore XDG); sources live in repo .config/<tool>/
GLOW_DIR="$HOME/Library/Preferences/glow"
mkdir -p "$GLOW_DIR"
ln -sf "$DOTFILES_DIR/.config/glow/glow.yml" "$GLOW_DIR/glow.yml"

SUPERFILE_DIR="$HOME/Library/Application Support/superfile"
mkdir -p "$SUPERFILE_DIR"
ln -sf "$DOTFILES_DIR/.config/superfile/config.toml" "$SUPERFILE_DIR/config.toml"

TLRC_DIR="$HOME/Library/Application Support/tlrc"
mkdir -p "$TLRC_DIR"
ln -sf "$DOTFILES_DIR/.config/tlrc/config.toml" "$TLRC_DIR/config.toml"

VSCODE_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_DIR"
ln -sf "$DOTFILES_DIR/.config/vscode/settings.json" "$VSCODE_DIR/settings.json"

# AI agents
mkdir -p "$HOME/.config/ccstatusline"
ln -sf "$DOTFILES_DIR/.config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"

mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES_DIR/.config/claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$DOTFILES_DIR/.config/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

mkdir -p "$HOME/.codex"
ln -sf "$DOTFILES_DIR/.config/codex/config.toml" "$HOME/.codex/config.toml"
ln -sf "$DOTFILES_DIR/.config/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"

mkdir -p "$HOME/.codex/rules"
ln -sf "$DOTFILES_DIR/.config/codex/rules/dev.rules" "$HOME/.codex/rules/dev.rules"
ln -sf "$DOTFILES_DIR/.config/codex/rules/git.rules" "$HOME/.codex/rules/git.rules"
ln -sf "$DOTFILES_DIR/.config/codex/rules/infra.rules" "$HOME/.codex/rules/infra.rules"
ln -sf "$DOTFILES_DIR/.config/codex/rules/shell.rules" "$HOME/.codex/rules/shell.rules"

echo "✅ Symbolic links created successfully!"
