# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

macOS dotfiles repository for setting up a development environment. All configs use **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme where supported, **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go 1.26** (via Homebrew), **Python** (via `uv`), and **Node.js** (via `fnm`).

## Key Commands

```bash
make setup              # Base setup: configure macOS, symlink configs, install base packages, show versions
make setup-all          # Full setup: base setup + work packages
make link               # Symlink configs to home directory
make defaults           # Configure macOS defaults: folders, system, screenshots, Finder, Dock
make versions           # Show installed Go, Node, Python versions
make brew-install       # Install all packages (base + work)
make brew-install-base  # Install base packages only
make brew-install-work  # Install work packages only
make brew-cleanup       # Clean up old versions and cache
make brew-export        # Export installed packages (incl. VSCode extensions) to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually
make flatpaks-install        # Install all flatpaks (base + work); Linux only, no-op on macOS
make flatpaks-install-base   # Install base flatpaks only
make flatpaks-install-work   # Install work flatpaks only
make flatpaks-export         # Export installed user flatpaks to flatpaks, then strip flatpaks.work entries; add new work entries to flatpaks.work manually
```

## Repository Structure

- `scripts/link.sh` - Creates symlinks (uses `set -euo pipefail`)
- `scripts/macos-defaults.sh` - macOS defaults via `defaults write` (non-interactive, idempotent)
- `scripts/flatpaks-install.sh` - Installs Flathub apps at user scope from `flatpaks` / `flatpaks.work` (Linux only, no-op on macOS, adds flathub user remote on first run)
- `Makefile` - Task runner targets (`make help` for list)
- `Brewfile` - Base packages: shell essentials, fonts, daily-driver apps, VSCode extensions
- `Brewfile.work` - Work packages: work-specific GUIs — API client, K8s GUI, DB GUI, container runtime, comms, VPN (curated manually)
- `flatpaks` - Base Flathub app IDs for Linux, bare one-per-line (no comments — `make flatpaks-export` would wipe them; see "Flatpaks maintenance" below). Paired with `Brewfile` casks where a Flathub equivalent exists; see README "Flatpaks" section for cross-ref table.
- `flatpaks.work` - Work Flathub app IDs for Linux (paired with `Brewfile.work` casks; curated manually, same bare-line format as `flatpaks`)
- `.zshrc` / `.zprofile` - Zsh config (starship prompt, fnm, uv, fzf with bat preview, eza aliases, syntax-highlighting, autosuggestions)
- `.config/git/config` / `.config/git/ignore` - Git settings (delta pager, rebase workflow, SSH for GitHub, zdiff3 conflicts, rerere, git-lfs filters) — XDG path
- `.config/ripgrep/ripgreprc` - Ripgrep defaults (smart-case, hidden files, follow symlinks); resolved via `RIPGREP_CONFIG_PATH`
- `.config/ghostty/config` - Terminal emulator
- `.config/starship/starship.toml` - Shell prompt (nerd-font-symbols preset)
- `.config/bat/config` - Cat replacement with syntax highlighting
- `.config/gh/config.yml` - GitHub CLI settings (SSH protocol, delta pager)
- `.config/lazygit/config.yml` - Git TUI (nerd fonts, delta pager, vscode editor)
- `.config/micro/settings.json` - Terminal text editor
- `.config/yazi/yazi.toml` - Terminal file manager settings
- `.config/atuin/config.toml` - Atuin shell history (filter parity with `hist_ignore_space`)
- `.config/bottom/bottom.toml` - Bottom (`btm`) system monitor (tree view + command column + battery, cache memory shown, unnormalized per-core CPU, byte/binary network units, table scroll position)
- `.config/glow/glow.yml` - Glow Markdown renderer (auto theme, pager on, line numbers in TUI)
- `.config/tlrc/config.toml` - tlrc (tldr client) — show platform title, short+long flags (macOS-native path)
- `.config/superfile/config.toml` - Superfile (`spf`) terminal file manager (Catppuccin Macchiato, bat preview with border, binary file sizes, zoxide integration; macOS-native path)
- `.config/vscode/settings.json` - VSCode settings (JSONC format with comments)
- `.config/vscode/defaultSettings.jsonc` - VSCode defaults reference (for comparing settings)
- `.config/zed/settings.json` - Zed editor (Catppuccin Macchiato/Latte, JetBrains Mono, same UX as VSCode, auto_install_extensions)
- `.config/claude/CLAUDE.md` - Claude Code user-level instructions (symlinked to `~/.claude/CLAUDE.md`)
- `.config/claude/settings.json` - Claude Code permissions (web, git, docker, build tools, sensitive file protection)
- `.config/ccstatusline/settings.json` - Claude Code status line layout (via ccstatusline)
- `.config/codex/AGENTS.md` - Codex user-level instructions (symlinked to `~/.codex/AGENTS.md`)
- `.config/codex/config.toml` - Codex CLI config (model, sandbox, profiles, plugins)
- `.config/codex/rules/` - Codex permission rules: `git`, `dev`, `shell`, `infra` (symlinked to `~/.codex/rules/`)

Templates (not symlinked, import or copy as needed):

- `templates/bookmarks.html` - Netscape bookmark template (universal URLs only: GitHub `/pulls/*`, AI chats, web tools). One-shot import per project; rename `<Employer>` / `<Project>` folders after import.

## When Adding a New Tool/Config (Doc Drift Checklist)

When adding a new tool, config file, cask, or formula, update all of these in lockstep — missing any one causes documentation drift:

