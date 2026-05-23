# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Cross-platform dotfiles repository (macOS and Linux/GNOME) for setting up a development environment. All configs use **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme where supported, **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go 1.26** (via Homebrew), **Python** (via `uv`), and **Node.js** (via `fnm`).

## Key commands

```bash
make setup              # Base setup: configure OS, symlink configs, install base packages, show versions
make setup-all          # Full setup: base setup + work packages
make symlinks           # Symlink configs to home directory
make macos-defaults     # Configure macOS defaults: folders, system, screenshots, Finder, Dock (no-op on Linux)
make linux-defaults     # Configure Linux/GNOME defaults: folders, input, Nautilus, desktop (no-op on macOS / non-GNOME)
make versions           # Show installed Go, Node, Python versions
make validate           # Full audit: parse configs, brew bundle, ghostty, shellcheck, shfmt, zsh -n, codex rules, git config, CLI flag configs, symlinks
make brew-install       # Install all packages (base + work)
make brew-install-base  # Install base packages only
make brew-install-work  # Install work packages only
make brew-cleanup       # Clean up old versions and cache
make brew-export        # Export installed packages (incl. VSCode extensions) to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually (macOS only; Linuxbrew dump would wipe macOS-only casks)
```

Linux GUI apps install via vendor deb/rpm. Per-app commands in `docs/linux-packages.md`. No Flatpak.

## Repository structure

