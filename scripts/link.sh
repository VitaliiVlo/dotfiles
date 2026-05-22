#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

link() {
    local src="$DOTFILES_DIR/$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
}

echo "Creating symbolic links from $DOTFILES_DIR to $HOME..."

# Shell
link ".zprofile" "$HOME/.zprofile"
link ".zshrc"    "$HOME/.zshrc"

# Shell tools (history, pager, system monitor, terminal, search, prompt)
link ".config/atuin/config.toml"   "$HOME/.config/atuin/config.toml"
link ".config/bat/config"          "$HOME/.config/bat/config"
link ".config/bottom/bottom.toml"  "$HOME/.config/bottom/bottom.toml"
link ".config/ghostty/config"      "$HOME/.config/ghostty/config"
link ".config/ripgrep/ripgreprc"   "$HOME/.config/ripgrep/ripgreprc"
link ".config/starship.toml"       "$HOME/.config/starship.toml"

# Git/file tools
link ".config/gh/config.yml"       "$HOME/.config/gh/config.yml"
link ".config/git/config"          "$HOME/.config/git/config"
link ".config/git/ignore"          "$HOME/.config/git/ignore"
link ".config/lazygit/config.yml"  "$HOME/.config/lazygit/config.yml"
link ".config/yazi/yazi.toml"      "$HOME/.config/yazi/yazi.toml"

# Editors
link ".config/micro/settings.json" "$HOME/.config/micro/settings.json"
link ".config/zed/settings.json"   "$HOME/.config/zed/settings.json"

# AI agents (non-XDG, identical on both OSes)
link ".config/ccstatusline/settings.json" "$HOME/.config/ccstatusline/settings.json"
link ".config/claude/settings.json"       "$HOME/.claude/settings.json"
link ".config/claude/CLAUDE.md"           "$HOME/.claude/CLAUDE.md"
link ".config/codex/config.toml"          "$HOME/.codex/config.toml"
link ".config/codex/AGENTS.md"            "$HOME/.codex/AGENTS.md"
link ".config/codex/rules/dev.rules"      "$HOME/.codex/rules/dev.rules"
link ".config/codex/rules/git.rules"      "$HOME/.codex/rules/git.rules"
link ".config/codex/rules/infra.rules"    "$HOME/.codex/rules/infra.rules"
link ".config/codex/rules/shell.rules"    "$HOME/.codex/rules/shell.rules"

# Platform-native paths: glow, superfile, tlrc, vscode read from
# ~/Library/* on macOS but XDG ~/.config/* on Linux.
case "$(uname -s)" in
    Darwin)
        link ".config/glow/glow.yml"        "$HOME/Library/Preferences/glow/glow.yml"
        link ".config/superfile/config.toml" "$HOME/Library/Application Support/superfile/config.toml"
        link ".config/tlrc/config.toml"     "$HOME/Library/Application Support/tlrc/config.toml"
        link ".config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
        ;;
    Linux)
        link ".config/glow/glow.yml"        "$HOME/.config/glow/glow.yml"
        link ".config/superfile/config.toml" "$HOME/.config/superfile/config.toml"
        link ".config/tlrc/config.toml"     "$HOME/.config/tlrc/config.toml"
        link ".config/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
        ;;
    *)
        echo "Unsupported OS: $(uname -s) — skipping glow/superfile/tlrc/vscode symlinks." >&2
        ;;
esac

echo "✅ Symbolic links created successfully!"