- **Install** — add line to `Brewfile` or `Brewfile.work` (tap, cask, brew, vscode, go, uv, etc.)
- **Linux equivalent** — when adding a `cask`, classify and document. Inspect the cask `.rb` source first (`brew info --json=v2 --cask <name>` for `ruby_source_path`, then fetch from `https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/<path>`):
  - **Linux-installable via brew** — `.rb` declares `os macos: ..., linux: ...` block with `x86_64_linux`/`arm64_linux` sha256 entries AND uses `binary` artifact, OR uses `font` artifact with no `depends_on macos:`. These install on Linuxbrew via `brew install --cask <name>`. Add row to README "Linux-installable casks" table under `## Casks`. No Flathub pairing needed.
  - **GUI app with Flathub equivalent** — add paired Flathub ID to `flatpaks` or `flatpaks.work` (verify via `curl -sI https://flathub.org/api/v2/appstream/<id>` returns 200), and add row to README "Flatpaks" Base/Work table.
  - **GUI app not on Flathub** — add cask name to README "macOS-only → GUI apps not on Flathub" sub-list under `## Flatpaks`.
  - **CLI tool, macOS-only** — `pkg`/`installer` artifact, or `binary` without linux sha256. Add to README "macOS-only → CLI tools" sub-list (e.g. `cloudflare-warp`).
  - **macOS-system tool** (e.g. `rectangle`, `maccy`, no Linux concept) — add cask name to README "macOS-only → macOS-system tools" sub-list.
  - Every cask in `Brewfile` / `Brewfile.work` must appear in exactly one of: Linux-installable casks table, Flatpaks Base/Work table, or one of the three macOS-only sub-lists.
- **Symlink** — add `mkdir -p` + `ln -sf` block to `scripts/link.sh` if the tool reads a config file from a fixed path
- **README "Configuration Files" list** — add bullet under `## Configuration Files` if a config file is symlinked
- **README "CLI Tools" or "Casks" table** — add row if user-facing CLI/GUI tool
- **README "Flatpaks" tables** — add row to Base or Work Flatpaks table if Flathub equivalent paired
- **README "Applications" table** — add row if GUI app fits an existing category, or add new category row
- **CLAUDE.md "Repository Structure" list** — add bullet describing the file's purpose
- **CLAUDE.md "Cross-Config Consistency Rules" tables** — add row(s) if the tool shares behavior (theme, font, tab size, hidden files, telemetry, auto-update, git pager, etc.) with existing tools
- **CLAUDE.md "Config Validation" block** — add a one-liner that round-trips/parses the new config

When removing a tool, sweep the same list in reverse.

## Comment Style in Configs

When adding or editing config files, follow this style across all of them:

- **Drop top-of-file banners** — filename already states the file's purpose (no `# .zshrc - Interactive shell config` headers). Exception: location/operational notes for tools that ignore XDG and require non-obvious symlink targets (e.g. macOS `Library/Preferences/...`, `Library/Application Support/...`) are allowed since the symlink destination is not derivable from the filename.
- **Keep group dividers** — short single-line headers (`# Theme`, `# Cursor`, `# Git`) make long configs scannable. Use the same divider style as surrounding files (e.g. `// Name` in JSONC, `# Name` in TOML/conf, `# Name` shell).
- **Keep non-obvious why-comments** — workarounds, ordering constraints, parity with another tool, hidden invariants. Lead with the reason, not the restatement.
- **Drop tautology** — `# Enable completion` above `compinit`, `# Aliases` above an alias block where every line is `alias x=...` is fluff.
- **JSONC comment style** — use `// Name` (single-line) for section dividers in `.config/vscode/settings.json` and `.config/zed/settings.json`. Do not use `/* Name */` block-style.
- **Trim verbose schema docs** — when a tool emits its config with full per-key docstrings (e.g. `gh config init`), strip them; keys are self-documenting.
- **Plain JSON files (no comments allowed)** — micro's `settings.json` is parsed by Go's strict `encoding/json`, which rejects `//` and `/* */`. Use **blank lines** between key clusters for visual grouping; document the cluster meaning in this file. Current micro grouping: `tabsize`/`tabstospaces`/`autoindent`/`smartpaste` (indentation) → `rmtrailingws`/`eofnewline`/`fileformat` (whitespace & save) → `syntax`/`cursorline`/`matchbrace`/`colorcolumn`/`scrollbar`/`scrollmargin`/`diffgutter`/`basename`/`hlsearch`/`savecursor`/`wordwrap` (display) → `encoding`/`truecolor` (encoding).

## Script Behavior

**scripts/link.sh:**

- Uses `ln -sf` (force symlink) - overwrites existing files
- Creates parent directories as needed for nested configs
- `DOTFILES_DIR` resolves to repo root via `cd "$(dirname "$0")/.." && pwd` (script lives one level deep in `scripts/`)
- Repo holds all source-of-truth configs under `.config/<tool>/`. Tools that ignore XDG on macOS are linked into native paths inside `scripts/link.sh`:
  - glow → `~/Library/Preferences/glow/`
  - superfile → `~/Library/Application Support/superfile/`
  - tlrc → `~/Library/Application Support/tlrc/`
  - VSCode → `~/Library/Application Support/Code/User/`
- Symlinks grouped by category (in this order): Shell → Shell tools (history/pager/system monitor/terminal/search/prompt) → Git/file tools → Editors → macOS-native paths → AI agents. Within each group, tools are alphabetized. Add new symlinks under the matching group in alpha order.

**scripts/macos-defaults.sh:**

- Non-interactive: applies all categories unconditionally (Folders, System defaults, Screenshots, Finder, Dock)
- Restarts affected processes (Finder, Dock, SystemUIServer)
- Safe to re-run: idempotent `mkdir -p` and `defaults write` commands

**scripts/flatpaks-install.sh:**

- Linux only. On any non-Linux host: prints a skip message and exits 0 (Makefile targets remain safe to invoke on macOS)
- Requires `flatpak` binary (install via `brew install flatpak` on Linux)
- User scope only (`--user`): writes to `~/.local/share/flatpak`, no sudo
- Adds `flathub` as user remote on first run (`flatpak remote-add --user --if-not-exists`)
- Idempotent: uses `--noninteractive --or-update`, so repeated runs upgrade existing apps
- Accepts an optional file path arg (default `flatpaks`); strips `#` comments and blank lines before invoking `flatpak install`
- Scope decision rationale: see "Plain flatpaks vs Brewfile flatpak keyword" below

## Shell Aliases

Defined in `.zshrc`:

| Alias    | Command                                |
| -------- | -------------------------------------- |
| `kk`     | `kubectl`                              |
| `kctx`   | `kubectl config current-context`       |
| `lzg`    | `lazygit`                              |
| `c`      | `clear`                                |
| `cat`    | `bat` (if installed)                   |
| `ls`     | `eza --icons=auto --group-directories-first`        |
| `ll`     | `eza` with git, timestamps, headers    |
| `lt`     | `eza` tree view (2 levels)             |
| `lr`     | `eza` sorted by modified (recent first) |

## Shell Tool Integration

fd and ripgrep share consistent defaults for daily use:

| Behavior        | fd                                                       | ripgrep        |
| --------------- | -------------------------------------------------------- | -------------- |
| Hidden files    | `--hidden`                                               | `--hidden`     |
| Follow symlinks | `--follow`                                               | `--follow`     |
| Exclusions      | `.git`, `node_modules`, `.venv`, `venv`, `__pycache__`, `.pytest_cache`, `.terraform`, `vendor`, `dist`, `build`, `coverage` | Same |
| Config location | Alias in `.zshrc` (no config file support)               | `~/.config/ripgrep/ripgreprc` (`RIPGREP_CONFIG_PATH`) |

fzf uses fd when available for faster fuzzy finding with bat preview:

- `Ctrl+T` - File search with bat preview
- `Alt+C` - Directory search with eza tree preview

atuin owns `Ctrl+R` and Up arrow (loaded after fzf in `.zshrc`) for synced shell history search via TUI.

zoxide provides smart directory jumping via `z` command (learns from `cd` usage).

fnm (Fast Node Manager) auto-switches Node versions via `.node-version` or `.nvmrc` when entering a directory (`--use-on-cd`).

uv manages Python versions and project dependencies. System `python3` comes from Xcode CLT or brew; `uv` handles per-project venvs and global CLI tools (`uv tool install`). Shell completions are loaded in `.zshrc`.

git-delta is configured as the git pager (`.config/git/config`) with Catppuccin Macchiato syntax theme. It uses bat's theme engine — the theme is available because bat has it installed.

`.zshrc` load order is intentional: history/options → aliases → fd/eza shared opts → completions → autosuggestions → fzf → fnm → uv → zoxide → starship → atuin (after fzf, so it owns `Ctrl+R`/Up) → zsh-syntax-highlighting (must be last per upstream docs). Do not reorder — atuin and syntax-highlighting are load-order-sensitive.

## Git Aliases

Defined in `.config/git/config`:

| Alias  | Command                            |
| ------ | ---------------------------------- |
| `st`   | `status`                           |
| `df`   | `diff`                             |
| `dfs`  | `diff --staged`                    |
| `dfw`  | `diff --word-diff`                 |
| `dfws` | `diff --staged --word-diff`        |
| `cm`   | `commit -m`                        |
| `ca`   | `commit --amend --no-edit`         |
| `lg`   | `log --oneline --graph --decorate` |
| `undo` | `reset --soft HEAD~1`              |
| `wipe` | `reset --hard HEAD`                |

## Config Validation

**Spot checks (per-tool):**

```bash
ghostty +show-config --default --docs      # Should show parsed config, no errors
ghostty +show-config                        # Should round-trip current config, exit 0
bat --list-themes | grep -i catppuccin     # Should show "Catppuccin Macchiato"
delta --list-syntax-themes | grep -i catppuccin  # Should show Catppuccin themes
btm --version                               # Should show version
glow --version                              # Should show version (config at Library/Preferences/glow/glow.yml)
atuin doctor                                # Should show config + DB ok
tldr --config-path                          # Should print Library/Application Support/tlrc/config.toml
tldr --info                                 # Should show cache age + language
starship config                             # Should show TOML config
git config --list --show-origin             # Should show ~/.config/git/config as source
fnm list                                    # Should show installed Node versions
uv python list --only-installed             # Should show installed Python versions
```

**Full audit (run everything):**

```bash
# 1. Parse every TOML
for f in .config/codex/config.toml .config/atuin/config.toml .config/bottom/bottom.toml \
         .config/yazi/yazi.toml .config/starship/starship.toml .config/tlrc/config.toml \
         .config/superfile/config.toml; do
  python3 -c "import tomllib,sys; tomllib.loads(open(sys.argv[1]).read()); print('OK', sys.argv[1])" "$f"
done

# 2. Parse every plain JSON
for f in .config/claude/settings.json .config/micro/settings.json .config/ccstatusline/settings.json; do
  python3 -c "import json,sys; json.loads(open(sys.argv[1]).read()); print('OK', sys.argv[1])" "$f"
done

# 3. Parse every YAML
for f in .config/gh/config.yml .config/lazygit/config.yml .config/glow/glow.yml; do
  yq . "$f" >/dev/null && echo "OK $f"
done

# 4. Parse JSONC (Zed + VSCode user settings)
for f in .config/zed/settings.json .config/vscode/settings.json; do
  node -e "
    const s=require('fs').readFileSync(process.argv[1],'utf8')
      .replace(/\/\*[\s\S]*?\*\//g,'')
      .replace(/(^|[^:])\/\/[^\n]*/g,'\$1')
      .replace(/,(\s*[}\]])/g,'\$1');
    JSON.parse(s); console.log('OK', process.argv[1]);
  " "$f"
done

# 5. Brewfiles — verify all listed packages installable/installed
brew bundle check --file=Brewfile --verbose
brew bundle check --file=Brewfile.work --verbose

# 6. Flatpaks files — sanity parse (Linux-only check; on mac just verify format)
for f in flatpaks flatpaks.work; do
  grep -vE '^\s*(#|$)' "$f" | awk 'NF && $0 !~ /^[A-Za-z0-9_.-]+$/ {print "BAD ID line " NR ": " $0; bad=1} END {exit bad+0}' \
    && echo "OK $f"
done

# 7. Lint shell scripts (shfmt available for formatting new scripts ad-hoc;
#    not enforced here because scripts/macos-defaults.sh uses intentional column alignment)
shellcheck scripts/link.sh scripts/macos-defaults.sh scripts/flatpaks-install.sh

# 8. Verify every documented symlink resolves to repo
for p in ~/.zprofile ~/.zshrc ~/.config/git/config ~/.config/git/ignore \
         ~/.config/ripgrep/ripgreprc ~/.config/starship.toml \
         ~/.config/ghostty/config ~/.config/bat/config ~/.config/atuin/config.toml \
         ~/.config/bottom/bottom.toml ~/.config/yazi/yazi.toml \
         ~/.config/lazygit/config.yml ~/.config/gh/config.yml \
         ~/.config/micro/settings.json ~/.config/ccstatusline/settings.json \
         ~/.config/zed/settings.json ~/.claude/settings.json ~/.claude/CLAUDE.md \
         ~/.codex/config.toml ~/.codex/AGENTS.md ~/.codex/rules/git.rules \
         ~/.codex/rules/dev.rules ~/.codex/rules/shell.rules ~/.codex/rules/infra.rules \
         "$HOME/Library/Application Support/Code/User/settings.json" \
         "$HOME/Library/Preferences/glow/glow.yml" \
         "$HOME/Library/Application Support/tlrc/config.toml" \
         "$HOME/Library/Application Support/superfile/config.toml"; do
  [[ -L "$p" ]] && echo "OK $p" || echo "MISSING $p"
done
```