- `LICENSE` - MIT license
- `README.md` - Quick start, prerequisites, configuration inventory, validation, updating, plugin/marketplace summary, templates
- `scripts/symlinks.sh` - Creates symlinks (uses `set -euo pipefail`; defines `symlink` helper; branches on `uname -s` for glow/superfile/tlrc/vscode)
- `scripts/macos-defaults.sh` - macOS defaults via `defaults write` (non-interactive, idempotent; guards `uname -s == Darwin`, no-op on Linux)
- `scripts/linux-defaults.sh` - Linux/GNOME defaults via `gsettings` (non-interactive, idempotent; guards `uname -s == Linux`, requires `gsettings` + `XDG_CURRENT_DESKTOP=*GNOME*`, no-op on macOS / KDE / headless)
- `scripts/validate.sh` - Full audit runner (parses every TOML/JSON/YAML/JSONC, `brew bundle list --all` for Brewfile parse plus non-fatal `brew bundle check` for install state, ghostty validate, shellcheck, shfmt, `zsh -n` on `.zshrc`/`.zprofile`, codex/rules sanity grep, symlink verification). Backs `make validate`. Skips macOS-native symlinks on Linux.
- `docs/applications.md` - Curated GUI app picks per category, VSCode setup, search-engine bangs
- `docs/casks.md` - Homebrew Cask inventory split into base, work, and Linux-installable subsets
- `docs/conventions.md` - Cross-config consistency tables (shared behavior across all tools: theme, font, telemetry, git pager, etc.). Read when adding a new tool or auditing drift.
- `docs/macos-tips.md` - Non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers)
- `Makefile` - Task runner targets (`make help` for list)
- `Brewfile` - Base packages: shell essentials, fonts, daily-driver apps, VSCode extensions
- `Brewfile.work` - Work packages: work-specific GUIs — API client, K8s GUI, DB GUI, container runtime, comms, VPN, browser (curated manually)
- `docs/linux-packages.md` - Native deb/rpm install commands for each cask on Linux (vendor apt/dnf repos, signed keys, GitHub release downloads)
- `.zshrc` / `.zprofile` - Zsh config. `.zprofile` sets `BREW_PREFIX`, XDG base-dir vars, `GOPATH=$XDG_DATA_HOME/go` (Go doesn't honor XDG natively), and `VISUAL`/`EDITOR`. `.zshrc` re-detects `BREW_PREFIX` only (defensively, for non-login interactive shells where `.zprofile` was not sourced); other env vars use `${XDG_STATE_HOME:-...}` style fallbacks where they matter. `.zshrc` keeps `HISTFILE` under `$XDG_STATE_HOME/zsh/history` and loads starship prompt, fnm, uv, fzf with bat preview, eza aliases, syntax-highlighting, autosuggestions. Ghostty and Terminal.app open login shells, so `.zprofile` runs in practice; non-login interactive shells (e.g. `zsh -i` inside scripts) lose `RIPGREP_CONFIG_PATH` / `VISUAL` / `EDITOR` / `GOPATH` unless `.zprofile` is sourced manually.
- `.config/git/config` / `.config/git/ignore` - Git settings (delta pager, rebase workflow, SSH for GitHub, zdiff3 conflicts, rerere, git-lfs filters) — XDG path
- `.config/ripgrep/ripgreprc` - Ripgrep defaults (smart-case, hidden files, follow symlinks); resolved via `RIPGREP_CONFIG_PATH`
- `.config/ghostty/config` - Terminal emulator
- `.config/starship.toml` - Shell prompt (nerd-font-symbols preset; flat path per starship.rs)
- `.config/bat/config` - Cat replacement with syntax highlighting
- `.config/gh/config.yml` - GitHub CLI settings (SSH protocol, delta pager)
- `.config/lazygit/config.yml` - Git TUI (nerd fonts, delta pager, vscode editor)
- `.config/micro/settings.json` - Terminal text editor
- `.config/yazi/yazi.toml` - Terminal file manager settings
- `.config/atuin/config.toml` - Atuin shell history (filter parity with `hist_ignore_space`)
- `.config/bottom/bottom.toml` - Bottom (`btm`) system monitor (tree view + command column + battery, cache memory shown, unnormalized per-core CPU, byte/binary network units, table scroll position)
- `.config/glow/glow.yml` - Glow Markdown renderer (auto theme, pager on, line numbers in TUI; XDG on both OSes because glow honors `$XDG_CONFIG_HOME` explicitly in `main.go`)
- `.config/tlrc/config.toml` - tlrc (tldr client) — show platform title, short+long flags (non-XDG on macOS, XDG on Linux; tlrc uses Rust `dirs::config_dir()` and ignores `$XDG_CONFIG_HOME` on Darwin)
- `.config/superfile/config.toml` - Superfile (`spf`) terminal file manager (Catppuccin Macchiato, bat preview with border, binary file sizes, zoxide integration; XDG on both OSes because spf reads `xdg.ConfigHome` from `adrg/xdg`, which honors the env var set in `.zprofile`)
- `.config/vscode/settings.json` - VSCode settings (JSONC format with comments)
- `docs/vscode-defaults.jsonc` - VSCode defaults snapshot for offline comparison (regenerate via `Preferences: Open Default Settings (JSON)` when stale)
- `.config/zed/settings.json` - Zed editor (Catppuccin Macchiato/Latte, JetBrains Mono, same UX as VSCode, auto_install_extensions)
- `.config/claude/CLAUDE.md` - Claude Code user-level instructions (symlinked to `~/.claude/CLAUDE.md`)
- `.config/claude/settings.json` - Claude Code permissions (web, git, docker, build tools, sensitive file protection)
- `.config/ccstatusline/settings.json` - Claude Code status line layout (via ccstatusline)
- `.config/codex/AGENTS.md` - Codex user-level instructions (symlinked to `~/.codex/AGENTS.md`)
- `.config/codex/config.toml` - Codex CLI config (model, sandbox, profiles, plugins)
- `.config/codex/rules/{git,dev,shell,infra}.rules` - Codex permission rules (symlinked per file to `~/.codex/rules/`; new rule files require entries in both `scripts/symlinks.sh` and `scripts/validate.sh`)

Templates (not symlinked, import or copy as needed):

- `docs/bookmarks.template.html` - Netscape bookmark template (universal URLs only: GitHub `/pulls/*`, AI chats, web tools). One-shot import per project; rename `<Employer>` / `<Project>` folders after import.

## Doc-drift checklist

When adding a new tool, config file, cask, or formula, update all of these in lockstep — missing any one causes documentation drift:

- **Install** — add line to `Brewfile` or `Brewfile.work` (tap, cask, brew, vscode, go, uv, etc.)
- **Linux equivalent** — when adding a `cask`, classify and document. Inspect the cask `.rb` source first (`brew info --json=v2 --cask <name>` for `ruby_source_path`, then fetch from `https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/<path>`):
  - **Linux-installable via brew** — `.rb` declares `os macos: ..., linux: ...` block with `x86_64_linux`/`arm64_linux` sha256 entries AND uses `binary` artifact, OR uses `font` artifact with no `depends_on macos:`. These install on Linuxbrew via `brew install --cask <name>`. Add row to "Linux-installable casks" table in `docs/casks.md`. No native package step needed.
  - **GUI app with native deb/rpm** — vendor ships `.deb` + `.rpm` (apt/dnf repo or GitHub release). Add per-app install commands to `docs/linux-packages.md` under "Base apps" or "Work apps".
  - **GUI app without official deb/rpm** — community Copr / community deb / tarball / install script. Document under matching app section in `docs/linux-packages.md` with upstream + community sources.
  - **No Linux build at all** — `pkg`/`installer` artifact, or macOS-system-only tool (e.g. `rectangle`, `maccy`). Add cask name to "Casks with no Linux build" section in `docs/linux-packages.md`.
  - Every cask in `Brewfile` / `Brewfile.work` must appear in exactly one of: `docs/casks.md` Linux-installable table, `docs/linux-packages.md` Base/Work app section, or `docs/linux-packages.md` "Casks with no Linux build" section.
- **Symlink** — add `symlink <repo-src> <abs-dest>` call to `scripts/symlinks.sh` if the tool reads a config file from a fixed path
- **README "Configuration files" list** — add bullet under `## Configuration files` if a config file is symlinked
- **README "CLI tools" table** or **`docs/casks.md`** — add row if user-facing CLI / GUI tool
- **`docs/linux-packages.md`** — add per-app section with deb/rpm commands if the cask has a Linux build
- **`docs/applications.md` table** — add row if GUI app fits an existing category, or add new category row
- **CLAUDE.md "Repository structure" list** — add bullet describing the file's purpose
- **`docs/conventions.md` tables** — add row(s) if the tool shares behavior (theme, font, tab size, hidden files, telemetry, auto-update, git pager, etc.) with existing tools
- **`scripts/validate.sh`** — extend the matching block (TOML/JSON/YAML/JSONC parse list, or symlink list) so `make validate` covers the new config

When removing a tool, sweep the same list in reverse.

## Comment style in configs

When adding or editing config files, follow this style across all of them:

- **Drop top-of-file banners** — filename already states the file's purpose (no `# .zshrc - Interactive shell config` headers). Two exceptions: (1) location/operational notes for tools that ignore XDG and require non-obvious symlink targets (e.g. macOS `Library/Preferences/...`, `Library/Application Support/...`) are allowed since the symlink destination is not derivable from the filename; (2) a single-line upstream-docs URL pointer (e.g. `# https://ghostty.org/docs/config/reference` in `.config/ghostty/config`, `// https://zed.dev/docs/configuring-zed` in `.config/zed/settings.json`) is allowed when it helps locate the canonical config reference quickly.
- **Keep group dividers** — short single-line headers (`# Theme`, `# Cursor`, `# Git`) make long configs scannable. Use the same divider style as surrounding files (e.g. `// Name` in JSONC, `# Name` in TOML/conf, `# Name` shell).
- **Keep non-obvious why-comments** — workarounds, ordering constraints, parity with another tool, hidden invariants. Lead with the reason, not the restatement.
- **Drop tautology** — `# Enable completion` above `compinit`, `# Aliases` above an alias block where every line is `alias x=...` is fluff.
- **JSONC comment style** — use `// Name` (single-line) for section dividers in `.config/vscode/settings.json` and `.config/zed/settings.json`. Do not use `/* Name */` block-style.
- **Trim verbose schema docs** — when a tool emits its config with full per-key docstrings (e.g. `gh config init`), strip them; keys are self-documenting.
- **Plain JSON files (no comments allowed)** — micro's `settings.json` is parsed by Go's strict `encoding/json`, which rejects `//` and `/* */`. Use **blank lines** between key clusters for visual grouping; document the cluster meaning in this file. Current micro grouping: `tabsize`/`tabstospaces`/`autoindent`/`smartpaste` (indentation) → `rmtrailingws`/`eofnewline`/`fileformat` (whitespace & save) → `syntax`/`cursorline`/`matchbrace`/`colorcolumn`/`scrollbar`/`scrollmargin`/`diffgutter`/`basename`/`hlsearch`/`savecursor`/`wordwrap` (display) → `encoding`/`truecolor` (encoding).

## Script behavior

### scripts/symlinks.sh

- Uses `symlink <repo-relative-src> <abs-dest>` helper (force symlink via `ln -sf`, auto-creates parent dirs). Overwrites existing symlinks.
- `DOTFILES_DIR` resolves to repo root via `cd "$(dirname "$0")/.." && pwd` (script lives one level deep in `scripts/`)
- Repo holds all source-of-truth configs under `.config/<tool>/`. Most tools are XDG-compliant on both OSes (single link target). Two tools (tlrc, vscode) read from non-XDG paths on macOS and XDG on Linux; the script branches on `uname -s` (`case Darwin|Linux`):

  | Tool | macOS | Linux |
  |---|---|---|
  | tlrc | `~/Library/Application Support/tlrc/config.toml` | `~/.config/tlrc/config.toml` |
  | VSCode | `~/Library/Application Support/Code/User/settings.json` | `~/.config/Code/User/settings.json` (capital `C`, not `vscode/`) |

  Why these two and not glow / superfile: `.zprofile` exports `XDG_CONFIG_HOME=$HOME/.config`, and both glow (`charmbracelet/glow` main.go line 439, explicit `os.Getenv("XDG_CONFIG_HOME")` check) and superfile (`yorukot/superfile` via `adrg/xdg`, which honors the env var on darwin too) read from `$XDG_CONFIG_HOME/<tool>/` when the variable is set. tlrc uses the Rust `dirs::config_dir()` helper which ignores `$XDG_CONFIG_HOME` on macOS; override via `TLRC_CONFIG=PATH` env var only. VSCode is an Electron app with a hardcoded `app.getPath('userData')` path; override only via `code --user-data-dir=PATH`. If a host has stale Library copies of glow/superfile from older repo revisions, delete them after `make symlinks` so the active config matches.

  Unknown OS prints a warning and skips this block. Claude/Codex use `~/.claude` and `~/.codex` on both OSes (non-XDG always); no branching needed there.
- Symlinks grouped by category (in this order): Shell → Shell tools (history/pager/system monitor/terminal/search/prompt/file manager) → Git/file tools → Editors → AI agents → platform-native paths. Within each group, tools are alphabetized. Add new symlinks under the matching group in alpha order. For tools with split macOS/Linux paths, add to both branches of the `case` block.

### scripts/macos-defaults.sh

- Non-interactive: applies all categories unconditionally (Folders, System defaults, Screenshots, Finder + DS_Store suppression on network/USB, Dock)
- Restarts affected processes (Finder, Dock, SystemUIServer)
- Safe to re-run: idempotent `mkdir -p` and `defaults write` commands
- Guards `uname -s == Darwin`; exits 0 on Linux so the shared `make setup` chain stays safe to invoke cross-OS

### scripts/linux-defaults.sh

- Non-interactive: applies Folders, Input (touchpad + mouse natural scroll, keyboard repeat), Files/Nautilus (list view, hidden files, folders-first, recursive-search=never), Desktop (dash-to-dock click action, battery %, clock, color scheme `prefer-dark`), Power (no AC suspend)
- Safe to re-run: idempotent `mkdir -p` plus `gsettings set` only when the schema/key exists (`set_if_exists` helper guards against missing GNOME components like `dash-to-dock`)
- Guards in order: `uname -s == Linux` → `command -v gsettings` → `XDG_CURRENT_DESKTOP` contains `GNOME`. Non-GNOME DEs (KDE, Sway, headless SSH) skip with a message
- No process restart needed (GNOME applies `gsettings` changes live)
- Screenshot folder: created at `~/Pictures/Screenshots` (XDG user-dir convention; matches GNOME Screenshot UI default and `make macos-defaults` on macOS)

## Shell aliases

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

## Shell tool integration

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

## Git aliases

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

## Config validation

### Spot checks (per-tool)

```bash
ghostty +show-config --default --docs      # Should show parsed config, no errors
ghostty +show-config                        # Should round-trip current config, exit 0
bat --list-themes | grep -i catppuccin     # Should show "Catppuccin Macchiato"
delta --list-syntax-themes | grep -i catppuccin  # Should show Catppuccin themes
btm --version                               # Should show version
glow --version                              # config at ~/.config/glow/glow.yml on both OSes (glow honors $XDG_CONFIG_HOME)
atuin doctor                                # Should show config + DB ok
tldr --config-path                          # macOS: ~/Library/Application Support/tlrc/config.toml; Linux: ~/.config/tlrc/config.toml
tldr --info                                 # Should show cache age + language
starship config                             # Should show TOML config
git config --list --show-origin             # Should show ~/.config/git/config as source
fnm list                                    # Should show installed Node versions
uv python list --only-installed             # Should show installed Python versions
```

### Full audit

Run `make validate` (delegates to `scripts/validate.sh`). Covers:

1. Parse every TOML (`.config/codex/config.toml`, atuin, bottom, yazi, starship, tlrc, superfile)
2. Parse every plain JSON (claude/settings, micro, ccstatusline)
3. Parse every YAML (gh, lazygit, glow) — needs `yq`
4. Parse JSONC (zed, vscode) — needs `node`
5. `brew bundle list --file=Brewfile{,.work}` (parse-only; install state reported separately as non-fatal warning) — needs `brew`
6. `ghostty +validate-config --config-file=.config/ghostty/config` — needs `ghostty`
7. `shellcheck` + `shfmt` on every script in `scripts/`
8. `zsh -n` on `.zshrc` and `.zprofile` (syntax-only; needs `zsh`)
9. Sanity grep on `.config/codex/rules/*.rules` (every non-comment, non-blank line must start with `prefix_rule(`)
10. `git config --file=.config/git/config --list` (INI parse; needs `git`)
11. Sanity grep on `.config/bat/config` and `.config/ripgrep/ripgreprc` (every non-comment, non-blank line must start with `--`; bat/rg silently ignore unknown flags so this catches the only bug class)
12. Verify every documented symlink under `$HOME` resolves (skips macOS-native paths on Linux)

When adding a new tool, extend the matching block in `scripts/validate.sh`.

**Web verification rule:** when a config key looks suspect (unfamiliar value, version-specific), confirm against the tool's official docs before flagging it as invalid. Examples that look wrong but are valid: Codex `model = "gpt-5.5"`/`gpt-5.4`/`gpt-5.4-mini`, Codex `personality = "friendly"`, Codex `[features].fast_mode`/`prevent_idle_sleep`, Codex `commit_attribution`, Claude `effortLevel = "xhigh"`, Claude `model = "opus[1m]"`, atuin `inline_height_shell_up_key_binding`, atuin `enter_accept = false` (intentional default-flip: Enter selects/edits, doesn't auto-execute), ghostty `cursor-opacity`/`adjust-cursor-thickness`. All confirmed valid via vendor docs.

