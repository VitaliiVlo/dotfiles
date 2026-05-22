# Dotfiles

Dotfiles configured with **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme and **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go 1.26**, **Python** (via `uv`), and **Node.js** (via `fnm`).

## Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Configuration Files](#configuration-files)
- [macOS Settings](#macos-settings)
- [Linux Settings](#linux-settings)
- [macOS Tips](docs/macos-tips.md) — non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers)
- [Applications](docs/applications.md) — curated GUI app picks by category, VSCode setup, search engine bangs
- [CLI Tools](#cli-tools)
- [Validate](#validate)
- [Updating](#updating)
- [Casks](docs/casks.md) — Homebrew Cask inventory (base, work, Linux-installable)
- [Flatpaks](docs/flatpaks.md) — Flathub inventory for Linux, paired with casks
- [Claude Code](#claude-code)
- [Codex](#codex)
- [Templates](#templates)

## Quick Start

### macOS

1. Complete [Prerequisites → macOS](#macos).
2. Clone this repository.
3. Run `make setup` (base) or `make setup-all` (base + work) to configure macOS defaults, symlink configs, install brews + casks, and show versions. `flatpaks-install` runs in the chain but no-ops on macOS.

### Linux (GNOME)

1. Complete [Prerequisites → Linux](#linux).
2. Clone this repository.
3. Run `make setup` (base) or `make setup-all` (base + work). `defaults` (macOS) no-ops; `linux-defaults` applies GNOME `gsettings`; `brew-install` installs formulae + the Linux-installable cask subset (`docs/casks.md`); `flatpaks-install` installs Flathub apps at user scope.

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
- **Configure sudo with Touch ID**
  ```bash
  sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
  sudo nano /etc/pam.d/sudo_local
  # Uncomment: auth sufficient pam_tid.so
  ```

### Linux

> Tested on GNOME-based distros (Ubuntu, Fedora, Pop!\_OS). KDE / Sway sessions skip the `gsettings` defaults block but everything else applies. Linuxbrew prefix defaults to `/home/linuxbrew/.linuxbrew` in `.zshrc` / `.zprofile` (override via `BREW_PREFIX` env).

- **Install build prerequisites** (Debian/Ubuntu shown; substitute equivalents on Fedora/Arch):
  ```bash
  sudo apt-get update
  sudo apt-get install -y build-essential procps curl file git zsh flatpak
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
- **GNOME-only defaults:** `make linux-defaults` skips silently outside GNOME (`XDG_CURRENT_DESKTOP` check). Other DEs configure their own way.

## Configuration Files

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
- `.config/bottom/bottom.toml` - Bottom (`btm`) system monitor settings
- `.config/glow/glow.yml` - Glow Markdown renderer settings
- `.config/tlrc/config.toml` - tlrc (tldr client) settings (linked into Library/Application Support/tlrc)
- `.config/superfile/config.toml` - Superfile (`spf`) terminal file manager settings (linked into Library/Application Support/superfile)
- `.config/vscode/settings.json` - VSCode configuration (linked into `Library/Application Support/Code/User`)
- `.config/zed/settings.json` - Zed editor settings
- `.config/claude/settings.json` - Claude Code permissions
- `.config/claude/CLAUDE.md` - Claude Code user-level instructions
- `.config/ccstatusline/settings.json` - Claude Code status line layout
- `.config/codex/config.toml` - Codex CLI config (model, sandbox, plugins)
- `.config/codex/AGENTS.md` - Codex user-level instructions
- `.config/codex/rules/` - Codex permission rules (git, dev, shell, infra)

**Not symlinked (used directly from repo):**

- `Brewfile` - Base Brewfile (shell, fonts, daily-driver apps, VSCode extensions)
- `Brewfile.work` - Work Brewfile (work-specific GUIs — API client, K8s GUI, DB GUI, container runtime, comms, VPN; curated manually)
- `flatpaks` - Base Flathub app IDs for Linux (paired with `Brewfile` casks where an equivalent exists)
- `flatpaks.work` - Work Flathub app IDs for Linux (paired with `Brewfile.work` casks; curated manually)
- `scripts/flatpaks-install.sh` - Installs `flatpaks` / `flatpaks.work` at user scope (Linux only, no-op on macOS)
- `CLAUDE.md` - Repository instructions for Claude Code (auto-discovered in cwd; Codex reads it via `project_doc_fallback_filenames`)
- `docs/vscode-defaults.jsonc` - VSCode defaults snapshot for offline comparison (regenerate via `Preferences: Open Default Settings (JSON)`)

## macOS Settings

Run `make defaults` to configure (in order applied):

- Folders (~/Projects, ~/Screenshots)
- System defaults (key repeat, natural scrolling, save to disk)
- Screenshots (save to ~/Screenshots, no shadow, PNG)
- Finder (list view, path bar, show extensions, folders first, search current folder)
- Dock (autohide, no recents, scale minimize effect, minimized windows in own Dock slot, fixed Spaces order, Cmd-gated hot corners: TL Mission Control / TR Notification Center / BL Desktop / BR Quick Note)

No-op on Linux (script guards `uname -s == Darwin`).

## Linux Settings

Run `make linux-defaults` to configure (GNOME via `gsettings`):

- Folders (~/Projects, ~/Screenshots)
- Input (touchpad + mouse natural scroll, keyboard repeat enabled with 250ms delay / 30ms interval)
- Files / Nautilus (list view, hidden files, folders-first, search current folder only)
- Desktop (dash-to-dock click=minimize when extension present, battery %, clock weekday, `prefer-dark` color scheme)
- Power (disable AC auto-suspend)

Guards: skips silently on non-Linux, when `gsettings` missing, or when `XDG_CURRENT_DESKTOP` is not GNOME. KDE / Sway / headless sessions are unaffected.

`gsettings` writes to user-scope dconf; safe to re-run (`set_if_exists` helper checks schema existence before each write).

## macOS Tips

Non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers): see [`docs/macos-tips.md`](docs/macos-tips.md).

## Applications

Curated GUI app picks by category, VSCode setup, and search engine bangs: see [`docs/applications.md`](docs/applications.md).

## CLI Tools

Installed via Homebrew formulae and casks (see `Brewfile` and `Brewfile.work`):

```bash
make brew-install       # Install all packages (base + work)
make brew-install-base  # Install base packages only
make brew-install-work  # Install work packages only
make brew-cleanup       # Clean up old versions and cache
make brew-export        # Export installed packages (incl. VSCode extensions) to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually
make versions           # Show installed Go, Node, Python versions
```

| Tool                    | Description                                             |
| ----------------------- | ------------------------------------------------------- |
| argocd                  | Argo CD CLI (Kubernetes GitOps)                         |
| atuin                   | Shell history sync + Ctrl+R replacement                 |
| awscli                  | AWS command-line interface                              |
| bat                     | `cat` with syntax highlighting                          |
| bottom                  | System monitor TUI (`btm`, modern `htop`)               |
| dua-cli                 | Interactive disk usage analyzer (alternative to gdu)    |
| exiftool                | Read/write image/audio/video metadata                   |
| eza                     | Modern `ls` replacement                                 |
| fd                      | Modern `find` replacement                               |
| fnm                     | Fast Node Manager (auto-switches via `.node-version`)   |
| fx                      | Terminal JSON viewer / processor                        |
| fzf                     | Fuzzy finder (Ctrl+T files, Alt+C dirs)                 |
| gdu                     | Fast parallel disk usage analyzer (Go)                  |
| gh                      | GitHub CLI                                              |
| git                     | Distributed version control                             |
| git-delta               | Syntax-highlighting git pager (replaces `less`)         |
| git-lfs                 | Git Large File Storage extension                        |
| gitui                   | Git TUI (Rust, alternative to lazygit)                  |
| glow                    | Terminal Markdown renderer                              |
| go                      | Go toolchain (1.26)                                     |
| helm                    | Kubernetes package manager                              |
| jq / yq                 | JSON / YAML processors                                  |
| k9s                     | Kubernetes TUI                                          |
| kdash                   | Kubernetes dashboard TUI (Rust)                         |
| kubectl                 | Kubernetes CLI                                          |
| kustomize               | Kubernetes manifest overlays/patches                    |
| lazydocker              | Docker TUI                                              |
| lazygit                 | Git TUI                                                 |
| lazysql                 | Multi-engine SQL TUI                                    |
| litecli                 | SQLite CLI with autocomplete                            |
| micro                   | Terminal text editor                                    |
| pgcli                   | PostgreSQL CLI with autocomplete                        |
| protobuf                | Protocol Buffers compiler (`protoc`)                    |
| rainfrog                | Postgres/MySQL/SQLite database TUI (alternative to lazysql) |
| ripgrep                 | Fast `grep` replacement                                 |
| sevenzip                | 7-Zip file archiver                                     |
| shellcheck              | Shell script static analyzer                            |
| shfmt                   | Shell script formatter                                  |
| starship                | Cross-shell prompt                                      |
| superfile               | Modern terminal file manager (alternative to yazi)      |
| tlrc                    | `tldr` client (Rust); binary is `tldr`                  |
| uv                      | Python version/package manager                          |
| yazi                    | Terminal file manager                                   |
| zoxide                  | Smarter `cd` (learns from usage)                        |
| zsh-autosuggestions     | Fish-like command suggestions                           |
| zsh-completions         | Additional shell completions                            |
| zsh-syntax-highlighting | Command syntax highlighting                             |

## Validate

After `make setup`, verify everything wired up:

- `make versions` — Go / Node / Python toolchains print
- `git config --list --show-origin | head -5` — settings come from `~/.config/git/config`
- `ls -l ~/.config/ghostty/config ~/.zshrc ~/.config/git/config` — symlinks point at this repo

For full audit, run `make validate` (delegates to `scripts/validate.sh`). Covers TOML/JSON/YAML/JSONC parse, `brew bundle check`, flatpaks ID lint, `shellcheck`, and symlink resolution. Skips macOS-native symlinks on Linux.

## Updating

- `brew update && brew upgrade` — update Homebrew formulae and casks
- `make brew-export` — refresh `Brewfile` from current install state (then add any new work entries to `Brewfile.work` manually; see `docs/consistency.md` "Brewfile maintenance" for strip step semantics)
- `make brew-cleanup` — prune old versions and cache
- `flatpak update --user` — update installed Flathub apps (Linux)
- `make flatpaks-export` — refresh `flatpaks` from current install state (then add any new work entries to `flatpaks.work` manually; same strip semantics as `brew-export`)
- VSCode / Zed / Ghostty — auto-update enabled, no action needed
- Go: `brew upgrade go`. Node: `fnm install <version>`. Python: `uv python install <version>`.

## Casks

Homebrew Cask inventory (base, work, Linux-installable subset): see [`docs/casks.md`](docs/casks.md).

## Flatpaks

Flathub inventory for Linux (paired with casks): see [`docs/flatpaks.md`](docs/flatpaks.md).

## Claude Code

The `.config/claude/settings.json` configures permissions and plugins:

- **Allowed:** Web search, fetch from dev docs (GitHub, Stack Overflow, MDN, Go/Python/Node/Terraform/Docker/Kubernetes/Claude docs), git/docker/k8s read-only commands, build/test/lint tools (`shellcheck`, `shfmt`), dependency sync (`go mod tidy/download`, `uv sync/lock`, `npm ci`), version probes (`go/uv/python/python3/node/npm --version`, `fnm list/current`), file search and inspection (`fd`, `rg`, `grep`, `find`, `which`, `bat`, `eza`, `head`, `tail`, `ls`, `wc`, `jq`, `yq`, `tldr`, `date`)
- **Denied:** `.env` files, `.ssh/*`, `.kube/config`, `.git-credentials`, credentials, private keys, `.tfvars` (covers the `Read` tool only; allowed `Bash` readers like `bat`/`head`/`jq` can still target these paths — the model-level `Sensitive Data` rule in user CLAUDE.md is the actual guarantee)
- **Requires approval:** Arbitrary package install (`brew install`, `npm install`, `uv add`), direct code execution (`python`, `node`, `go run`), git writes, docker mutations
- **Enabled plugins:** pyright-lsp, gopls-lsp, typescript-lsp, code-review, feature-dev, code-simplifier, claude-md-management, caveman, context7, slack, atlassian, posthog, datadog, pr-review-toolkit
- **Marketplace:** [caveman](https://github.com/JuliusBrussee/caveman) (auto-update enabled)
- **Status line:** Custom layout via [`ccstatusline`](https://www.npmjs.com/package/ccstatusline) (model, thinking effort, cwd, git branch, context %, session/weekly usage, cost)
- **Usage tracking:** [`ccstatusline`](https://www.npmjs.com/package/ccstatusline) surfaces session/weekly usage and cost in the status bar via the [`ccusage`](https://github.com/ryoppippi/ccusage) library it embeds. Run `npx ccusage` for ad-hoc cost reports.

## Codex

The `.config/codex/config.toml` configures model selection, sandboxing, profiles, plugins, and MCP integrations:

- **Default behavior:** On-request approvals, `workspace-write` sandbox, cached web search by default, analytics/feedback disabled
- **Profiles:** `quick` and `research` (`research` enables live web search)
- **Rules:** `.config/codex/rules/` defines allowed command groups for `git`, `dev`, `shell`, and `infra`
- **Enabled plugins:** Slack, caveman
- **Marketplace:** [caveman](https://github.com/JuliusBrussee/caveman)
- **MCP servers:** Atlassian, Datadog, Context7, PostHog

## Templates

One-shot starter files for new projects. Not symlinked — import or copy as needed.

| File                       | Format             | Usage                                                |
| -------------------------- | ------------------ | ---------------------------------------------------- |
| `docs/bookmarks.template.html` | Netscape bookmarks | Browser Bookmarks Manager → Import. See notes below. |

**`bookmarks.template.html`** ships universal-only URLs (no org-specific subdomains, no project domains). `Services`, `Dev`, `Stage`, `Prod` ship empty — fill with org/project-specific URLs in the browser after import.

**Folder contents:**

- **`<Employer>`** — Employer-wide accounts shared across all client projects. Personal mail, calendar, timetracking, HR portal, employer-wide tools.
- **`<Project>`** — Client/project-specific daily hits. Project mail/calendar account, Jira board, GitHub PR queues + org repos + code search, planning poker, most-used Confluence docs and pages.
- **`Services`** — Third-party SaaS dashboards with a single URL (no per-env split). Observability, analytics, feature flags, cloud DB console, payments (e.g. Stripe), IdP, cloud SSO (e.g. AWS), VPN console, code quality, secrets manager.
- **`Dev`** — `*.dev.<domain>` URLs (one entry per env-specific service). Web portal, admin panel, API, GitOps console, mail catcher, broker console, internal tooling.
- **`Stage`** — `*.staging.<domain>` mirror of `Dev`.
- **`Prod`** — `*.<domain>` mirror of `Dev`. Read-only / restricted access in practice.
- **`AI`** — LLM chat entrypoints. ChatGPT, Claude, Gemini new-chat URLs + status pages.
- **`Tools`** — One-shot web utilities. Regex tester, cron parser, JWT decoder, epoch converter, time zone, diagram editors, API tester.

**Google account slots:** Gmail/Calendar URLs use `/u/0/` (first signed-in account, employer) and `/u/1/` (second, project). Swap the slot index to reorder.