**Web verification rule:** when a config key looks suspect (unfamiliar value, version-specific), confirm against the tool's official docs before flagging it as invalid. Examples that look wrong but are valid: Codex `model = "gpt-5.5"`/`gpt-5.4`/`gpt-5.4-mini`, Codex `personality = "friendly"`, Codex `[features].fast_mode`/`prevent_idle_sleep`, Codex `commit_attribution`, Claude `effortLevel = "xhigh"`, Claude `model = "opus[1m]"`, atuin `inline_height_shell_up_key_binding`, atuin `enter_accept = false` (intentional default-flip: Enter selects/edits, doesn't auto-execute), ghostty `cursor-opacity`/`adjust-cursor-thickness`. All confirmed valid via vendor docs.

## VSCode Settings

When modifying `.config/vscode/settings.json`:

- Compare against `defaultSettings.jsonc` to check if a setting matches the default (keep explicit defaults — intentional)
- Settings use JSONC format (JSON with comments and trailing commas allowed)
- Section dividers use `// Name` (single-line) for parity with `.config/zed/settings.json`; do not use `/* Name */` block-style
- Section order: Theme → Workbench → Window → Font & Indentation → Cursor & Scrolling → Editor UX → Inline diagnostics (ErrorLens) → IntelliSense → Formatting → Search → Files → Terminal → Git → Testing & Debug → JavaScript/TypeScript → Python → Go tooling → AI → Updates → Telemetry → Liveshare → Clipboard manager
- Configured for Go, Python, and Node.js backend development
- Uses Ruff for Python formatting/linting

**Layout (settings.json):**

- `window.commandCenter`: false (no project name in title bar)
- `workbench.navigationControl.enabled`: false (no back/forward buttons)
- `workbench.layoutControl.type`: "menu" (dropdown instead of toggles)
- `workbench.activityBar.location`: bottom (compact, under primary side bar)
- `workbench.secondarySideBar.defaultVisibility`: "hidden" (toggle with `Cmd+Option+B` on demand)

**Layout (UI only, View → Appearance / Customize Layout):**

- Quick input position: center
- Panel alignment: justify (full window width)
- Secondary side bar: right (`Cmd+Option+B`)

## Applications List Maintenance

When updating the Applications table in README.md, see the selection criteria documented there. Key guidelines:

- Tools in **bold** are primary recommendations (one per category)
- GUI apps go in Applications section, text-based/TUI tools go in CLI Tools section
- Include 3-5 apps per category when possible
- Verify apps are actively maintained before adding
- Research community sentiment (Reddit, GitHub issues, HN) before adding new tools

## Cross-Config Consistency Rules

When modifying any config file, ensure these values stay consistent across all tools:

| Setting | VSCode | Zed | Micro | Ghostty | Bat | Delta | Yazi |
|---|---|---|---|---|---|---|---|
| Tab size | `editor.tabSize: 4` | `tab_size: 4` | `tabsize: 4` | — | `--tabs=4` | `tabs = 4` | `tab_size = 4` |
| Spaces (not tabs) | `editor.insertSpaces: true` | `hard_tabs: false` | `tabstospaces: true` | — | — | — | — |
| Final newline | `files.insertFinalNewline: true` | `ensure_final_newline_on_save: true` | `eofnewline: true` | — | — | — | — |
| Trim trailing WS | `files.trimTrailingWhitespace: true` | `remove_trailing_whitespace_on_save: true` | `rmtrailingws: true` | — | — | — | — |
| EOL | `files.eol: "\n"` | (default LF on macOS) | `fileformat: "unix"` | — | — | — | — |
| Word wrap | `editor.wordWrap: "off"` | `soft_wrap: "none"` | `wordwrap: false` | — | — | — | `wrap = "no"` |
| Scroll margin | `editor.cursorSurroundingLines: 3` | `vertical_scroll_margin: 3` | `scrollmargin: 3` | — | — | — | `scrolloff = 3` |
| Line height | `editor.lineHeight: 1.5` | `buffer_line_height: "comfortable"` (1.618) | — | — | — | — | — |
| Cursor | `cursorStyle: "line"`, width 2 | `cursor_shape: "bar"` (buffer + terminal) | — | `cursor-style = bar`, thickness 2 | — | — | — |
| Cursor blink | `cursorBlinking: "smooth"` | `cursor_blink: true`, terminal: `blinking: "on"` | — | `cursor-style-blink = true` | — | — | — |
| Font | JetBrains Mono 14pt + fallbacks (editor + terminal) | Same chain (buffer + terminal) | (terminal font) | Same chain | — | — | — |
| Ligatures | `editor.fontLigatures: true` | `buffer_font_features: null` (all on) | — | (default: on) | — | — | — |
| Theme (dark) | Catppuccin Macchiato | Catppuccin Macchiato | — | Catppuccin Macchiato | Catppuccin Macchiato | Catppuccin Macchiato | — |
| Theme (light) | Catppuccin Latte | Catppuccin Latte | — | Catppuccin Latte | Catppuccin Latte | — | — |
| Indent guides | `guides.indentation: true` | `indent_guides.enabled: true` | — | — | — | — | — |
| Bold = bright | — | — | — | `bold-color = bright` | — | — | — |
| Minimap | `minimap.enabled: false` | `minimap.show: "never"` | — | — | — | — | — |
| Rulers/Guides | `rulers: [120]` | `wrap_guides: [120]` | `colorcolumn: 120` | — | — | — | — |
| Sticky scroll | `stickyScroll.enabled: true` | `sticky_scroll.enabled: true` | — | — | — | — | — |
| Bracket colors | `bracketPairColorization.enabled: true` | `colorize_brackets: true` | `matchbrace: true` | — | — | — | — |
| Linked editing | `linkedEditing: true` | `linked_edits: true` | — | — | — | — | — |
| Whitespace | `renderWhitespace: "selection"` | `show_whitespaces: "selection"` | — | — | — | — | — |
| Line highlight | `renderLineHighlight: "all"` | `current_line_highlight: "all"` | `cursorline: true` | — | — | — | — |
| Semantic tokens | `semanticHighlighting.enabled: true` | `semantic_tokens: "combined"` | — | — | — | — | — |
| Hover delay | `editor.hover.delay: 200` | `hover_popover_delay: 200` | — | — | — | — | — |
| Option as Meta | `terminal.macOptionIsMeta: true` | `terminal.option_as_meta: true` | — | `macos-option-as-alt = true` | — | — | — |
| Git protocol | `github.gitProtocol: "ssh"` | — | — | — | — | — | — |
| Git pager | — | — | — | — | — | `pager = delta` | — |
| Git blame | `git.blame.editorDecoration.enabled` + `git.blame.statusBarItem.enabled` (author+date) | `inline_blame.enabled: true`, `show_commit_summary: false` | — | — | — | — | — |
| Show hidden | — | — | — | — | — | — | `show_hidden = true` |
| Follow symlinks | `search.followSymlinks: true` | — | — | — | — | — | — |
| Nerd fonts | Font fallback chain | Font fallback chain | — | Font fallback chain | — | — | — |
| Icons | `workbench.iconTheme` | `icon_theme` | — | — | — | — | (auto-detected) |
| Format on save | `editor.formatOnSave: true` | `format_on_save: "on"` | — | — | — | — | — |
| Auto save | `files.autoSave: "off"` | `autosave: "off"` | — | — | — | — | — |
| Detect indent | `editor.detectIndentation: true` | (default: true) | — | — | — | — | — |
| Auto indent on paste | `editor.autoIndentOnPaste: true` | `auto_indent_on_paste: true` | `smartpaste: true` | — | — | — | — |
| Inlay hints | `editor.inlayHints (enabled)` | `inlay_hints.enabled: true` | — | — | — | — | — |
| Close on file delete | `closeOnFileDelete: true` | `close_on_file_delete: true` | — | — | — | — | — |
| Auto-close brackets | `autoClosingBrackets: "languageDefined"` | `use_autoclose: true` | — | — | — | — | — |
| Completions on input | `editor.quickSuggestions: "on"` | `show_completions_on_input: true` | — | — | — | — | — |
| Syntax highlighting | — | — | `syntax: true` | — | — | — | — |
| Encoding | — | — | `encoding: "utf-8"` | — | — | — | — |
| Truecolor | — | — | `truecolor: "auto"` | — | — | — | — |
| Param hints | `parameterHints.enabled: true` | `auto_signature_help: true` | — | — | — | — | — |
| Completion docs | `editor.suggest.preview: true` | `show_completion_documentation: true` | — | — | — | — | — |
| Git gutter | (default: on) | `git.git_gutter: "tracked_files"` | `diffgutter: true` | — | `--style=changes` | — | — |
| Diff ignore WS | `diffEditor.ignoreTrimWhitespace: false` | — | — | — | — | (default: show) | — |
| Trim final NLs | `files.trimFinalNewlines: true` | (no equivalent — gap) | — | — | — | — | — |
| Auto indent | `editor.autoIndent: "full"` | (default: on) | `autoindent: true` | — | — | — | — |
| Format on paste | `editor.formatOnPaste: true` | — | `smartpaste: true` | — | — | — | — |
| Smart case search | — | `use_smartcase_search: true` | — | — | — | — | — |
| Dirs first | — | — | — | — | — | — | `sort_dir_first = true` |
| Inline diagnostics | ErrorLens extension | `diagnostics.inline.enabled: true` | — | — | — | — | — |
| Theme detection | `autoDetectColorScheme: true` | `theme.mode: "system"` | — | — | — | — | — |

**Telemetry** — minimize across all tools:

| Tool | Setting | Value |
|---|---|---|
| VSCode | `telemetry.telemetryLevel` | `"crash"` |
| VSCode | `redhat.telemetry.enabled` | `false` |
| Zed | `telemetry.diagnostics` / `metrics` | `true` / `false` |
| Claude Code | `feedbackSurveyRate` | `0` |
| Codex | `analytics.enabled` / `feedback.enabled` | `false` / `false` |

**File search/listing tools** must stay in sync across: `fd` alias in `.zshrc`, `.config/ripgrep/ripgreprc`, yazi, eza aliases, Finder defaults, superfile

| Behavior | fd | rg | yazi | eza | Finder | superfile |
|---|---|---|---|---|---|---|
| Hidden files | `--hidden` | `--hidden` | `show_hidden = true` | `-a` (in `ll`/`lt`) | `AppleShowAllFiles` | runtime toggle only (no config key) |
| Follow symlinks | `--follow` | `--follow` | `show_symlink = true` | — | — | always shown (no config key) |
| Dirs first | — | — | `sort_dir_first = true` | `--group-directories-first` | `_FXSortFoldersFirst` | hardcoded behavior (no config key) |
| Case insensitive | — | `--smart-case` | `sort_sensitive = false` | — | — | `case_sensitive_sort = false` |
| Sort by name (alphabetical) | — | — | `sort_by = "alphabetical"` | — | — | `default_sort_type = 0` |
| Sort reverse | — | — | `sort_reverse = false` | — | — | `sort_order_reversed = false` |
| No extra columns | — | — | `linemode = "none"` | — | — | `file_panel_extra_columns = 0` |

