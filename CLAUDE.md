# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Cross-platform dotfiles repository (macOS and Linux/GNOME) for setting up a development environment. All configs use **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme where supported, **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go** (via Homebrew), **Python** (via `uv`), and **Node.js** (via `fnm`).

## Key commands

```bash
make setup              # Base setup: configure OS, symlink configs, apply local overrides, install base packages, show versions
make setup-all          # Full setup: base setup + work packages
make symlinks           # Symlink configs to home directory
make local-overrides    # Render per-machine overrides from .local/source.toml into tracked git/zprofile/claude/codex configs
make macos-defaults     # Configure macOS defaults: folders, system, screenshots, Finder, Dock (no-op on Linux)
make linux-defaults     # Configure Linux/GNOME defaults: folders, input, Nautilus, desktop (no-op on macOS / non-GNOME)
make versions           # Show installed Go, Node, Python versions
make validate           # Full audit: parse configs, brew bundle, ghostty, shellcheck, shfmt, zsh -n, codex rules, git config, CLI flag configs, symlinks
make snapshots          # Regenerate defaults/* (ghostty + starship + bat: local CLI; zed/yazi/superfile/atuin: curl upstream main; vscodium: manual)
make brew-install       # Install all packages (base + work)
make brew-install-base  # Install base packages only
make brew-install-work  # Install work packages only
make brew-cleanup       # Clean up old versions and cache
make brew-export        # Export installed packages (incl. VSCodium extensions) to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually (macOS only; Linuxbrew install state would wipe macOS-only casks)
```

Linux GUI apps install via vendor deb/rpm. Flatpak is avoided for any app whose config this repo symlinks under `~/.config/<tool>/` (the per-app sandbox path remap would break those symlinks); one-shot apps with no repo-managed config (screen recorders / etc. in `docs/linux-tips.md`) can still use Flatpak when no clean native package exists.

## Repository structure

