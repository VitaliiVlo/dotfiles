#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DOTFILES_DIR"

fail=0

heading() { printf '\n=== %s ===\n' "$1"; }
ok()      { printf 'OK %s\n' "$1"; }
bad()     { printf 'FAIL %s\n' "$1"; fail=1; }

# 1. Parse every TOML
heading "TOML"
toml_files=(
    .config/codex/config.toml
    .config/atuin/config.toml
    .config/bottom/bottom.toml
    .config/yazi/yazi.toml
    .config/starship.toml
    .config/tlrc/config.toml
    .config/superfile/config.toml
)
for f in "${toml_files[@]}"; do
    if python3 -c "import tomllib,sys; tomllib.loads(open(sys.argv[1]).read())" "$f" 2>/dev/null; then
        ok "$f"
    else
        bad "$f"
    fi
done

# 2. Parse every plain JSON
heading "JSON"
json_files=(
    .config/claude/settings.json
    .config/micro/settings.json
    .config/ccstatusline/settings.json
)
for f in "${json_files[@]}"; do
    if python3 -c "import json,sys; json.loads(open(sys.argv[1]).read())" "$f" 2>/dev/null; then
        ok "$f"
    else
        bad "$f"
    fi
done

# 3. Parse every YAML
heading "YAML"
yaml_files=(
    .config/gh/config.yml
    .config/lazygit/config.yml
    .config/glow/glow.yml
)
if command -v yq >/dev/null 2>&1; then
    for f in "${yaml_files[@]}"; do
        if yq . "$f" >/dev/null 2>&1; then
            ok "$f"
        else
            bad "$f"
        fi
    done
else
    echo "SKIP (yq not installed)"
fi

# 4. Parse JSONC (Zed + VSCode user settings)
heading "JSONC"
jsonc_files=(
    .config/zed/settings.json
    .config/vscode/settings.json
)
if command -v node >/dev/null 2>&1; then
    for f in "${jsonc_files[@]}"; do
        if node -e "
            const s=require('fs').readFileSync(process.argv[1],'utf8')
                .replace(/\/\*[\s\S]*?\*\//g,'')
                .replace(/(^|[^:])\/\/[^\n]*/g,'\$1')
                .replace(/,(\s*[}\]])/g,'\$1');
            JSON.parse(s);
        " "$f" 2>/dev/null; then
            ok "$f"
        else
            bad "$f"
        fi
    done
else
    echo "SKIP (node not installed)"
fi

# 5. Brewfiles
# `brew bundle list` parses the manifest and lists entries; fails loud on syntax
# errors (catches manifest typos). `brew bundle check` is install-state and
# reported as a non-fatal warning since validate must work on any host.
heading "Brewfiles"
if command -v brew >/dev/null 2>&1; then
    for f in Brewfile Brewfile.work; do
        if brew bundle list --file="$f" >/dev/null 2>&1; then
            ok "$f (parse)"
        else
            bad "$f (parse)"
        fi
    done
    echo "--- install state (non-fatal) ---"
    brew bundle check --file=Brewfile --verbose || true
    brew bundle check --file=Brewfile.work --verbose || true
else
    echo "SKIP (brew not installed)"
fi

# 6. Flatpaks files (format only; install state is OS-dependent)
heading "Flatpaks (format)"
for f in flatpaks flatpaks.work; do
    if grep -vE '^\s*(#|$)' "$f" \
        | awk 'NF && $0 !~ /^[A-Za-z0-9_.-]+$/ {print "BAD ID line " NR ": " $0; bad=1} END {exit bad+0}'; then
        ok "$f"
    else
        bad "$f"
    fi
done

# 7. Ghostty config (parsed by ghostty CLI; flagged kv-pairs would error)
heading "Ghostty"
if command -v ghostty >/dev/null 2>&1; then
    if ghostty +validate-config --config-file=.config/ghostty/config >/dev/null 2>&1; then
        ok ".config/ghostty/config"
    else
        bad ".config/ghostty/config"
    fi
else
    echo "SKIP (ghostty not installed)"
fi

# 8. Lint shell scripts
heading "shellcheck"
if command -v shellcheck >/dev/null 2>&1; then
    if shellcheck scripts/symlinks.sh scripts/macos-defaults.sh scripts/linux-defaults.sh scripts/flatpaks-install.sh scripts/validate.sh; then
        ok "scripts/*.sh"
    else
        bad "scripts/*.sh"
    fi
else
    echo "SKIP (shellcheck not installed)"
fi

# 9. Verify documented symlinks resolve
heading "Symlinks"
common_paths=(
    "$HOME/.zprofile"
    "$HOME/.zshrc"
    "$HOME/.config/git/config"
    "$HOME/.config/git/ignore"
    "$HOME/.config/ripgrep/ripgreprc"
    "$HOME/.config/starship.toml"
    "$HOME/.config/ghostty/config"
    "$HOME/.config/bat/config"
    "$HOME/.config/atuin/config.toml"
    "$HOME/.config/bottom/bottom.toml"
    "$HOME/.config/yazi/yazi.toml"
    "$HOME/.config/lazygit/config.yml"
    "$HOME/.config/gh/config.yml"
    "$HOME/.config/micro/settings.json"
    "$HOME/.config/ccstatusline/settings.json"
    "$HOME/.config/zed/settings.json"
    "$HOME/.claude/settings.json"
    "$HOME/.claude/CLAUDE.md"
    "$HOME/.codex/config.toml"
    "$HOME/.codex/AGENTS.md"
    "$HOME/.codex/rules/git.rules"
    "$HOME/.codex/rules/dev.rules"
    "$HOME/.codex/rules/shell.rules"
    "$HOME/.codex/rules/infra.rules"
)
macos_paths=(
    "$HOME/Library/Application Support/Code/User/settings.json"
    "$HOME/Library/Preferences/glow/glow.yml"
    "$HOME/Library/Application Support/tlrc/config.toml"
    "$HOME/Library/Application Support/superfile/config.toml"
)
linux_paths=(
    "$HOME/.config/glow/glow.yml"
    "$HOME/.config/superfile/config.toml"
    "$HOME/.config/tlrc/config.toml"
    "$HOME/.config/Code/User/settings.json"
)
paths=("${common_paths[@]}")
case "$(uname -s)" in
    Darwin) paths+=("${macos_paths[@]}") ;;
    Linux)  paths+=("${linux_paths[@]}") ;;
esac
for p in "${paths[@]}"; do
    if [[ -L "$p" ]]; then
        ok "$p"
    else
        bad "$p"
    fi
done

heading "Summary"
if [[ "$fail" -eq 0 ]]; then
    echo "All checks passed."
    exit 0
else
    echo "Some checks failed (see FAIL lines above)."
    exit 1
fi