**Italic text rendering** must stay consistent:

- VSCode Catppuccin: `italicComments: true`, `italicKeywords: true`
- bat: `--italic-text=always`
- Delta inherits from bat theme engine (Catppuccin Macchiato italic support)

**Smooth scrolling** enabled everywhere:

- VSCode: `editor.smoothScrolling`, `workbench.list.smoothScrolling`, `terminal.integrated.smoothScrolling` (all `true`)
- Zed: native smooth scrolling (macOS)
- Ghostty: native smooth scrolling (macOS)

**AI agent** enabled in both editors:

- VSCode: `chat.agent.enabled: true`
- Zed: `agent.enabled: true`
- Zed: `agent_servers` configured with `codex-acp` and `claude-acp` registries

**Zed keybindings:** `base_keymap: "VSCode"` — Zed mirrors VSCode shortcuts for consistency

**Pager = delta** across all git-aware tools:

| Tool | Config | Value |
|---|---|---|
| `.config/git/config` | `core.pager` | `delta` |
| `.config/git/config` | `interactive.diffFilter` | `delta --color-only` |
| gh CLI | `pager` | `delta` |
| lazygit | `git.pagers` | `delta --paging=never` (lazygit handles scroll) |

**Modified file indicators** in tabs:

- VSCode: `workbench.editor.highlightModifiedTabs: true`
- Zed: `tabs.git_status: true`
- Micro: `diffgutter: true`

**Line numbers in preview tools** (consistent with editors showing line numbers):

- bat: `--style="numbers,changes,header,grid"`
- Delta: `line-numbers = true`

**Window/system theme follows OS:**

- Ghostty: `window-theme = system` + `theme = light:Catppuccin Latte,dark:Catppuccin Macchiato`
- Zed: `theme.mode: "system"` (light: Catppuccin Latte, dark: Catppuccin Macchiato)
- VSCode: `window.autoDetectColorScheme: true` (light: Catppuccin Latte, dark: Catppuccin Macchiato)
- bat: `--theme-dark="Catppuccin Macchiato"` + `--theme-light="Catppuccin Latte"` (auto-detects via macOS appearance)
- glow: `style: "auto"` (auto-detects)
- Codex: `tui.theme = "catppuccin-macchiato"` (TUI only, no light/system mode)
- Superfile: `theme = "catppuccin-macchiato"` (TUI only, no light/system mode; built-in theme file at `Library/Application Support/superfile/theme/catppuccin-macchiato.toml`)

**Inline diagnostics** (errors/warnings shown on affected lines):

- VSCode: `errorlens` extension (installed via Brewfile)
- Zed: `diagnostics.inline.enabled: true` (built-in, matches ErrorLens behavior)

**Shell linting/formatting** — extension + binary pairs (both must be present):

- `shellcheck` (brew) ↔ `timonwong.shellcheck` (VSCode extension); both in `Brewfile`. Extension auto-discovers binary from `PATH`.
- `shfmt` (brew) ↔ `foxundermoon.shell-format` (VSCode extension); both in `Brewfile`. Extension auto-discovers binary from `PATH`.
- Zed: built-in shell highlighting; no extension installed. `shellcheck`/`shfmt` invoked directly from `PATH` if a project formatter is configured.

**Extension management** — reproducible across machines:

- VSCode: `vscode` entries in `Brewfile` (managed by `brew bundle dump` / `brew bundle install`)
- Zed: `auto_install_extensions` in `.config/zed/settings.json` (auto-installed on launch)

**Zed overrides from defaults:** `auto_signature_help: true` (Zed default is `false`, set to match VSCode `parameterHints.enabled`)

**Trim final newlines** (known gap):

- VSCode: `files.trimFinalNewlines: true` (trims extra blank lines at EOF)
- Zed: `ensure_final_newline_on_save: true` (adds one, does NOT trim extras)
- Micro: `eofnewline: true` (adds one, does not trim extras)

**Hidden files / case-insensitive matching at shell level** (supplements file search table above):

- zsh: `setopt globdots` (glob matches dotfiles — consistent with fd/rg `--hidden`)
- zsh completions: `matcher-list 'm:{a-zA-Z}={A-Za-z}'` (supplements smart-case in rg/Zed/yazi)

**Nerd Font icons** — `Symbols Nerd Font Mono` in font fallback chain enables icons across:

- starship: nerd-font-symbols preset (`.config/starship/starship.toml`)
- eza: `--icons=auto` in aliases
- lazygit: `nerdFontsVersion: "3"`
- yazi: auto-detected
- superfile: `nerdfont = true` + `show_select_icons = true` (explicit)
- VSCode/Zed: via font fallback chain
- Ghostty: via font fallback chain (`Symbols Nerd Font Mono`)

**Shell integration:**

- Ghostty: `shell-integration = zsh`
- `.zshrc`: sources fzf (`fzf --zsh`), fnm, uv, zoxide, starship

**Clipboard whitespace:**

- Ghostty: `clipboard-trim-trailing-spaces = true` (trim on copy)
- Editors: trim trailing whitespace on save (VSCode, Zed, Micro)

**Update channel and auto-update** — stable everywhere, auto-update enabled:

| Tool | Auto-update | Channel | Setting |
|---|---|---|---|
| Claude Code | manual (Brew owns) | — | `autoUpdatesChannel: "stable"` set but `brew upgrade --cask claude-code` is authoritative |
| Codex | manual (Brew owns) | — | No internal flag; `brew upgrade --cask codex` (or `codex update`) |
| Ghostty | download | `stable` | `auto-update = download`, `auto-update-channel = stable` |
| VSCode | `"default"` (enabled) | stable | `update.mode: "default"` |
| VSCode extensions | enabled | — | `extensions.autoUpdate: true`, `extensions.autoCheckUpdates: true` |
| Zed | enabled | stable | `auto_update: true` |
| Zed extensions | auto-install on launch | — | `auto_install_extensions` |
| Go tools (VSCode) | enabled | — | `go.toolsManagement.autoUpdate: true` |
| atuin | disabled (Brew owns) | — | `update_check = false` |
| superfile | disabled (Brew owns) | — | `auto_check_update = false` |
| lazygit | disabled (Brew owns) | — | `update.method: never` |
| tlrc cache | enabled | — | `[cache].auto_update = true` |
| Homebrew | manual (`make brew-install`) | — | No auto-update |