- `LICENSE` - MIT license
- `README.md` - Quick start, prerequisites, configuration inventory, validation, updating, plugin/marketplace summary, templates
- `scripts/symlinks.sh` - Creates symlinks (uses `set -euo pipefail`; defines `symlink` helper; branches on `uname -s` for tlrc/vscodium)
- `scripts/local-overrides.py` - Renders per-machine overrides from `.local/source.toml` into tracked git/zprofile/claude/codex configs; reads base from `git show HEAD:<path>` each run so overrides never compound. See "Local overrides" below.
- `scripts/macos-defaults.sh` - macOS defaults via `defaults write` (non-interactive, idempotent; guards `uname -s == Darwin`, no-op on Linux)
- `scripts/linux-defaults.sh` - Linux/GNOME defaults via `gsettings` (non-interactive, idempotent; guards `uname -s == Linux`, requires `gsettings` + `XDG_CURRENT_DESKTOP=*GNOME*`, no-op on macOS / KDE / headless)
- `scripts/validate.sh` - Full audit runner (parses every TOML/JSON/YAML/JSONC, `brew bundle list --all` for Brewfile parse plus non-fatal `brew bundle check` for install state, ghostty validate, shellcheck, shfmt, `zsh -n` on `.zshrc`/`.zprofile`, codex/rules sanity grep, symlink verification). Backs `make validate`. Skips macOS-native symlinks on Linux.
- `.local.example.toml` - Schema template for per-machine overrides (committed). Copy to `.local/source.toml` (gitignored) and fill in.
- `.gitignore` - Repo-root gitignore. Excludes `.local/` (per-machine override data + rendered scratch) plus a subset of the global `.config/git/ignore` entries (`.DS_Store`, `.env`, `.env.*`, `.idea/`, `.vscode/`, `__pycache__/`, `*.pyc`, `*.swp`) and AI tool per-project local files (`.claude/settings.local.json`, `CLAUDE.local.md`, `AGENTS.local.md`; whole `.claude/` is intentionally NOT ignored so any future tracked `.claude/` content stays shareable) so the repo stays protected on fresh clones before `make symlinks` wires the global ignore, and for outside contributors who don't share this dotfiles setup.
- `docs/applications.md` - Curated GUI app picks per category (cross-platform where possible, macOS as tie-breaker lens), VSCodium setup, search-engine bangs
- `docs/backup-plan.md` - Personal backup plan: threat model, data inventory, one-time setup actions, recurring rituals (monthly/quarterly/yearly), recovery playbook per scenario. Apple primary + Google warm spare for Contacts/Calendar + rotating local SSD + HDD + 1Password for passwords.
- `docs/casks.md` - Homebrew Cask inventory split into base, work, and Linux-installable subsets
- `docs/conventions.md` - Cross-config consistency tables (shared behavior across all tools: theme, font, telemetry, git pager, etc.). Read when adding a new tool or auditing drift.
- `docs/macos-tips.md` - Non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers)
- `docs/linux-tips.md` - Non-obvious shortcuts and behaviors for GNOME-on-Wayland distros (clipboard, screenshots, Nautilus, workspaces, GNOME search, cross-device sharing, shell helpers, Wayland notes, per-distro deltas for Fedora/Silverblue/Bluefin, Vanilla OS, Zorin, Ubuntu)
- `Makefile` - Task runner targets (`make help` for list)
- `Brewfile` - Base packages (flat alpha within each section, sorted by the bare name `brew bundle dump` emits — binary name for `brew "..."` / `cask "..."` / `vscode "..."`, and last path segment for `go "..."` / `uv "..."` / `npm "..."`; `brew bundle dump` owns the ordering): shell essentials, fonts, daily-driver apps, VSCodium extensions, go dev tools
- `Brewfile.work` - Work packages: work-specific GUIs — API client, K8s GUI, DB GUI, container runtime, comms, VPN, browser (curated manually)
- `.zshrc` / `.zprofile` - Zsh config. `.zprofile` sets `BREW_PREFIX`, XDG base-dir vars, `GOPATH=$XDG_DATA_HOME/go` (Go doesn't honor XDG natively), and `VISUAL`/`EDITOR`. `.zshrc` re-detects `BREW_PREFIX` (Linux/macOS branch identical to `.zprofile`) only (defensively, for non-login interactive shells where `.zprofile` was not sourced); other env vars use `${XDG_STATE_HOME:-...}` style fallbacks where they matter. `.zshrc` keeps `HISTFILE` under `$XDG_STATE_HOME/zsh/history` and loads starship prompt, fnm, uv, fzf with bat preview, eza aliases, syntax-highlighting, autosuggestions. Ghostty and Terminal.app open login shells, so `.zprofile` runs in practice; non-login interactive shells (e.g. `zsh -i` inside scripts) lose `RIPGREP_CONFIG_PATH` / `VISUAL` / `EDITOR` / `GOPATH` unless `.zprofile` is sourced manually.
- `.config/git/config` / `.config/git/ignore` - Git settings (delta pager, rebase workflow, SSH for GitHub, zdiff3 conflicts, rerere, git-lfs filters) — XDG path
- `.config/ripgrep/ripgreprc` - Ripgrep defaults (smart-case, hidden files, follow symlinks); resolved via `RIPGREP_CONFIG_PATH`
- `.config/ghostty/config` - Terminal emulator
- `.config/starship.toml` - Shell prompt (nerd-font-symbols preset; flat path per starship.rs)
- `.config/bat/config` - Cat replacement with syntax highlighting
- `.config/gh/config.yml` - GitHub CLI settings (SSH protocol, delta pager)
- `.config/lazygit/config.yml` - Git TUI (nerd fonts, delta pager, codium templates mirror lazygit's `vscode` preset with `code`→`codium`; per-hook flags per `docs/conventions.md` "VISUAL / EDITOR env vars")
- `.config/micro/settings.json` - Terminal text editor
- `.config/yazi/yazi.toml` - Terminal file manager settings
- `.config/atuin/config.toml` - Atuin shell history (filter parity with `hist_ignore_space`)
- `.config/btop/btop.conf` - btop system monitor (Catppuccin Macchiato theme, transparent background, `save_config_on_exit = false` to prevent btop's default behavior of rewriting the file with all expanded defaults on quit)
- `.config/btop/themes/catppuccin_{macchiato,latte,frappe,mocha}.theme` - upstream Catppuccin btop themes from `catppuccin/btop` (btop ships no Catppuccin themes by default; auto-discovered from `$XDG_CONFIG_HOME/btop/themes/`)
- `.config/glow/glow.yml` - Glow Markdown renderer (auto theme, pager on, line numbers in TUI; XDG on both OSes because glow honors `$XDG_CONFIG_HOME` explicitly in `main.go`)
- `.config/tlrc/config.toml` - tlrc (tldr client) — show platform title, short+long flags (non-XDG on macOS, XDG on Linux; tlrc uses Rust `dirs::config_dir()` and ignores `$XDG_CONFIG_HOME` on Darwin)
- `.config/superfile/config.toml` - Superfile (`spf`) terminal file manager (Catppuccin Macchiato, bat preview with border, binary file sizes, zoxide integration; XDG on both OSes because spf reads `xdg.ConfigHome` from `adrg/xdg`, which honors the env var set in `.zprofile`)
- `.config/vscodium/settings.json` - VSCodium settings (JSONC format with comments; live target is `VSCodium/User/settings.json`)
- `.config/zed/settings.json` - Zed editor (Catppuccin Macchiato/Latte, JetBrains Mono, same UX as VSCodium, auto_install_extensions)
- `.config/claude/CLAUDE.md` - Claude Code user-level instructions (symlinked to `~/.claude/CLAUDE.md`)
- `.config/claude/settings.json` - Claude Code permissions (web, git, docker, build tools, sensitive file protection)
- `.config/ccstatusline/settings.json` - Claude Code status line layout (via ccstatusline)
- `.config/codex/AGENTS.md` - Codex user-level instructions (symlinked to `~/.codex/AGENTS.md`)
- `.config/codex/config.toml` - Codex CLI config (model, sandbox, plugins)
- `.config/codex/rules/{git,dev,shell,infra}.rules` - Codex permission rules (symlinked per file to `~/.codex/rules/`; new rule files require entries in both `scripts/symlinks.sh` and `scripts/validate.sh`)
- `defaults/` - Upstream defaults snapshots for offline comparison. Regenerate via `make snapshots` (local CLI: Ghostty + Starship + Bat; curl upstream `main`: Zed + Yazi + Superfile + Atuin; manual UI: VSCodium). Contents:
  - `vscodium-defaults.jsonc` - VSCodium defaults (identical to upstream VSCode, same Code OSS source; manual regen via `Preferences: Open Default Settings (JSON)`)
  - `zed-defaults.jsonc` - Zed defaults from upstream `zed-industries/zed@main` (NOT pinned to installed version; drift check approximate)
  - `ghostty-defaults.conf` - Ghostty annotated defaults (from `ghostty +show-config --default --docs`)
  - `bat-defaults.conf` - Bat annotated defaults (from `BAT_CONFIG_PATH=... bat --generate-config-file`; env override prevents clobbering `~/.config/bat/config`)
  - `starship-nerd-font-symbols.toml` - Starship preset baseline (from `starship preset nerd-font-symbols`; `.config/starship.toml` is a customized derivative)
  - `yazi-defaults.toml` - Yazi defaults from upstream `sxyazi/yazi@main` (NOT pinned to installed version)
  - `superfile-defaults.toml` - Superfile defaults from upstream `yorukot/superfile@main` (NOT pinned to installed version)
  - `atuin-defaults.toml` - Atuin client defaults from upstream `atuinsh/atuin@main` (NOT pinned to installed version)

Templates (not symlinked, import or copy as needed):

- `templates/bookmarks.html` - Netscape bookmark template (universal URLs only: GitHub `/pulls/*`, AI chats, web tools). One-shot import per project; rename `<Employer>` / `<Project>` folders after import. Folder semantics + import flow documented in README "Templates" section.

## Doc-drift checklist

When adding a new tool, config file, cask, or formula, update all of these in lockstep — missing any one causes documentation drift:

- **Install** — add line to `Brewfile` or `Brewfile.work` (tap, cask, brew, vscode, mas, go, uv, npm)
- **Linux equivalent** — when adding a `cask`, classify and document. Inspect the cask `.rb` source first (`brew info --json=v2 --cask <name>` for `ruby_source_path`, then fetch from `https://raw.githubusercontent.com/Homebrew/homebrew-cask/master/<path>`):
  - **Linux-installable via brew** — `.rb` declares `os macos: ..., linux: ...` block with `x86_64_linux`/`arm64_linux` sha256 entries AND uses `binary` artifact, OR uses `font` artifact with no `depends_on macos:`. These install on Linuxbrew via `brew install --cask <name>`. Add row to "Linux-installable casks" table in `docs/casks.md`. No native package step needed.
  - **GUI app with native deb/rpm** — vendor ships `.deb` + `.rpm` (apt/dnf repo or GitHub release).
  - **GUI app without official deb/rpm** — community Copr / community deb / tarball / install script.
  - **No Linux build at all** — `pkg`/`installer` artifact, or macOS-system-only tool (e.g. `rectangle`, `maccy`).
  - Every cask in `Brewfile` / `Brewfile.work` must appear in `docs/casks.md` Linux-installable table when it builds for Linux.
- **Symlink** — add `symlink <repo-src> <abs-dest>` call to `scripts/symlinks.sh` if the tool reads a config file from a fixed path
- **Vendored upstream assets** — when bundling external theme files, language grammars, or other drop-in assets (precedent: `catppuccin/btop` themes in `.config/btop/themes/`), symlink each file individually in `scripts/symlinks.sh` AND add each file to the symlink check in `scripts/validate.sh`. Do not symlink the parent directory.
- **README "Configuration files" list** — add bullet under `## Configuration files` if a config file is symlinked
- **README "CLI tools" table** — add row if user-facing CLI tool. **`docs/casks.md`** — add row if user-facing GUI cask.
- **README "Templates" table** — add row if introducing a new template file; describe folder semantics if introducing a new category
- **`docs/applications.md` table** — add row if GUI app fits an existing category, or add new category row
- **CLAUDE.md "Repository structure" list** — add bullet describing the file's purpose
- **`docs/conventions.md` tables** — add row(s) if the tool shares behavior (theme, font, tab size, hidden files, telemetry, auto-update, git pager, etc.) with existing tools
- **`scripts/validate.sh`** — extend the matching block (TOML/JSON/YAML/JSONC parse list, or symlink list) so `make validate` covers the new config
- **`.local.example.toml`** + **`scripts/local-overrides.py`** — if the tool grows a per-machine override (identity, private namespace, team marketplace, trusted path, etc.), extend the schema and the renderer. Tracked file stays neutral; real value lives in `.local/source.toml`.
- **`.gitignore`** (repo-root) — add path if the new tool spawns per-project local files (`.<tool>/settings.local.json`, `<TOOL>.local.md`, scratch-output dirs, etc.) that must stay out of the tracked tree on fresh clones, before `make symlinks` wires the global ignore. Mirror in `.config/git/ignore` only if the entry is also useful for unrelated projects.

When removing a tool, sweep the same list in reverse.

## Comment style in configs

When adding or editing config files, follow this style across all of them:

- **Drop top-of-file banners** — filename already states the file's purpose (no `# .zshrc - Interactive shell config` headers). Two exceptions: (1) location/operational notes for tools that ignore XDG and require non-obvious symlink targets (e.g. macOS `Library/Preferences/...`, `Library/Application Support/...`) are allowed since the symlink destination is not derivable from the filename; (2) a single-line upstream-docs URL pointer (e.g. `# https://ghostty.org/docs/config/reference` in `.config/ghostty/config`, `// https://zed.dev/docs/configuring-zed` in `.config/zed/settings.json`) is allowed when it helps locate the canonical config reference quickly.
- **Keep group dividers** — short single-line headers (`# Theme`, `# Cursor`, `# Git`) make long configs scannable. Use the same divider style as surrounding files (e.g. `// Name` in JSONC, `# Name` in TOML/conf, `# Name` shell).
- **Keep non-obvious why-comments** — workarounds, ordering constraints, parity with another tool, hidden invariants. Lead with the reason, not the restatement.
- **Drop tautology** — `# Enable completion` above `compinit`, `# Aliases` above an alias block where every line is `alias x=...` is fluff.
- **JSONC comment style** — use `// Name` (single-line) for section dividers in `.config/vscodium/settings.json` and `.config/zed/settings.json`. Do not use `/* Name */` block-style.
- **Trim verbose schema docs** — when a tool emits its config with full per-key docstrings (e.g. `gh config init`), strip them; keys are self-documenting.
- **Keep explicit default-restatement** — a value that matches the tool's current upstream default is an intentional baseline, not noise: the `defaults/` snapshots exist to make conscious-keep visible and to guard against an upstream default flip silently changing behavior. Drop a restated default only when it is genuinely inert (e.g. a light/dark split with both sides equal).
- **Plain JSON files (no comments allowed)** — micro's `settings.json` is parsed by Go's strict `encoding/json`, which rejects `//` and `/* */`. Use **blank lines** between key clusters for visual grouping; document the cluster meaning in this file. Current micro grouping: `tabsize`/`tabstospaces`/`autoindent`/`smartpaste` (indentation) → `rmtrailingws`/`eofnewline`/`fileformat`/`mkparents` (whitespace & save) → `syntax`/`cursorline`/`matchbrace`/`colorcolumn`/`scrollbar`/`scrollmargin`/`diffgutter`/`basename`/`hlsearch`/`hltrailingws`/`savecursor`/`wordwrap` (display) → `encoding` (encoding).

## Script behavior

### scripts/symlinks.sh

- Uses `symlink <repo-relative-src> <abs-dest>` helper (force symlink via `ln -sf`, auto-creates parent dirs). Overwrites existing symlinks.
- `DOTFILES_DIR` resolves to repo root via `cd "$(dirname "$0")/.." && pwd` (script lives one level deep in `scripts/`)
- Repo holds all source-of-truth configs under `.config/<tool>/`. Most tools are XDG-compliant on both OSes (single link target). Two tools (tlrc, vscodium) read from non-XDG paths on macOS and XDG on Linux; the script branches on `uname -s` (`case Darwin|Linux`):

  | Tool | macOS | Linux |
  |---|---|---|
  | tlrc | `~/Library/Application Support/tlrc/config.toml` | `~/.config/tlrc/config.toml` |
  | VSCodium | `~/Library/Application Support/VSCodium/User/settings.json` | `~/.config/VSCodium/User/settings.json` (capital `V`, not `vscode/`) |

  Why these two and not glow / superfile: `.zprofile` exports `XDG_CONFIG_HOME=$HOME/.config`, and both glow (`charmbracelet/glow` main.go `tryLoadConfigFromDefaultPlaces`, explicit `os.Getenv("XDG_CONFIG_HOME")` check) and superfile (`yorukot/superfile` via `adrg/xdg`, which honors the env var on darwin too) read from `$XDG_CONFIG_HOME/<tool>/` when the variable is set. tlrc uses the Rust `dirs::config_dir()` helper which ignores `$XDG_CONFIG_HOME` on macOS; override via `TLRC_CONFIG=PATH` env var only. VSCodium inherits Electron's hardcoded `app.getPath('userData')` from upstream VSCode (rebranded path: `VSCodium/User/` instead of `Code/User/`); override only via `codium --user-data-dir=PATH`. If a host has stale Library copies of glow/superfile from older repo revisions, delete them after `make symlinks` so the active config matches.

  Unknown OS prints a warning and skips this block. Claude/Codex use `~/.claude` and `~/.codex` on both OSes (non-XDG always); no branching needed there.
- Symlinks grouped by category (in this order): Shell → Shell tools (history/pager/system monitor/terminal/search/prompt/file manager) → Git/file tools → Editors → AI agents → platform-native paths. Within each group, tools are alphabetized. Add new symlinks under the matching group in alpha order. For tools with split macOS/Linux paths, add to both branches of the `case` block. Exception: vendored asset families (currently the four `catppuccin_*.theme` files under `.config/btop/themes/`) list the active variant first followed by the rest alphabetized, so the load-bearing file is visible at a glance; an inline comment in `scripts/symlinks.sh` flags the exception.

### scripts/local-overrides.py

- Single source of truth: `.local/source.toml` (gitignored). Schema example committed at `.local.example.toml`.
- First run with no `.local/source.toml` copies the example and exits, prompting the user to fill it in.
- Each run reads the clean base for each tracked target from `git show HEAD:<path>` so overrides apply to a known starting point and never compound across runs.
- Writes back to the tracked files enumerated in [README "Local overrides"](README.md#local-overrides) (same paths users' tools read via existing symlinks).
- Working-tree diff on those files after a run is intentional. The user keeps it uncommitted. A fresh `git pull` followed by `make local-overrides` restores the same state.
- Idempotent: re-running with the same `.local/source.toml` produces byte-identical output.
- Tracked configs ship with neutral placeholders (`your.email@example.com`, `github.com/your-org/*`, no team plugins, no trusted projects). Overrides upgrade them.
- **Schema asymmetry (intentional):** Claude has marketplace + plugin overrides (`[claude.marketplaces.<key>]` + `[claude].plugins`); Codex has only `[codex].trusted_projects`. Codex marketplaces and plugins must be added directly to `.config/codex/config.toml` (or registered via `codex plugin marketplace add` / `codex plugin install`) because the Codex CLI fixes the marketplace key at add-time and cannot rename it, so the shared-key model used for Claude does not map cleanly. Revisit if a second user needs per-machine Codex plugin overrides.

### scripts/macos-defaults.sh

- Non-interactive: applies all categories unconditionally (Folders, System defaults including Appearance = Dark, Screenshots, Finder + DS_Store suppression on network/USB, Dock)
- Restarts affected processes (Finder, Dock, SystemUIServer)
- Safe to re-run: idempotent `mkdir -p` and `defaults write` commands
- Guards `uname -s == Darwin`; exits 0 on Linux so the shared `make setup` chain stays safe to invoke cross-OS
- Power management intentionally omitted: `pmset` writes require sudo (no non-interactive path). On-demand sleep prevention via `keepingyouawake` cask (Brewfile) and `caffeinate` shell helper. Linux counterpart sets `sleep-inactive-ac-type = 'nothing'` via `gsettings` (no sudo); see `scripts/linux-defaults.sh`

### scripts/linux-defaults.sh

- Non-interactive: applies Folders, Input (touchpad + mouse natural scroll, keyboard repeat), Files/Nautilus (list view, hidden files, folders-first, recursive-search=never), Desktop (dash-to-dock click action, battery %, clock, color scheme `prefer-dark`, hot-corners enabled), Power (no AC suspend)
- Safe to re-run: idempotent `mkdir -p` plus `gsettings set` only when the schema/key exists (`set_if_exists` helper guards against missing GNOME components like `dash-to-dock`)
- Guards in order: `uname -s == Linux` → `command -v gsettings` → `XDG_CURRENT_DESKTOP` contains `GNOME`. Non-GNOME DEs (KDE, Sway, headless SSH) skip with a message
- No process restart needed (GNOME applies `gsettings` changes live)
- Screenshot folder: created at `~/Pictures/Screenshots` (XDG user-dir convention; matches GNOME Screenshot UI default and `make macos-defaults` on macOS)

## Shell aliases

Defined in `.zshrc`:

| Alias    | Command                                |
| -------- | -------------------------------------- |
| `kk`     | `kubectl`                              |
| `kx`     | `kubectx`                              |
| `kn`     | `kubens`                               |
| `c`      | `clear`                                |
| `terraform` | `tofu` (OpenTofu replaces Terraform; bypass with `command terraform` or `\terraform` when a repo hard-requires the HashiCorp binary) |
| `tf`     | `tofu` (short form)                    |
| `cat`    | `bat` (if installed)                   |
| `ls`     | `eza --icons=auto --group-directories-first`        |
| `ll`     | `eza` with git, timestamps, headers    |
| `lt`     | `eza` tree view (2 levels)             |
| `lr`     | `eza` sorted by modified (recent first) |

`ls`/`ll`/`lt`/`lr` require `eza` (in `Brewfile`); without it only `ll` is defined (as `ls -lah`).

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
btop --version                              # Primary system monitor TUI
htop --version                              # Classic process monitor
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

1. Parse every TOML (`.config/codex/config.toml`, atuin, yazi, starship, tlrc, superfile, `.local.example.toml`, `.local/source.toml` if present, and the snapshot TOMLs under `defaults/`)
2. Parse every plain JSON (claude/settings, micro, ccstatusline)
3. Parse every YAML (gh, lazygit, glow) — needs `yq`
4. Parse JSONC (zed, vscodium, and the snapshot JSONC under `defaults/`) — needs `node`
5. `brew bundle list --file=Brewfile{,.work}` (parse-only; install state reported separately as non-fatal warning) — needs `brew`
6. `ghostty +validate-config --config-file=.config/ghostty/config` — needs `ghostty`
7. `shellcheck` + `shfmt` on the `*.sh` scripts in `scripts/`, plus `ast.parse` syntax check on `scripts/local-overrides.py`
8. `zsh -n` on `.zshrc` and `.zprofile` (syntax-only; needs `zsh`)
9. Sanity grep on `.config/codex/rules/*.rules` (every non-comment, non-blank line must start with `prefix_rule(`)
10. `git config --file=.config/git/config --list` (INI parse; needs `git`)
11. Sanity grep on `.config/bat/config` and `.config/ripgrep/ripgreprc` (every non-comment, non-blank line must start with `--`; bat/rg silently ignore unknown flags so this catches the only bug class), and on `.config/btop/btop.conf` (every non-comment, non-blank line must contain `=`; btop silently falls back to defaults on unknown keys, so the `=` check is the only catchable bug class)
12. Verify every documented symlink under `$HOME` resolves (skips macOS-native paths on Linux)

When adding a new tool, extend the matching block in `scripts/validate.sh`.

**Web verification rule:** when a config key looks suspect (unfamiliar value, version-specific), confirm against the tool's official docs before flagging it as invalid. Examples that look wrong but are valid: Codex `model = "gpt-5.5"`/`gpt-5.4`/`gpt-5.4-mini`, Codex `personality = "friendly"`, Codex `[features].fast_mode`/`prevent_idle_sleep`/`personality` (the `[features].personality = true` gate pairs with the top-level `personality = "friendly"` value above), Codex `commit_attribution = ""` (empty disables the AI-attribution commit trailer), Codex `model_reasoning_effort`/`plan_mode_reasoning_effort = "xhigh"` (valid range, parallels Claude's `effortLevel`), Claude `effortLevel = "xhigh"`, Claude `model = "opus[1m]"`, atuin `inline_height_shell_up_key_binding`, atuin `enter_accept = false` (intentional default-flip: Enter selects/edits, doesn't auto-execute), atuin `keymap_mode = "auto"` (default is `emacs`; `auto` follows the shell keymap), ghostty `cursor-opacity`/`adjust-cursor-thickness`. All confirmed valid via vendor docs.

## VSCodium settings

When modifying `.config/vscodium/settings.json` (live target is `VSCodium/User/settings.json` on both macOS and Linux):

- Compare against `defaults/vscodium-defaults.jsonc` to check if a setting matches the default (keep explicit defaults — intentional). Regenerate via VSCodium `Preferences: Open Default Settings (JSON)` when stale (no CLI hook; `make snapshots` prints the manual step). Defaults identical to upstream VSCode (same Code OSS source tree).
- Settings use JSONC format (JSON with comments and trailing commas allowed)
- Section dividers use `// Name` (single-line) for parity with `.config/zed/settings.json`; do not use `/* Name */` block-style
- Section order: Theme → Workbench → Window → Font & Indentation → Cursor & Scrolling → Editor UX → Inline diagnostics (ErrorLens) → IntelliSense → Formatting → Search → Files → Terminal → Git → Testing & Debug → Go tooling → Python → JavaScript/TypeScript → Bash / Shell → AI → Updates → Telemetry → Workspace trust
- Configured for Go, Python, and Node.js backend development
- Uses Ruff for Python formatting/linting
- Marketplace = Open VSX (VSCodium ships pointed at `open-vsx.org`, not the Microsoft marketplace). Pylance, Remote-SSH, Live Share are MS-only with no Open VSX mirror — repo uses open replacements: `detachhead.basedpyright` (Pylance replacement), `jeanp413.open-remote-ssh` (Remote-SSH replacement). Live Share has no viable replacement. Dev Containers (`ms-azuretools.vscode-containers`) and the `ms-python.*` core mirror on Open VSX.
- Extensions install/export via `brew bundle` natively: `bundle/extensions/vscode_extension.rb` PATH-resolves `code → codium → cursor → code-insiders`, first match wins. Brewfile `vscode "..."` lines work unchanged against codium.

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
- Include 2-5 apps per platform column when possible (the Utilities catch-all row is exempt)
- Verify apps are actively maintained before adding
- Research community sentiment (Reddit, GitHub issues, HN) before adding new tools

## Conventions

Shared-behavior tables live in `docs/conventions.md`. Read that file when:

- Adding a new tool that overlaps an existing tool's behavior (theme, font, tab size, hidden files, telemetry, auto-update, git pager, scroll margin, cursor style, etc.)
- Changing a value already covered in any consistency table (must update the table + every other tool's matching setting)
- Auditing whether a tool drifted from the shared invariants

The doc holds the shared-behavior tables (theme, font, telemetry, git pager, tab size, scroll margin, cursor, italics, AI enablement, per-language tooling for Go/Python/TypeScript, update channels, exclusion lists, git settings, `EDITOR` env, Claude↔Codex command + plugin parity, marketplace IDs, Brewfile rules, Linux GUI packaging, and more). The `##` section headers in `docs/conventions.md` are the canonical index.

## Claude Code settings

The `.config/claude/settings.json` configures permissions and plugins:

- **Allowed:** Read-only git/gh/docker/kubectl subcommands; build/test/lint (`shellcheck`, `shfmt`, `pytest`, `mypy`, `pyright`, `pip-audit`, `ruff check/format`, `eslint`, `jest`, `prettier`, `tsc`, `vitest`, `npm test` + `npm run build/format/lint/test/typecheck`, `golangci-lint`, `go fmt/vet`, `gofmt`); dependency sync (`go mod tidy/download/graph/verify/why`, `uv sync/lock/build`, `npm ci/audit`) + dep queries (`uv pip list/show`, `uv tree`, `npm ls/list/outdated/view`); ephemeral runners (`uvx`, `uv run`, `npx` wrappers for the test/lint/format tools above); build runner (`make --dry-run`/`make -n`); version probes (`go version`, `uv/python/python3/node/npm --version`, `fnm list/current`); web search + fetch from dev docs (GitHub, Stack Overflow, MDN, Go/Python/Node/Terraform/Docker/Kubernetes/Claude docs); file search and inspection (`fd`, `rg`, `grep`, `find`, `which`, `bat`, `eza`, `head`, `tail`, `ls`, `wc`, `tldr`, `tree`, `file`, `readlink`, `realpath`, `stat`, `dust`, `exiftool`); structured data (`jq`, `yq`); text utils (`awk`, `basename`, `cut`, `diff`, `dirname`, `echo`, `printf`, `sed`, `sort`, `tr`, `uniq`); system info (`cd`, `date`, `false`, `ps`, `pwd`, `sleep`, `true`, `uname`); k8s context (`kubectx`, `kubens`); scratch dir (`mkdir -p /tmp/claude` exact only); clipboard (`pbcopy`, `wl-copy`). `go env` intentionally excluded (`go env -w` writes persistent config).
- **Sensitive-data protection:** No path-based deny in `settings.json` (removed for parity with Codex, which has no `deny_rule` mechanism in its schema). See trust-boundary note below.
- **Requires approval:** Arbitrary package install (`brew install`, `npm install`, `uv add`), direct code execution (`python`, `node`, `go run`), git writes, docker mutations
- **Sensitive-data trust boundary:** No path-based deny rules on either agent. Claude `Read(...)` deny was removed because Codex `prefix_rule` schema has no path-deny equivalent, and JSON-level deny on `Read` never covered the allowed `Bash(...)` readers (`bat`, `head`, `jq`, etc.) anyway. Actual protection on both agents is the model-level `## Sensitive Data` rule: `.config/claude/CLAUDE.md` for Claude, `.config/codex/AGENTS.md` for Codex. Same path set, same enforcement layer.
- **Enabled plugins:** source of truth is `enabledPlugins` in `.config/claude/settings.json`; category and Claude/Codex parity breakdown in [`docs/conventions.md`](docs/conventions.md).
- **Marketplace:** [caveman](https://github.com/JuliusBrussee/caveman) (auto-update enabled)
- **Status line:** Custom layout via [`ccstatusline`](https://www.npmjs.com/package/ccstatusline) (model, thinking effort, cwd, git branch, context %, session/weekly usage, cost)
- **Usage tracking:** [`ccstatusline`](https://www.npmjs.com/package/ccstatusline) surfaces session/weekly usage and cost in the status bar via the [`ccusage`](https://github.com/ryoppippi/ccusage) library it embeds. Run `npx ccusage` for ad-hoc cost reports.

See `.config/claude/settings.json` for the full permission list.

## Codex settings

The `.config/codex/config.toml` configures model selection, sandboxing, plugins, and MCP integrations:

- **Default behavior:** On-request approvals, `workspace-write` sandbox, cached web search by default, analytics/feedback disabled
- **Rules:** `.config/codex/rules/` defines allowed command groups for `git`, `dev`, `shell`, and `infra`
- **Scratch dir:** `/tmp/codex` (mirrors Claude's `/tmp/claude`; allow-listed in `.config/codex/rules/shell.rules` and mandated by `.config/codex/AGENTS.md` `## Scratch Files`)
- **Enabled plugins:** source of truth is the `[plugins.*]` blocks in `.config/codex/config.toml`; category and Claude/Codex parity breakdown in [`docs/conventions.md`](docs/conventions.md).
- **Marketplaces:** [caveman-repo](https://github.com/JuliusBrussee/caveman) (source for caveman) and [context7-marketplace](https://github.com/upstash/context7) (source for context7). Both git-backed.
- **Connectors via plugins:** atlassian-rovo, datadog, posthog use the OpenAI-curated app-connector model (`.app.json` references a hosted connector ID); context7 ships as a Codex plugin from the `context7-marketplace` git source and references the vendor's hosted MCP endpoint at `https://mcp.context7.com/mcp` internally. No `[mcp_servers.*]` blocks needed in `config.toml`; enabling the plugin is the connection.
- **Web search / fetch asymmetry (vs Claude):** Codex uses a global `web_search = "cached"` toggle in `config.toml` (options: `disabled` | `cached` | `live`; default `cached`); per-domain fetch allowlists are not in the Codex schema. Claude's per-domain `WebFetch(domain:...)` entries in `settings.json` have no Codex counterpart by design.

See `.config/codex/config.toml` and `.config/codex/rules/` for the full configuration.
