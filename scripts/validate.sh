#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$DOTFILES_DIR"

fail=0

heading() { printf '\n=== %s ===\n' "$1"; }
ok() { printf 'OK %s\n' "$1"; }
bad() {
    printf 'FAIL %s\n' "$1"
    if [[ $# -ge 2 && -n "$2" ]]; then
        printf '%s\n' "$2" | sed 's/^/  /'
    fi
    fail=1
}

# 1. Parse every TOML
heading "TOML"
toml_files=(
    .config/codex/config.toml
    .config/atuin/config.toml
    .config/yazi/yazi.toml
    .config/starship.toml
    .config/tlrc/config.toml
    .config/superfile/config.toml
    .local.example.toml
    defaults/starship-nerd-font-symbols.toml
    defaults/atuin-defaults.toml
    defaults/yazi-defaults.toml
    defaults/superfile-defaults.toml
)
if [[ -f .local/source.toml ]]; then
    toml_files+=(.local/source.toml)
fi
if python3 -c "import tomllib" >/dev/null 2>&1; then
    for f in "${toml_files[@]}"; do
        if out=$(python3 -c "import tomllib,sys; tomllib.loads(open(sys.argv[1]).read())" "$f" 2>&1); then
            ok "$f"
        else
            bad "$f" "$out"
        fi
    done
else
    echo "SKIP (needs python3 3.11+ for stdlib tomllib)"
fi

# 2. Parse every plain JSON
heading "JSON"
json_files=(
    .config/claude/settings.json
    .config/micro/settings.json
    .config/ccstatusline/settings.json
)
for f in "${json_files[@]}"; do
    if out=$(python3 -c "import json,sys; json.loads(open(sys.argv[1]).read())" "$f" 2>&1); then
        ok "$f"
    else
        bad "$f" "$out"
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
        if out=$(yq . "$f" 2>&1 >/dev/null); then
            ok "$f"
        else
            bad "$f" "$out"
        fi
    done
else
    echo "SKIP (yq not installed)"
fi

# 4. Parse JSONC (Zed + VSCodium user settings). Strip comments with a
# string-aware walker, not a regex: `//` and `/* */` inside JSON string
# values must survive, otherwise the parse silently corrupts the file.
# The trailing-comma strip below is a plain regex, not string-aware, so it can
# also rewrite a `,]`/`,}` inside a string value. Harmless: the result only
# feeds JSON.parse for validation and is never written back, and removing a
# comma inside a quoted string leaves it a valid string, so the parse can't be
# corrupted or give a false result.
heading "JSONC"
jsonc_files=(
    .config/zed/settings.json
    .config/vscodium/settings.json
    defaults/vscodium-defaults.jsonc
    defaults/zed-defaults.jsonc
)
if command -v node >/dev/null 2>&1; then
    for f in "${jsonc_files[@]}"; do
        if out=$(node -e "
            const raw = require('fs').readFileSync(process.argv[1], 'utf8');
            let out = '', i = 0, inStr = false, esc = false;
            while (i < raw.length) {
                const c = raw[i], n = raw[i + 1];
                if (inStr) {
                    out += c;
                    if (esc) esc = false;
                    else if (c === '\\\\') esc = true;
                    else if (c === '\"') inStr = false;
                    i++;
                } else if (c === '\"') {
                    inStr = true; out += c; i++;
                } else if (c === '/' && n === '/') {
                    while (i < raw.length && raw[i] !== '\n') i++;
                } else if (c === '/' && n === '*') {
                    i += 2;
                    while (i < raw.length && !(raw[i] === '*' && raw[i + 1] === '/')) i++;
                    if (i >= raw.length) throw new Error('unterminated /* */ block');
                    i += 2;
                } else {
                    out += c; i++;
                }
            }
            JSON.parse(out.replace(/,(\s*[}\]])/g, '\$1'));
        " "$f" 2>&1); then
            ok "$f"
        else
            bad "$f" "$out"
        fi
    done
else
    echo "SKIP (node not installed)"
fi

# defaults/bat-defaults.conf and defaults/ghostty-defaults.conf are intentionally
# not parse-checked: both are annotated all-comment dumps that no validator accepts
# (bat-defaults is all `#` lines; ghostty-defaults is a +show-config --docs dump).

# 5. Brewfiles
# `brew bundle list --all` parses the manifest and lists every entry type
# (brew, cask, tap, vscode, mas, go, uv, npm); fails loud on syntax errors
# (catches manifest typos). Without --all only `brew "..."` lines enumerate,
# but parser still rejects bad syntax. `brew bundle check` is install-state
# and reported as a non-fatal warning since validate must work on any host.
heading "Brewfiles"
if command -v brew >/dev/null 2>&1; then
    for f in Brewfile Brewfile.work; do
        if out=$(brew bundle list --file="$f" --all 2>&1 >/dev/null); then
            ok "$f (parse)"
        else
            bad "$f (parse)" "$out"
        fi
    done
    echo "--- install state (non-fatal) ---"
    brew bundle check --file=Brewfile --verbose || true
    brew bundle check --file=Brewfile.work --verbose || true
else
    echo "SKIP (brew not installed)"
fi

# 6. Ghostty config (parsed by ghostty CLI; flagged kv-pairs would error)
heading "Ghostty"
if command -v ghostty >/dev/null 2>&1; then
    if out=$(ghostty +validate-config --config-file=.config/ghostty/config 2>&1); then
        ok ".config/ghostty/config"
    else
        bad ".config/ghostty/config" "$out"
    fi
else
    echo "SKIP (ghostty not installed)"
fi

# 7. Lint shell scripts
heading "shellcheck"
if command -v shellcheck >/dev/null 2>&1; then
    if out=$(shellcheck scripts/*.sh 2>&1); then
        ok "scripts/*.sh"
    else
        bad "scripts/*.sh" "$out"
    fi
else
    echo "SKIP (shellcheck not installed)"
fi

# 7b. Format-check shell scripts. Repo style: 4-space indent (-i 4), case branches
# indented (-ci), and column-aligned trailing tokens preserved (-kp). shfmt
# defaults to tabs and collapses padding, so all three flags must stay pinned.
heading "shfmt"
if command -v shfmt >/dev/null 2>&1; then
    if out=$(shfmt -d -i 4 -ci -kp scripts/*.sh 2>&1); then
        ok "scripts/*.sh"
    else
        bad "scripts/*.sh" "$out"
    fi
else
    echo "SKIP (shfmt not installed)"
fi

# 7b2. Python syntax-check on scripts/local-overrides.py. shellcheck/shfmt skip
# Python; ast.parse catches syntax errors before `make setup` runs the script.
# Using ast.parse (not py_compile) avoids creating scripts/__pycache__/.
heading "python syntax"
if out=$(python3 -c "import ast,sys; ast.parse(open(sys.argv[1]).read())" scripts/local-overrides.py 2>&1); then
    ok "scripts/local-overrides.py"
else
    bad "scripts/local-overrides.py" "$out"
fi

# 7c. zsh syntax-check on .zshrc / .zprofile. shellcheck/shfmt do not parse zsh,
# so only `zsh -n` catches typos before next shell launch.
heading "zsh -n"
if command -v zsh >/dev/null 2>&1; then
    for f in .zshrc .zprofile; do
        if out=$(zsh -n "$f" 2>&1); then
            ok "$f"
        else
            bad "$f" "$out"
        fi
    done
else
    echo "SKIP (zsh not installed)"
fi

# 7d. Codex rule files use a custom DSL with no upstream validator. The most we
# can check is that every non-comment, non-blank line begins with prefix_rule(.
heading "Codex rules"
for f in .config/codex/rules/*.rules; do
    [[ -e "$f" ]] || continue
    bad_lines=$(grep -Ev '^\s*(#|$)' "$f" | grep -vE '^prefix_rule\(' || true)
    if [[ -n "$bad_lines" ]]; then
        bad "$f (bad line)" "$bad_lines"
    else
        ok "$f"
    fi
done

# 7e. Git config: `git config --list` parses the INI and errors on syntax bugs.
heading "git config"
if command -v git >/dev/null 2>&1; then
    f=.config/git/config
    if out=$(git config --file="$f" --list 2>&1 >/dev/null); then
        ok "$f"
    else
        bad "$f" "$out"
    fi
else
    echo "SKIP (git not installed)"
fi

# 7f. CLI flag configs (bat, ripgrep): bat/rg silently ignore unknown flags, so
# the only catchable bug is a non-comment line that doesn't start with `--`.
heading "CLI flag configs"
for f in .config/bat/config .config/ripgrep/ripgreprc; do
    bad_lines=$(grep -Ev '^\s*(#|$)' "$f" | grep -vE '^--' || true)
    if [[ -n "$bad_lines" ]]; then
        bad "$f (line not starting with --)" "$bad_lines"
    else
        ok "$f"
    fi
done

# 7g. btop config: btop silently falls back to defaults on unknown keys, so
# the only catchable bug is a non-comment line without `=`.
heading "btop config"
f=.config/btop/btop.conf
bad_lines=$(grep -Ev '^\s*(#|$)' "$f" | grep -vE '=' || true)
if [[ -n "$bad_lines" ]]; then
    bad "$f (line without =)" "$bad_lines"
else
    ok "$f"
fi

# 8. Verify documented symlinks resolve
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
    "$HOME/.config/btop/btop.conf"
    "$HOME/.config/btop/themes/catppuccin_macchiato.theme"
    "$HOME/.config/btop/themes/catppuccin_frappe.theme"
    "$HOME/.config/btop/themes/catppuccin_latte.theme"
    "$HOME/.config/btop/themes/catppuccin_mocha.theme"
    "$HOME/.config/atuin/config.toml"
    "$HOME/.config/glow/glow.yml"
    "$HOME/.config/superfile/config.toml"
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
    "$HOME/Library/Application Support/VSCodium/User/settings.json"
    "$HOME/Library/Application Support/tlrc/config.toml"
)
linux_paths=(
    "$HOME/.config/tlrc/config.toml"
    "$HOME/.config/VSCodium/User/settings.json"
)
paths=("${common_paths[@]}")
case "$(uname -s)" in
    Darwin) paths+=("${macos_paths[@]}") ;;
    Linux) paths+=("${linux_paths[@]}") ;;
    *) echo "SKIP tlrc/vscodium symlinks on $(uname -s) (repo scope is macOS + Linux)" ;;
esac
for p in "${paths[@]}"; do
    if [[ -L "$p" && -e "$p" ]]; then
        ok "$p"
    elif [[ -L "$p" ]]; then
        bad "$p (dangling symlink, target missing; run make symlinks)"
    elif [[ -e "$p" ]]; then
        bad "$p (not a symlink, regular file shadowing; delete it then run make symlinks)"
    else
        bad "$p (missing; run make symlinks)"
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