**Codex ↔ Claude shared docs:** Codex `project_doc_fallback_filenames = ["CLAUDE.md"]` — both agents read same `CLAUDE.md` files

**Exclusion lists** must stay in sync across: `.config/ripgrep/ripgreprc`, `fd` alias in `.zshrc`, VSCode `search.exclude`, Zed `file_scan_exclusions`, `.config/git/ignore`. Core set: `.git`, `node_modules`, `.venv`, `venv`, `__pycache__`, `.pytest_cache`, `.terraform`, `vendor`, `dist`, `build`, `coverage`

**Git settings** must stay consistent across: `.config/git/config` (authoritative), VSCode, Zed, `gh` CLI, lazygit

| Setting | `.config/git/config` | VSCode | gh CLI | lazygit | Zed |
|---|---|---|---|---|---|
| Protocol | `url.insteadOf` (SSH) | `gitProtocol: "ssh"` | `git_protocol: ssh` | (uses git) | (uses git) |
| Auto fetch | — | `autofetch: true` (300s) | — | `autoFetch: true` (default 60s) | no setting (gap) |
| Prune on fetch | `fetch.prune = true` | `pruneOnFetch: true` | — | — | (uses git) |
| Rebase on pull | `pull.rebase = true` | `rebaseWhenSync: true` | — | — | (uses git) |
| Autostash | `rebase.autostash = true` | `autoStash: true` | — | — | (uses git) |
| Branch protection | — | `branchProtection: [main, master]` | — | `disableForcePushing: true` | no setting (gap) |
| Inline blame | — | `blame.editorDecoration.enabled` + `blame.statusBarItem.enabled` | — | — | `inline_blame.enabled: true` |
| Blame format | — | `${authorName} (${authorDateAgo})` | — | — | `show_commit_summary: false` |
| Editor | `core.editor = code --wait` | — | — | `editPreset: vscode` | — |
| Nerd fonts | — | — | — | `nerdFontsVersion: "3"` | — |

Zed delegates git workflow (rebase, autostash, prune, SSH) to `.config/git/config` — consistent by inheritance. Two known gaps: no auto-fetch, no branch protection.

`.config/git/config` authoritative settings: `init.defaultBranch = main`, `merge.conflictstyle = zdiff3`, `rerere.enabled = true`, `rerere.autoupdate = true`, `push.autoSetupRemote = true`, `diff.algorithm = histogram`, `diff.colorMoved = default`, `diff.renames = true`, `diff.mnemonicPrefix = true`, `log.date = relative`, `branch.sort = -committerdate`. Delta config: `dark = true`, `line-numbers = true`, `side-by-side = true`, `hyperlinks = true`, `navigate = true`. `[filter "lfs"]` block pre-configured for git-lfs — no need to run `git lfs install`.

`.config/git/config` section order: Identity (`user`, `url`) → Core (`core`, `init`, `interactive`) → Pager (`delta`) → Display (`diff`, `merge`, `log`, `branch`) → Workflow (`fetch`, `pull`, `rebase`, `push`, `rerere`) → Filters (`filter "lfs"`) → Aliases (`alias`, last). Add new sections under the matching group.

**`EDITOR` env var** must match across: `.zprofile` (`code --wait`), `.config/git/config` (`core.editor`), `.config/gh/config.yml` (`editor: code --wait`), `.config/yazi/yazi.toml` (`[opener.edit]` runs `code --wait "$@"`), lazygit (`editPreset: vscode`), Codex (`file_opener = "vscode"`), Superfile (`editor`/`dir_editor = "code --wait"`)

**Claude ↔ Codex** allowed commands must stay in sync between `.config/claude/settings.json` and `.config/codex/rules/`