## VSCode settings

When modifying `.config/vscode/settings.json`:

- Compare against `docs/vscode-defaults.jsonc` to check if a setting matches the default (keep explicit defaults — intentional). Regenerate via VSCode `Preferences: Open Default Settings (JSON)` when stale.
- Settings use JSONC format (JSON with comments and trailing commas allowed)
- Section dividers use `// Name` (single-line) for parity with `.config/zed/settings.json`; do not use `/* Name */` block-style
- Section order: Theme → Workbench → Window → Font & Indentation → Cursor & Scrolling → Editor UX → Inline diagnostics (ErrorLens) → IntelliSense → Formatting → Search → Files → Terminal → Git → Testing & Debug → JavaScript/TypeScript → Python → Go tooling → AI → Updates → Telemetry → Liveshare → Clipboard manager
- Configured for Go, Python, and Node.js backend development
- Uses Ruff for Python formatting/linting

### Layout (settings.json)

- `window.commandCenter`: false (no project name in title bar)
- `workbench.navigationControl.enabled`: false (no back/forward buttons)
- `workbench.layoutControl.type`: "menu" (dropdown instead of toggles)
- `workbench.activityBar.location`: bottom (compact, under primary side bar)
- `workbench.secondarySideBar.defaultVisibility`: "hidden" (toggle with `Cmd+Option+B` on demand)

