# Dotfiles

Dotfiles configured with **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme and **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go 1.26**, **Python** (via `uv`), and **Node.js** (via `fnm`).

## Contents

- [Quick start](#quick-start)
- [Prerequisites](#prerequisites)
  - [Local overrides](#local-overrides)
- [Configuration files](#configuration-files)
- [macOS settings](#macos-settings)
- [Linux settings](#linux-settings)
- [macOS tips](docs/macos-tips.md) — non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers)
- [Linux tips](docs/linux-tips.md) — non-obvious shortcuts and behaviors for GNOME-on-Wayland (clipboard, screenshots, Nautilus, workspaces, GNOME search, cross-device sharing, shell helpers, Wayland notes, per-distro deltas)
- [Applications](docs/applications.md) — curated GUI app picks by category, VSCode setup, search engine bangs
- [CLI tools](#cli-tools)
- [Validate](#validate)
- [Updating](#updating)
- [Casks](docs/casks.md) — Homebrew Cask inventory (base, work, Linux-installable)
- [Linux packages](docs/linux-packages.md) — recommended Linux install path per cask (link-out table to upstream install docs)
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
3. Run `make setup` (base) or `make setup-all` (base + work). Same chain as macOS: `macos-defaults` (no-op on Linux) → `linux-defaults` applies GNOME `gsettings` → `symlinks` → `local-overrides` → `brew-install-base` installs formulae + the Linux-installable cask subset (`docs/casks.md`) → `versions`. `setup-all` swaps in `brew-install` for the base+work superset. Every `Brewfile.work` cask lacks a Linuxbrew build, so on Linux `brew-install-work` is effectively a no-op for casks; install work GUIs via vendor deb/rpm (`docs/linux-packages.md`).
4. Install GUI apps via vendor `.deb` / `.rpm`. See [`docs/linux-packages.md`](docs/linux-packages.md) for the recommended install path per cask.

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

> Targets the distros listed in [Applications](docs/applications.md) (Fedora, Bluefin, Zorin OS, Pop!_OS, Ubuntu, Linux Mint). GNOME-first by default: `make linux-defaults` writes `gsettings` keys that apply to GNOME Shell (Fedora / Bluefin / Zorin / Ubuntu) and silently skips on Pop!_OS 24.04 LTS+ (COSMIC) and Linux Mint (Cinnamon); see [`docs/linux-tips.md`](docs/linux-tips.md) for per-DE deltas. Immutable variants (Bluefin, Fedora Silverblue) work too, but extra packages must be layered via `rpm-ostree` (or installed inside Distrobox/Toolbox) instead of `dnf`. KDE / Sway / headless sessions also skip the `gsettings` block but everything else (symlinks, Brewfile, shell) applies. Linuxbrew prefix defaults to `/home/linuxbrew/.linuxbrew` in `.zshrc` / `.zprofile` (override via `BREW_PREFIX` env).

- **Install build prerequisites:** `scripts/local-overrides.py` needs Python 3.11+ (stdlib `tomllib`). Fedora 39+, Ubuntu 24.04+, and recent Debian ship a compatible `python3`. Older distros are out of scope.
  ```bash
  # Debian/Ubuntu (Pop!_OS, Linux Mint)
  sudo apt-get update
  sudo apt-get install -y build-essential procps curl file git zsh python3

  # Fedora
  sudo dnf install -y @development-tools procps-ng curl file git zsh python3

  # Fedora Silverblue / Bluefin (immutable; layer once, then reboot)
  sudo rpm-ostree install zsh
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
- **Install GUI apps via vendor deb/rpm.** Recommended install path per cask (vendor apt/dnf repo, GitHub release, or upstream install script) lives in [`docs/linux-packages.md`](docs/linux-packages.md). Vendor packages respect `~/.config/<tool>/`, so the repo's symlinks resolve without the per-app sandbox path remap that Flatpak / Snap impose. Flatpak stays an option for one-shot apps that have no config in this repo (see [`docs/linux-tips.md`](docs/linux-tips.md) for examples).
- **GNOME-only defaults:** `make linux-defaults` skips silently outside GNOME (`XDG_CURRENT_DESKTOP` check). Other DEs configure their own way.

### Local overrides

Per-machine data (git identity, `GOPRIVATE`, Claude team marketplaces/plugins, Codex trusted projects) is kept in a single gitignored file and rendered into the tracked configs by a setup-time script. Tracked configs ship with neutral placeholders; the script injects real values on each `make setup` (or standalone `make local-overrides`).

1. First run inside `make setup` creates `.local/source.toml` from `.local.example.toml`, prints a fill-in prompt to stderr, and returns 0 so the rest of the chain (`brew-install-base`, `versions`) continues with neutral placeholders. Edit `.local/source.toml` with your values, then re-run `make local-overrides` to inject them. Schema sections: `[git]`, `[go]`, `[claude.marketplaces.<key>]`, `[claude].plugins`, `[codex].trusted_projects`.
2. Re-run `make local-overrides`. The script reads the clean base from `git show HEAD:<path>` for each tracked target, applies the overrides, and writes back to:
   - `.config/git/config` — `[user]` block replaced
   - `.zprofile` — `GOPRIVATE` line replaced
   - `.config/claude/settings.json` — `extraKnownMarketplaces` and `enabledPlugins` extended
   - `.config/codex/config.toml` — `[projects."<path>"]` blocks appended
3. The resulting working-tree diff on those four files is intentional. **Do not commit it.** Each run reads from HEAD, so overrides never compound and a fresh `git pull` + re-run keeps state consistent.

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
- `.config/vscode/settings.json` - VSCode configuration (macOS: `~/Library/Application Support/Code/User/settings.json`, Linux: `~/.config/Code/User/settings.json`; VSCode hardcodes `app.getPath('userData')` and ignores `$XDG_CONFIG_HOME` on Darwin)
- `.config/zed/settings.json` - Zed editor settings
- `.config/claude/settings.json` - Claude Code permissions
- `.config/claude/CLAUDE.md` - Claude Code user-level instructions
- `.config/ccstatusline/settings.json` - Claude Code status line layout
- `.config/codex/config.toml` - Codex CLI config (model, sandbox, plugins)
- `.config/codex/AGENTS.md` - Codex user-level instructions
- `.config/codex/rules/{git,dev,shell,infra}.rules` - Codex permission rules (linked per file; add new rule files to `scripts/symlinks.sh` and `scripts/validate.sh`)

### Not symlinked

Used directly from the repo:

- `Brewfile` - Base Brewfile (shell, fonts, daily-driver apps, VSCode extensions)
- `Brewfile.work` - Work Brewfile (work-specific GUIs — API client, K8s GUI, DB GUI, container runtime, comms, VPN, browser; curated manually)
- `docs/linux-packages.md` - Recommended Linux install path per cask (link-out table to upstream install docs)
- `CLAUDE.md` - Repository instructions for Claude Code (auto-discovered in cwd; Codex reads it via `project_doc_fallback_filenames`)
- `docs/vscode-defaults.jsonc` - VSCode defaults snapshot for offline comparison (regenerate via `Preferences: Open Default Settings (JSON)`)
- `.local.example.toml` - Schema for per-machine overrides; copy to `.local/source.toml` (gitignored) and fill in. See [Local overrides](#local-overrides).

## macOS settings

Run `make macos-defaults` to configure (in order applied):

- Folders (~/Projects, ~/Pictures/Screenshots)
- System defaults (key repeat via `ApplePressAndHoldEnabled=false` at OS-default rate/delay, natural scrolling, save to disk by default). Linux pins explicit 250ms delay / 30ms interval; macOS intentionally inherits OS-default rate to avoid surprising existing users.
- Screenshots (save to ~/Pictures/Screenshots, no shadow, PNG, floating thumbnail enabled)
- Finder (list view, path bar, show extensions, folders first, search current folder, suppress DS_Store on network/USB volumes)
- Dock (autohide, no recents, scale minimize effect, minimized windows in own Dock slot, fixed Spaces order, Cmd-gated hot corners: TL Mission Control / TR Notification Center / BL Desktop / BR Quick Note)

No-op on Linux (script guards `uname -s == Darwin`).

## Linux settings

Run `make linux-defaults` to configure (GNOME via `gsettings`):

- Folders (~/Projects, ~/Pictures/Screenshots)
- Input (touchpad + mouse natural scroll, keyboard repeat enabled with 250ms delay / 30ms interval)
- Files / Nautilus (list view, hidden files, folders-first, search current folder only)
- Desktop (dash-to-dock click=minimize when extension present, battery %, clock weekday, `prefer-dark` color scheme)
- Power (disable AC auto-suspend)

Guards: skips silently on non-Linux, when `gsettings` missing, or when `XDG_CURRENT_DESKTOP` is not GNOME. KDE / Sway / headless sessions are unaffected.

`gsettings` writes to user-scope dconf; safe to re-run (`set_if_exists` helper checks schema existence before each write).

## macOS tips

Non-obvious shortcuts and behaviors (clipboard, screenshots, Finder, Mission Control, Spotlight, Continuity, shell helpers): see [`docs/macos-tips.md`](docs/macos-tips.md).

## Linux tips

Non-obvious shortcuts and behaviors for the GNOME-on-Wayland distros tracked in [`docs/applications.md`](docs/applications.md) (clipboard, screenshots, Nautilus, workspaces, GNOME search, cross-device sharing, shell helpers, Wayland notes, per-distro deltas for Fedora/Bluefin, Ubuntu/Pop, Pop COSMIC, Mint/Cinnamon, Zorin): see [`docs/linux-tips.md`](docs/linux-tips.md).

## Applications

Curated GUI app picks by category, VSCode setup, and search engine bangs: see [`docs/applications.md`](docs/applications.md).

## CLI tools

Installed via Homebrew formulae and casks (see `Brewfile` and `Brewfile.work`):

```bash
make brew-install       # Install all packages (base + work)
make brew-install-base  # Install base packages only
make brew-install-work  # Install work packages only
make brew-cleanup       # Clean up old versions and cache
make brew-export        # Export installed packages (incl. VSCode extensions) to Brewfile, then strip Brewfile.work entries; add new work entries to Brewfile.work manually
make versions           # Show installed Go, Node, Python versions
make local-overrides    # Re-render per-machine overrides from .local/source.toml; see Local overrides
```

| Tool                    | Description                                             |
| ----------------------- | ------------------------------------------------------- |
| argocd                  | Argo CD CLI (Kubernetes GitOps)                         |
| atuin                   | Shell history sync + Ctrl+R replacement                 |
| awscli                  | AWS command-line interface                              |
| bat                     | `cat` with syntax highlighting                          |
| btop                    | System monitor TUI (mouse + charts + GPU panels)        |
| buf                     | Modern Protocol Buffers toolkit (lint, breaking, gen)   |
| corepack                | Node package-manager bootstrap (yarn/pnpm enabler)      |
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
| go                      | Go toolchain (1.26)                                     |
| golangci-lint           | Go meta-linter                                          |
| goose                   | Go database migration tool                              |
| goplay                  | Go playground CLI client                                |
| gopls                   | Go language server                                      |
| gotests                 | Go test boilerplate generator                           |
| helm                    | Kubernetes package manager                              |
| htop                    | Classic process monitor (universal fallback)            |
| impl                    | Go interface method stub generator                      |
| jq                      | Command-line JSON processor                             |
| k9s                     | Kubernetes TUI                                          |
| kubectl                 | Kubernetes CLI                                          |
| kubectx                 | Kubernetes context switcher (ships kubens for namespaces) |
| kustomize               | Kubernetes manifest overlays/patches                    |
| lazydocker              | Docker TUI                                              |
| lazygit                 | Git TUI                                                 |
| lazysql                 | Multi-engine SQL TUI                                    |
| litecli                 | SQLite CLI with autocomplete                            |
| micro                   | Terminal text editor                                    |
| mockgen                 | Go mock generator (`go.uber.org/mock`)                  |
| mongosh                 | MongoDB shell                                           |
| ncdu                    | Interactive disk usage analyzer (classic, Zig)          |
| pgcli                   | PostgreSQL CLI with autocomplete                        |
| ripgrep                 | Fast `grep` replacement                                 |
| ruff                    | Python linter / formatter (Rust)                        |
| sevenzip                | 7-Zip file archiver                                     |
| shellcheck              | Shell script static analyzer                            |
| shfmt                   | Shell script formatter                                  |
| starship                | Cross-shell prompt                                      |
| superfile               | Modern terminal file manager (alternative to yazi)      |
| swag                    | Swagger 2.0 doc generator for Go                        |
| taproom                 | Interactive Homebrew TUI (tap `gromgit/brewtils`)       |
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

For full audit, run `make validate` (delegates to `scripts/validate.sh`). Covers TOML/JSON/YAML/JSONC parse, `brew bundle list` (parse) + non-fatal `brew bundle check` (install state), `ghostty +validate-config`, `shellcheck`, `shfmt`, `zsh -n` on `.zshrc`/`.zprofile`, `prefix_rule(` sanity grep on `.config/codex/rules/*.rules`, `git config --list` on `.config/git/config`, `--`-prefix sanity grep on `.config/bat/config` and `.config/ripgrep/ripgreprc`, and symlink resolution. Skips macOS-native symlinks on Linux.

## Updating

- `brew update && brew upgrade` — update Homebrew formulae and casks
- `make brew-export` — refresh `Brewfile` from current install state (macOS only; Linuxbrew dump would wipe macOS-only casks). Add new work entries to `Brewfile.work` manually; see `docs/conventions.md` "Brewfile maintenance" for strip step semantics.
- `make brew-cleanup` — prune old versions and cache
- macOS GUI apps: cask auto-update via `brew upgrade` (VSCode, Brave, Helium, Zen, Ghostty, Zed, Claude Code, Codex, IINA, Telegram, WhatsApp have their own in-app updaters too; cask still authoritative)
- Linux GUI apps via vendor apt/dnf repo (covered by `sudo apt-get upgrade` / `sudo dnf upgrade`): 1Password, Beekeeper Studio (deb only), Brave, Bruno (deb only), Cloudflare WARP, Firefox, Ghostty (Ubuntu universe or Fedora Copr), Google Chrome, Helium, Slack, Tailscale, Telegram (distro `telegram-desktop`), VSCode
- Linux GUI apps via in-app updater: Obsidian, Zed, Zen (Firefox-based built-in updater)
- Linux GUI apps via manual GitHub release re-download: balenaEtcher, Beekeeper Studio (rpm only), Bruno (rpm only), Headlamp, LocalSend
- Linux GUI apps via manual vendor download re-download: MongoDB Compass (`mongodb.com/try/download/compass`)
- Go: `brew upgrade go`. Node: `fnm install <version>`. Python: `uv python install <version>`.

## Casks

Homebrew Cask inventory (base, work, Linux-installable subset): see [`docs/casks.md`](docs/casks.md).

## Linux packages

Recommended Linux install path per cask (link-out table): see [`docs/linux-packages.md`](docs/linux-packages.md).

## Claude Code

The `.config/claude/settings.json` configures permissions and plugins:

- **Allowed:** Web search + fetch from dev docs (GitHub, Stack Overflow, MDN, Go/Python/Node/Terraform/Docker/Kubernetes/Claude docs); git/gh/docker/kubectl read-only subcommands; build/test/lint (`shellcheck`, `shfmt`, `pytest`, `mypy`, `pyright`, `pip-audit`, `ruff check/format`, `eslint`, `jest`, `prettier`, `tsc`, `vitest`, `npm test` + `npm run build/format/lint/test/typecheck`, `golangci-lint`, `govulncheck`, `go fmt/vet`, `gofmt`); dependency sync (`go mod tidy/download/graph/verify/why`, `uv sync/lock/build`, `npm ci/audit`) + dep queries (`uv pip list/show`, `uv tree`, `npm ls/list/outdated/view`); ephemeral runners (`uvx`, `uv run`, `npx` wrappers for the test/lint/format tools above); build runner (`make --dry-run`/`make -n`); version probes (`go version`, `uv/python/python3/node/npm --version`, `fnm list/current`); file search and inspection (`fd`, `rg`, `grep`, `find`, `which`, `bat`, `eza`, `head`, `tail`, `ls`, `wc`, `tldr`, `tree`, `file`, `readlink`, `realpath`, `stat`); structured data (`jq`, `yq`); text utils (`awk`, `cut`, `diff`, `echo`, `printf`, `sed`, `sort`, `tr`, `uniq`); system info (`cd`, `date`, `ps`, `pwd`, `sleep`, `uname`); clipboard (`pbcopy`, `wl-copy`). `go env` intentionally excluded (`go env -w` writes persistent config).
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

### Folder contents

- **`<Employer>`** — Employer-wide accounts shared across all client projects. Personal mail, calendar, timetracking, HR portal, employer-wide tools.
- **`<Project>`** — Client/project-specific daily hits. Project mail/calendar account, Jira board, GitHub PR queues + org repos + code search, planning poker, most-used Confluence docs and pages.
- **`Services`** — Third-party SaaS dashboards with a single URL (no per-env split). Observability, analytics, feature flags, cloud DB console, payments (e.g. Stripe), IdP, cloud SSO (e.g. AWS), VPN console, code quality, secrets manager.
- **`Dev`** — `*.dev.<domain>` URLs (one entry per env-specific service). Web portal, admin panel, API, GitOps console, mail catcher, broker console, internal tooling.
- **`Stage`** — `*.staging.<domain>` mirror of `Dev`.
- **`Prod`** — `*.<domain>` mirror of `Dev`. Read-only / restricted access in practice.
- **`AI`** — LLM chat entrypoints. ChatGPT, Claude, Gemini new-chat URLs + status pages.
- **`Tools`** — One-shot web utilities. Regex tester, cron parser, JWT decoder, epoch converter, time zone, diagram editors, API tester.

**Google account slots:** Gmail/Calendar URLs use `/u/0/` (first signed-in account, employer) and `/u/1/` (second, project). Swap the slot index to reorder.