**Marketplace identifiers** are intentionally divergent between Claude and Codex when both tools register the same upstream repo, because Codex CLI does not support renaming a marketplace key after `codex plugin marketplace add` (the key is fixed by the add command). Current state for the shared `caveman` repo (https://github.com/JuliusBrussee/caveman):

- `.config/claude/settings.json` → `extraKnownMarketplaces.caveman`
- `.config/codex/config.toml` → `[marketplaces.caveman-repo]` + `[plugins."caveman@caveman-repo"]`

Do not attempt to rename the Codex side to `caveman` — Codex will treat it as a new, unregistered marketplace and the plugin enable line will dangle.

**Built-in Codex marketplaces:** `openai-curated` is pre-registered by the Codex CLI binary — do not declare `[marketplaces.openai-curated]` in `.config/codex/config.toml`. Plugin references like `[plugins."slack@openai-curated"]` resolve through the built-in registry. Only third-party marketplaces (e.g. `caveman-repo`) need explicit `[marketplaces.<name>]` blocks.

**VSCode `git.blame.*` is split** into `git.blame.editorDecoration.enabled` (inline editor decoration) and `git.blame.statusBarItem.enabled` (status bar item), each with its own `template`. Do not use the legacy flat `git.blame.enabled` key — it is silently ignored.

**Brewfile maintenance:**

- `Brewfile` is **the dump target**: `make brew-export` overwrites it via `brew bundle dump --force`, then strips any line that also appears in `Brewfile.work`. Net effect: base stays curated, work entries stay separate.
- `Brewfile.work` is **manually curated**: `brew bundle dump` does not respect file boundaries, so new work entries must be added by hand to `Brewfile.work` after install. Otherwise the next `make brew-export` will leak them into base.
- `Brewfile.work` lines must use the same format `brew bundle dump` emits (`cask "name"`, `brew "name"`, etc.). The strip step prefilters `Brewfile.work` through `grep -E '^(brew|cask|tap|vscode|mas) "'` before whole-line fixed-string match, so blank lines and comments in `Brewfile.work` are tolerated, but malformed entries (wrong prefix, trailing whitespace) still leak through.
- **Known gap:** the strip regex does not cover `go "..."` / `uv "..."` DSL prefixes. `Brewfile.work` is casks-only today, so no live leak — but a future work-only `go`/`uv` entry would not be eligible for stripping, and the next `make brew-export` would drop it from `Brewfile` on the round-trip. Extend the regex in `Makefile` and this block if that scope ever expands.
- Do not re-sort either Brewfile by hand — `brew bundle dump` owns ordering.

**Flatpaks maintenance:**

- `flatpaks` is **the dump target**: `make flatpaks-export` overwrites it via `flatpak list --user --app --columns=application`, then strips any line that also appears in `flatpaks.work` (same `.tmp` + atomic `mv` pattern as `brew-export`). The `.tmp` file is a shell limitation, not a design choice — `> flatpaks` would truncate the file before `grep` reads it.
- `flatpaks.work` is **manually curated**: `flatpak list` has no file-boundary awareness, so new work entries must be added by hand to `flatpaks.work` after install. Otherwise the next `make flatpaks-export` will leak them into base.
- **No comments in either file.** Both use bare Flathub IDs (one per line). Comments and blank lines are tolerated by the install loop but wiped by `make flatpaks-export` on first run (the `flatpak list` dump emits only IDs). Symmetric with `Brewfile` / `Brewfile.work` which are also comment-free. The install-side `grep -vE '^\s*(#|$)'` filter exists only as a defensive guard.
- `flatpak list --columns=application` emits sorted alphabetically by app ID — do not re-sort by hand.
- Both files are **user-scope** (`--user`); system-scope entries from `/var/lib/flatpak` will not appear in `flatpak list --user` and will be lost on `make flatpaks-export`. Stick to one scope (user). See "Plain flatpaks vs Brewfile flatpak keyword" below.

**Plain flatpaks vs Brewfile flatpak keyword:**

The Brewfile DSL gained a `flatpak` keyword in brew 5.0.4+. Install side is cross-OS-safe — `brew bundle` skips cask entries on Linux and flatpak entries on macOS with a friendly warning. But this repo uses a separate `flatpaks` file for two reasons:

- **Dump asymmetry destroys the other-OS side.** `brew bundle dump --force` on macOS emits zero flatpak lines (no flatpak installed), wiping every `flatpak "X"` entry from `Brewfile` on each `make brew-export`. Same in reverse: dump on Linux drops all `cask` entries. A single cross-OS Brewfile cannot survive `dump --force` on alternating hosts. Separate per-OS files sidestep the problem entirely — each file is owned by its host and never touched by the other.
- **Brewfile flatpak DSL has no `--user` parameter.** It defaults to system scope (`/var/lib/flatpak`, sudo required). Personal-laptop convention is `--user`: no sudo, no `/var/lib` bloat, app state lives in `$HOME`, all Flathub apps work identically in user scope on a single-user laptop (sandbox is per-app, not per-scope), and mixing scopes duplicates runtime extensions (`org.freedesktop.Platform.*`) on disk. Community consensus (Arch Wiki, Flathub docs, Bluefin docs, openSUSE forums) recommends `--user` for personal laptops. Brew analogy: `brew` installs to `/opt/homebrew` without sudo; `flatpak --user` installs to `~/.local/share/flatpak` without sudo — same model.

## Claude Code Settings

The `.config/claude/settings.json` configures permissions and plugins:

- **Allowed:** Read-only git/docker/k8s, build/test/lint tools (`shellcheck`, `shfmt`), dependency sync (`go mod tidy/download`, `uv sync/lock`, `npm ci`), version probes (`go/uv/python/python3/node/npm --version`, `fnm list/current`), web search, web fetch from dev docs (GitHub, Stack Overflow, MDN, Go/Python/Node/Terraform/Docker/Kubernetes/Claude docs), file search and inspection (`fd`, `rg`, `grep`, `find`, `which`, `bat`, `eza`, `head`, `tail`, `ls`, `wc`, `jq`, `yq`, `tldr`, `date`)
- **Denied:** `.env`, `.ssh/*`, `.kube/config`, `.git-credentials`, credentials, private keys, `.tfvars` (`Read` tool only — see note below)
- **Requires approval:** Arbitrary package install (`brew install`, `npm install`, `uv add`), direct code execution, git writes, docker mutations
- **Sensitive-data trust boundary:** `Read(...)` deny rules only cover the `Read` tool. Allowed `Bash(...)` readers (`bat`, `head`, `tail`, `cat` via alias, `jq`, `yq`, `grep`, `rg`, `ls`, `wc`, `find`, `fd`) can target the same paths without prompting. Actual protection comes from the model-level `Sensitive Data` rule in `.config/claude/CLAUDE.md`, not from the JSON allow/deny.
- **Enabled plugins:** pyright-lsp, gopls-lsp, typescript-lsp, code-review, feature-dev, code-simplifier, claude-md-management, caveman, context7, slack, atlassian, posthog, datadog, pr-review-toolkit
- **Marketplace:** [caveman](https://github.com/JuliusBrussee/caveman) (auto-update enabled)
- **Status line:** Custom layout via `ccstatusline` (model, thinking effort, cwd, git branch, context %, session/weekly usage, cost)
- **Usage tracking:** `ccstatusline` surfaces session/weekly usage and cost in the status bar via the `ccusage` library it embeds. Run `npx ccusage` for ad-hoc cost reports.

See `.config/claude/settings.json` for the full permission list.

## Codex Settings

The `.config/codex/config.toml` configures model selection, sandboxing, profiles, plugins, and MCP integrations:

- **Default behavior:** On-request approvals, `workspace-write` sandbox, cached web search by default, analytics/feedback disabled
- **Profiles:** `quick` and `research` (`research` enables live web search)
- **Rules:** `.config/codex/rules/` defines allowed command groups for `git`, `dev`, `shell`, and `infra`
- **Enabled plugins:** Slack, caveman
- **Marketplace:** [caveman](https://github.com/JuliusBrussee/caveman)
- **MCP servers:** Atlassian, Datadog, Context7, PostHog

See `.config/codex/config.toml` and `.config/codex/rules/` for the full configuration.
