#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

symlink() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
}

echo "Creating symbolic links from $DOTFILES_DIR to $HOME..."

# Shell
symlink ".zprofile" "$HOME/.zprofile"
symlink ".zshrc"    "$HOME/.zshrc"

# Shell tools (history, pager, system monitor, terminal, search, prompt)
symlink ".config/atuin/config.toml"   "$HOME/.config/atuin/config.toml"
symlink ".config/bat/config"          "$HOME/.config/bat/config"
symlink ".config/bottom/bottom.toml"  "$HOME/.config/bottom/bottom.toml"
symlink ".config/ghostty/config"      "$HOME/.config/ghostty/config"
symlink ".config/ripgrep/ripgreprc"   "$HOME/.config/ripgrep/ripgreprc"
symlink ".config/starship.toml"       "$HOME/.config/starship.toml"

# Git/file tools
symlink ".config/gh/config.yml"       "$HOME/.config/gh/config.yml"
symlink ".config/git/config"          "$HOME/.config/git/config"
symlink ".config/git/ignore"          "$HOME/.config/git/ignore"
symlink ".config/lazygit/config.yml"  "$HOME/.config/lazygit/config.yml"
symlink ".config/yazi/yazi.toml"      "$HOME/.config/yazi/yazi.toml"

# Editors
symlink ".config/micro/settings.json" "$HOME/.config/micro/settings.json"
symlink ".config/zed/settings.json"   "$HOME/.config/zed/settings.json"

# AI agents (non-XDG, identical on both OSes; ASCII alpha within each tool)
symlink ".config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"
symlink ".config/claude/CLAUDE.md"           "$HOME/.claude/CLAUDE.md"
symlink ".config/claude/settings.json"       "$HOME/.claude/settings.json"
symlink ".config/codex/AGENTS.md"            "$HOME/.codex/AGENTS.md"
symlink ".config/codex/config.toml"          "$HOME/.codex/config.toml"
symlink ".config/codex/rules/dev.rules"      "$HOME/.codex/rules/dev.rules"
symlink ".config/codex/rules/git.rules"      "$HOME/.codex/rules/git.rules"
symlink ".config/codex/rules/infra.rules"    "$HOME/.codex/rules/infra.rules"
symlink ".config/codex/rules/shell.rules"    "$HOME/.codex/rules/shell.rules"

# Platform-native paths: glow, superfile, tlrc, vscode read from
# ~/Library/* on macOS but XDG ~/.config/* on Linux.
case "$(uname -s)" in
    Darwin)
        symlink ".config/glow/glow.yml"        "$HOME/Library/Preferences/glow/glow.yml"
        symlink ".config/superfile/config.toml" "$HOME/Library/Application Support/superfile/config.toml"
        symlink ".config/tlrc/config.toml"     "$HOME/Library/Application Support/tlrc/config.toml"
        symlink ".config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
        ;;
    Linux)
        symlink ".config/glow/glow.yml"        "$HOME/.config/glow/glow.yml"
        symlink ".config/superfile/config.toml" "$HOME/.config/superfile/config.toml"
        symlink ".config/tlrc/config.toml"     "$HOME/.config/tlrc/config.toml"
        symlink ".config/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
        ;;
    *)
        echo "Unsupported OS: $(uname -s) — skipping glow/superfile/tlrc/vscode symlinks." >&2
        ;;
esac

echo "Symbolic links created."