### Layout (UI only, View → Appearance / Customize Layout)

- Quick input position: center
- Panel alignment: justify (full window width)
- Secondary side bar: right (`Cmd+Option+B`)

## Applications list maintenance

When updating the Applications table in `docs/applications.md`, see the selection criteria documented there. Key guidelines:

- Tools in **bold** are primary recommendations (one per category)
- GUI apps go in Applications section, text-based/TUI tools go in CLI tools section
- Include 3-5 apps per category when possible
- Verify apps are actively maintained before adding
- Research community sentiment (Reddit, GitHub issues, HN) before adding new tools

## Conventions

Shared-behavior tables live in `docs/conventions.md`. Read that file when:

- Adding a new tool that overlaps an existing tool's behavior (theme, font, tab size, hidden files, telemetry, auto-update, git pager, scroll margin, cursor style, etc.)
- Changing a value already covered in any consistency table (must update the table + every other tool's matching setting)
- Auditing whether a tool drifted from the shared invariants

The doc covers: editor settings matrix (VSCode/Zed/Micro/Ghostty/Bat/Delta/Yazi), telemetry, file-search defaults (fd/rg/yazi/eza/Finder/superfile), italic rendering, smooth scrolling, AI agent enablement, pager=delta, modified-file indicators, preview line numbers, OS theme follow, inline diagnostics, shell linting pairs, extension management, font icons, shell integration, clipboard whitespace, update channels, exclusion lists, git-settings cross-tool table, `EDITOR` env var, Claude↔Codex command parity, marketplace identifiers, Brewfile maintenance rules.

## Claude Code settings

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

## Codex settings

The `.config/codex/config.toml` configures model selection, sandboxing, profiles, plugins, and MCP integrations:

- **Default behavior:** On-request approvals, `workspace-write` sandbox, cached web search by default, analytics/feedback disabled
- **Profiles:** `quick` and `research` (`research` enables live web search)
- **Rules:** `.config/codex/rules/` defines allowed command groups for `git`, `dev`, `shell`, and `infra`
- **Enabled plugins:** Slack, caveman
- **Marketplace:** [caveman](https://github.com/JuliusBrussee/caveman)
- **MCP servers:** Atlassian, Datadog, Context7, PostHog

See `.config/codex/config.toml` and `.config/codex/rules/` for the full configuration.
