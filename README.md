# Dotfiles

Dotfiles configured with **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme and **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go** (via Homebrew), **Python** (via `uv`), and **Node.js** (via `fnm`).

## Contents

- [Quick start](#quick-start)
- [Prerequisites](#prerequisites)
  - [Local overrides](#local-overrides)
- [Configuration files](#configuration-files)
- [macOS settings](#macos-settings)
- [Linux settings](#linux-settings)
- [macOS tips](docs/macos-tips.md) — non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers)
- [Linux tips](docs/linux-tips.md) — non-obvious shortcuts and behaviors for GNOME-on-Wayland (clipboard, screenshots, Nautilus, workspaces, GNOME search, cross-device sharing, shell helpers, Wayland notes, per-distro deltas)
- [Applications](docs/applications.md) — curated GUI app picks by category (cross-platform where possible, macOS as tie-breaker lens), VSCodium setup, search engine bangs
- [Backup plan](docs/backup-plan.md) — personal data protection plan: threat model, data inventory, setup actions, monthly/quarterly/yearly rituals, recovery playbook
- [CLI tools](#cli-tools)
- [Validate](#validate)
- [Updating](#updating)
- [Casks](docs/casks.md) — Homebrew Cask inventory (base, work, Linux-installable)
- [Claude Code](#claude-code)
- [Codex](#codex)
- [Templates](#templates)

## Quick start

### macOS

1. Complete [Prerequisites → macOS](#macos).
2. Clone this repository.
3. Run `make setup` (base) or `make setup-all` (base + work). `setup` chains `macos-defaults` → `linux-defaults` (no-op) → `symlinks` → `local-overrides` → `brew-install-base` → `versions`. `setup-all` swaps in `brew-install` for the base+work superset.

### Linux (GNOME)

1. Complete [Prerequisites → Linux](#linux).
2. Clone this repository.
3. Run `make setup` (base) or `make setup-all` (base + work). Same chain as macOS: `macos-defaults` (no-op on Linux) → `linux-defaults` applies GNOME `gsettings` → `symlinks` → `local-overrides` → `brew-install-base` installs formulae + the Linux-installable cask subset (`docs/casks.md`) → `versions`. `setup-all` swaps in `brew-install` for the base+work superset. Every `Brewfile.work` cask lacks a Linuxbrew build, so on Linux `brew-install-work` is effectively a no-op for casks; install work GUIs via vendor deb/rpm.
4. Install GUI apps via vendor `.deb` / `.rpm`.

Run `make help` to list all available targets.

## Prerequisites

### macOS

> Apple Silicon only. Homebrew prefix defaults to `/opt/homebrew` in `.zshrc` / `.zprofile` (override via `BREW_PREFIX` env), but Intel `/usr/local` layout is not tested or supported.

- **Install Xcode Command Line Tools:** git, make, grep, tar etc.
  ```bash
  xcode-select --install
  ```
- **Install Homebrew**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- **Generate SSH key for Git**
  ```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
  pbcopy < ~/.ssh/id_ed25519.pub
  ```
- **Configure sudo with Touch ID** — see [`docs/macos-tips.md`](docs/macos-tips.md#sudo-with-touch-id) for the one-time `pam_tid.so` setup.

### Linux

> Targets Fedora, Silverblue, Bluefin, Vanilla OS, Zorin OS, Ubuntu. All GNOME-on-Wayland: `make linux-defaults` writes `gsettings` keys that apply across the set; see [`docs/linux-tips.md`](docs/linux-tips.md) for per-distro deltas. Atomic variants (Bluefin, Silverblue, Vanilla OS) work too, but extra packages must be layered via `rpm-ostree` / `bootc` (Fedora atomics) or `apx` / `vso` (Vanilla OS), or installed inside Distrobox/Toolbox, instead of `dnf` / `apt`. KDE / Sway / headless sessions skip the `gsettings` block but everything else (symlinks, Brewfile, shell) applies. Linuxbrew prefix defaults to `/home/linuxbrew/.linuxbrew` in `.zshrc` / `.zprofile` (override via `BREW_PREFIX` env).

- **Install build prerequisites:** `scripts/local-overrides.py` needs Python 3.11+ (stdlib `tomllib`); older distros are out of scope.
  ```bash
  # Debian/Ubuntu (Zorin OS)
  sudo apt-get update
  sudo apt-get install -y build-essential procps curl file git zsh python3

  # Fedora
  sudo dnf install -y @development-tools procps-ng curl file git zsh python3

  # Silverblue / Bluefin (atomic; layer once, then reboot)
  sudo rpm-ostree install zsh

  # Vanilla OS (atomic; layer via apx on host subsystem)
  sudo apx install --sysprefix vso-core zsh git python3
  ```
- **Install Homebrew (Linuxbrew)**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  ```
- **Set zsh as login shell** (`.zprofile` / `.zshrc` are sourced only by zsh)
  ```bash
  chsh -s "$(command -v zsh)"
  ```
- **Generate SSH key for Git**
  ```bash
  ssh-keygen -t ed25519 -C "your_email@example.com"
  # Pipe pubkey to clipboard: wl-copy < ~/.ssh/id_ed25519.pub  (Wayland)
  #                          xclip -selection clipboard < ~/.ssh/id_ed25519.pub  (X11)
  ```
- **Install GUI apps via vendor deb/rpm.** Vendor packages respect `~/.config/<tool>/`, so the repo's symlinks resolve without the per-app sandbox path remap that Flatpak / Snap impose. Flatpak stays an option for one-shot apps that have no config in this repo (see [`docs/linux-tips.md`](docs/linux-tips.md) for examples).
- **GNOME-only defaults:** `make linux-defaults` skips silently outside GNOME (`XDG_CURRENT_DESKTOP` check). Other DEs configure their own way.

### Local overrides

Per-machine data (git identity, `GOPRIVATE`, Claude team marketplaces/plugins, Codex trusted projects) is kept in a single gitignored file and rendered into the tracked configs by a setup-time script. Tracked configs ship with neutral placeholders; the script injects real values on each `make setup` (or standalone `make local-overrides`).

1. First run inside `make setup` creates `.local/source.toml` from `.local.example.toml`, prints a fill-in prompt to stderr, and returns 0 so the rest of the chain (`brew-install-base`, `versions`) continues with neutral placeholders. Edit `.local/source.toml` with your values, then re-run `make local-overrides` to inject them. Schema sections: `[git]`, `[go]`, `[claude.marketplaces.<key>]`, `[claude].plugins`, `[codex].trusted_projects`.
2. Re-run `make local-overrides`. The script reads the clean base from `git show HEAD:<path>` for each tracked target, applies the overrides, and writes back to:
   - `.config/git/config` — `[user]` block replaced
   - `.zprofile` — `GOPRIVATE` line replaced
   - `.config/claude/settings.json` — `extraKnownMarketplaces` and `enabledPlugins` extended
   - `.config/codex/config.toml` — `[projects."<path>"]` blocks appended
3. The resulting working-tree diff on those files is intentional. **Do not commit it.** Each run reads from HEAD, so overrides never compound and a fresh `git pull` + re-run keeps state consistent.

`.local/` is gitignored; `.local.example.toml` is the committed schema source. `make setup` and `make setup-all` chain `local-overrides` after `symlinks` so a clean clone reaches the configured state in one command.

## Configuration files

### Symlinked

The following files are automatically symlinked by running `make symlinks`:

- `.zprofile` - Shell environment variables
- `.zshrc` - Shell configuration and aliases
- `.config/git/config` - Git user and global settings (XDG path)
- `.config/git/ignore` - Global gitignore (XDG path)
- `.config/ripgrep/ripgreprc` - Ripgrep defaults (smart-case, hidden files, follow symlinks); resolved via `RIPGREP_CONFIG_PATH`
- `.config/ghostty/config` - Ghostty configuration
- `.config/starship.toml` - Starship configuration (flat path per starship.rs)
- `.config/bat/config` - Bat configuration
- `.config/gh/config.yml` - GitHub CLI settings
- `.config/lazygit/config.yml` - Lazygit settings
- `.config/micro/settings.json` - Micro editor settings
- `.config/yazi/yazi.toml` - Yazi file manager settings
- `.config/atuin/config.toml` - Atuin shell history settings
- `.config/btop/btop.conf` - btop system monitor (theme + anti-bloat flag)
- `.config/btop/themes/catppuccin_*.theme` - Catppuccin theme files (macchiato/latte/frappe/mocha) from `catppuccin/btop`
- `.config/glow/glow.yml` - Glow Markdown renderer settings (XDG path on both OSes; glow honors `$XDG_CONFIG_HOME` exported by `.zprofile`)
- `.config/tlrc/config.toml` - tlrc (tldr client) settings (macOS: `~/Library/Application Support/tlrc/config.toml`, Linux: `~/.config/tlrc/config.toml`; tlrc ignores `$XDG_CONFIG_HOME` on Darwin via the Rust `dirs` crate)
- `.config/superfile/config.toml` - Superfile (`spf`) terminal file manager settings (XDG path on both OSes; spf reads `xdg.ConfigHome` via adrg/xdg, honors `$XDG_CONFIG_HOME`)
- `.config/vscodium/settings.json` - VSCodium configuration (macOS: `~/Library/Application Support/VSCodium/User/settings.json`, Linux: `~/.config/VSCodium/User/settings.json`; VSCodium inherits Electron `app.getPath('userData')` from upstream VSCode and ignores `$XDG_CONFIG_HOME` on Darwin)
- `.config/zed/settings.json` - Zed editor settings
- `.config/claude/settings.json` - Claude Code permissions
- `.config/claude/CLAUDE.md` - Claude Code user-level instructions
- `.config/ccstatusline/settings.json` - Claude Code status line layout
- `.config/codex/config.toml` - Codex CLI config (model, sandbox, plugins)
- `.config/codex/AGENTS.md` - Codex user-level instructions
- `.config/codex/rules/{git,dev,shell,infra}.rules` - Codex permission rules (linked per file; add new rule files to `scripts/symlinks.sh` and `scripts/validate.sh`)

### Not symlinked

Used directly from the repo:

- `Brewfile` - Base Brewfile (shell, fonts, daily-driver apps, VSCodium extensions, go dev tools)
- `Brewfile.work` - Work Brewfile (work-specific GUIs — API client, K8s GUI, DB GUI, container runtime, comms, VPN, browser; curated manually)
- `CLAUDE.md` - Repository instructions for Claude Code (auto-discovered in cwd; Codex reads it via `project_doc_fallback_filenames`)
- `defaults/` - Upstream defaults snapshots for offline drift comparison. Regenerate via `make snapshots` (curl-fetched snapshots track `main`, not the installed version; the VSCodium one is a manual export). CLAUDE.md "Repository structure" lists each file and its regen path.
- `.local.example.toml` - Schema for per-machine overrides; copy to `.local/source.toml` (gitignored) and fill in. See [Local overrides](#local-overrides).

## macOS settings

Run `make macos-defaults` to configure (in order applied):

- Folders (~/Projects, ~/Pictures/Screenshots)
- System defaults (key repeat via `ApplePressAndHoldEnabled=false` at OS-default rate/delay, natural scrolling, save to disk by default, Appearance = Dark). Linux pins explicit 250ms delay / 30ms interval; macOS intentionally inherits OS-default rate to avoid surprising existing users.
- Screenshots (save to ~/Pictures/Screenshots, no shadow, PNG, floating thumbnail enabled)
- Finder (list view, path bar, show extensions, folders first, search current folder, suppress DS_Store on network/USB volumes)
- Dock (autohide, no recents, scale minimize effect, minimized windows in own Dock slot, fixed Spaces order, Cmd-gated hot corners: TL Mission Control / TR Notification Center / BL Desktop / BR Quick Note)

No-op on Linux (script guards `uname -s == Darwin`).

## Linux settings

Run `make linux-defaults` to configure (GNOME via `gsettings`):

- Folders (~/Projects, ~/Pictures/Screenshots)
- Input (touchpad + mouse natural scroll, keyboard repeat enabled with 250ms delay / 30ms interval)
- Files / Nautilus (list view, hidden files, folders-first, search current folder only)
- Desktop (dash-to-dock click=minimize when extension present, battery %, clock weekday, `prefer-dark` color scheme, hot-corners enabled — single GNOME top-left corner triggers Activities)
- Power (disable AC auto-suspend)

Guards: skips silently on non-Linux, when `gsettings` missing, or when `XDG_CURRENT_DESKTOP` is not GNOME. KDE / Sway / headless sessions are unaffected.

`gsettings` writes to user-scope dconf; safe to re-run (`set_if_exists` helper checks schema existence before each write).

## macOS tips

Non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers): see [`docs/macos-tips.md`](docs/macos-tips.md).

## Linux tips

Non-obvious shortcuts and behaviors for GNOME-on-Wayland distros (clipboard, screenshots, Nautilus, workspaces, GNOME search, cross-device sharing, shell helpers, Wayland notes, per-distro deltas for Fedora/Silverblue/Bluefin, Vanilla OS, Zorin, Ubuntu): see [`docs/linux-tips.md`](docs/linux-tips.md).

## Applications

Curated GUI app picks by category, VSCodium setup, and search engine bangs: see [`docs/applications.md`](docs/applications.md).

## CLI tools

Installed via Homebrew formulae and casks (see `Brewfile` and `Brewfile.work`):

```bash
make brew-install       # Install all packages (base + work)
make brew-install-base  # Install base packages only
make brew-install-work  # Install work packages only
make brew-cleanup       # Clean up old versions and cache
make brew-export        # Export installed packages (incl. VSCodium extensions) to Brewfile (macOS only), then strip Brewfile.work entries; add new work entries to Brewfile.work manually
make versions           # Show installed Go, Node, Python versions
make local-overrides    # Render per-machine overrides from .local/source.toml; see Local overrides
make snapshots          # Regenerate defaults/* upstream-defaults snapshots
```

CLI binaries shipped via casks (`op` from `1password-cli`, `claude`, `codex`) live in [`docs/casks.md`](docs/casks.md).

| Tool                    | Description                                             |
| ----------------------- | ------------------------------------------------------- |
| argocd                  | Argo CD CLI (Kubernetes GitOps)                         |
| atuin                   | Shell history sync + Ctrl+R replacement                 |
| awscli                  | AWS command-line interface                              |
| bat                     | `cat` with syntax highlighting                          |
| btop                    | System monitor TUI (mouse + charts + GPU panels)        |
| buf                     | Modern Protocol Buffers toolkit (lint, breaking, gen)   |
| delve                   | Go debugger (binary: `dlv`)                             |
| dust                    | Visual `du` tree printer (one-shot disk usage)          |
| exiftool                | Read/write image/audio/video metadata                   |
| eza                     | Modern `ls` replacement                                 |
| fd                      | Modern `find` replacement                               |
| fnm                     | Fast Node Manager (auto-switches via `.node-version`)   |
| fx                      | Terminal JSON viewer / processor                        |
| fzf                     | Fuzzy finder (Ctrl+T files, Alt+C dirs)                 |
| gh                      | GitHub CLI                                              |
| git                     | Distributed version control                             |
| git-delta               | Syntax-highlighting git pager (replaces `less`)         |
| git-lfs                 | Git Large File Storage extension                        |
| glow                    | Terminal Markdown renderer                              |
| go                      | Go toolchain (via Homebrew)                             |
| golangci-lint           | Go meta-linter                                          |
| goose                   | Go database migration tool                              |
| gopls                   | Go language server                                      |
| gotests                 | Go test boilerplate generator                           |
| helm                    | Kubernetes package manager                              |
| htop                    | Classic process monitor (universal fallback)            |
| impl                    | Go interface method stub generator                      |
| jq                      | Command-line JSON processor                             |
| k9s                     | Kubernetes TUI                                          |
| kubectx                 | Kubernetes context switcher (ships kubens for namespaces) |
| kubernetes-cli          | Kubernetes CLI (binary: `kubectl`)                      |
| kustomize               | Kubernetes manifest overlays/patches                    |
| lazydocker              | Docker TUI                                              |
| lazygit                 | Git TUI                                                 |
| lazysql                 | Multi-engine SQL TUI                                    |
| libpq                   | PostgreSQL client libs (`psql`, `pg_dump`; pgcli dep)   |
| litecli                 | SQLite CLI with autocomplete                            |
| micro                   | Terminal text editor                                    |
| mockgen                 | Go mock generator (`go.uber.org/mock`)                  |
| mongosh                 | MongoDB shell                                           |
| ncdu                    | Interactive disk usage analyzer (classic, Zig)          |
| opentofu                | Terraform fork (OSS; aliased `terraform → tofu`)        |
| pgcli                   | PostgreSQL CLI with autocomplete                        |
| pyright                 | Python static type checker (Microsoft)                  |
| ripgrep                 | Fast `grep` replacement                                 |
| ruff                    | Python linter / formatter (Rust)                        |
| sevenzip                | 7-Zip file archiver                                     |
| shellcheck              | Shell script static analyzer                            |
| shfmt                   | Shell script formatter                                  |
| starship                | Cross-shell prompt                                      |
| superfile               | Modern terminal file manager (alternative to yazi)      |
| swag                    | Swagger 2.0 doc generator for Go                        |
| tlrc                    | `tldr` client (Rust); binary is `tldr`                  |
| typescript              | TypeScript compiler (`tsc`)                             |
| typescript-language-server | TypeScript / JavaScript language server              |
| uv                      | Python version/package manager                          |
| yazi                    | Terminal file manager                                   |
| yq                      | Command-line YAML processor                             |
| zoxide                  | Smarter `cd` (learns from usage)                        |
| zsh-autosuggestions     | Fish-like command suggestions                           |
| zsh-completions         | Additional shell completions                            |
| zsh-syntax-highlighting | Command syntax highlighting                             |

## Validate

After `make setup`, verify everything wired up:

- `make versions` — Go / Node / Python toolchains print
- `git config --list --show-origin | head -5` — settings come from `~/.config/git/config`
- `ls -l ~/.config/ghostty/config ~/.zshrc ~/.config/git/config` — symlinks point at this repo

For full audit, run `make validate` (delegates to `scripts/validate.sh`): it parses every config (TOML/JSON/YAML/JSONC), checks the Brewfiles and ghostty, lints the shell scripts, and verifies symlinks resolve (skipping macOS-native paths on Linux). See CLAUDE.md "Config validation" for the per-check breakdown.

## Updating

- `brew update && brew upgrade` — update Homebrew formulae and casks
- `make brew-export` — refresh `Brewfile` from current install state (macOS only; Linuxbrew install state would wipe macOS-only casks). Add new work entries to `Brewfile.work` manually; see `docs/conventions.md` "Brewfile maintenance" for strip step semantics.
- `make brew-cleanup` — prune old versions and cache
- macOS GUI apps: cask auto-update via `brew upgrade` (for example VSCodium, Brave, Ghostty, Zed, Claude Code, Codex, IINA, Obsidian, Telegram, WhatsApp also have their own in-app updaters; cask still authoritative)
- Linux GUI apps: per-app update channels (vendor apt/dnf, in-app updater, GitHub release, manual vendor download) covered in [`docs/linux-tips.md` "Per-app update channels"](docs/linux-tips.md#per-app-update-channels).
- Go: `brew upgrade go`. Node: `fnm install <version> && fnm default <version>` (or rely on per-dir `.node-version`). Python: `uv python install <version>` (uv selects per project).

## Casks

Homebrew Cask inventory (base, work, Linux-installable subset): see [`docs/casks.md`](docs/casks.md).

## Claude Code

`.config/claude/settings.json` configures permissions and plugins. Full breakdown (allowed tools, approval policy, sensitive-data trust boundary, enabled plugins, marketplace, status line via [`ccstatusline`](https://www.npmjs.com/package/ccstatusline) and [`ccusage`](https://github.com/ryoppippi/ccusage)) in [`CLAUDE.md` "Claude Code settings"](CLAUDE.md#claude-code-settings).

## Codex

`.config/codex/config.toml` configures model selection, sandboxing, plugins, and MCP integrations. Full breakdown (approval/sandbox defaults, command rules, enabled plugins, marketplaces, plugin-based connectors, web-search asymmetry vs Claude) in [`CLAUDE.md` "Codex settings"](CLAUDE.md#codex-settings).

## Templates

One-shot starter files for new projects. Not symlinked — import or copy as needed.

| File                       | Format             | Usage                                                |
| -------------------------- | ------------------ | ---------------------------------------------------- |
| `templates/bookmarks.html` | Netscape bookmarks | Browser Bookmarks Manager → Import. See folder semantics below. |

### Bookmarks template

One-shot bookmark file for new project setup. Import once per project, rename the `<Employer>` / `<Project>` folders to match the engagement.

**Import flow:**

1. Browser → Bookmarks Manager → Import → select `templates/bookmarks.html`.
2. Rename `<Employer>` / `<Project>` folders to match the current engagement.
3. Fill `Services`, `Dev`, `Stage`, `Prod` with org/project URLs (template ships universal URLs only).

**Folder contents:**

- **`<Employer>`** — Employer-wide accounts shared across all client projects. Personal mail, calendar, timetracking, HR portal, employer-wide tools.
- **`<Project>`** — Client/project-specific daily hits. Project mail/calendar, Jira board, GitHub PR queues, planning poker, most-used Confluence pages.
- **`Services`** — Third-party SaaS dashboards with a single URL (no per-env split). Observability, analytics, feature flags, cloud DB console, payments, IdP, cloud SSO, VPN, secrets manager.
- **`Dev`** — `*.dev.<domain>` URLs (one entry per env-specific service). Web portal, admin panel, API, GitOps console, mail catcher, broker console, internal tooling.
- **`Stage`** — `*.staging.<domain>` mirror of `Dev`.
- **`Prod`** — `*.<domain>` mirror of `Dev`. Read-only / restricted access in practice.
- **`AI`** — LLM chat entrypoints. ChatGPT, Claude, Gemini new-chat URLs + status pages.
- **`Tools`** — One-shot web utilities. Regex tester, cron parser, JWT decoder, epoch converter, time zone, diagram editors, API tester.

**Google account slots:** Gmail/Calendar URLs use `/u/0/` (first signed-in account, employer) and `/u/1/` (second, project). Swap the slot index to reorder.
