# Dotfiles

Dotfiles configured with **Catppuccin Macchiato** (dark) / **Catppuccin Latte** (light) theme and **JetBrains Mono** font (14pt) with **Fira Code**, **Menlo**, **Monaco**, and **Symbols Nerd Font Mono** fallbacks. Configured for **Go 1.26**, **Python** (via `uv`), and **Node.js** (via `fnm`).

## Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Configuration Files](#configuration-files)
- [macOS Settings](#macos-settings)
- [macOS Tips](#macos-tips)
- [Applications](#applications)
- [CLI Tools](#cli-tools)
- [Validate](#validate)
- [Updating](#updating)
- [Casks](#casks)
- [Flatpaks](#flatpaks)
- [Claude Code](#claude-code)
- [Codex](#codex)
- [Templates](#templates)

## Quick Start

1. Complete [Prerequisites](#prerequisites) (Xcode CLT, Homebrew, SSH key, Touch ID).
2. Clone this repository.
3. Run `make setup` (base packages) or `make setup-all` (base + work packages) to configure macOS, symlink configs, install packages, and show versions.

Run `make help` to list all available targets.

## Prerequisites

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

## Configuration Files

The following files are automatically symlinked by running `make link`:

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

## macOS Tips

Non-obvious shortcuts and behaviors worth remembering. `defaults write` recipes already applied by `make defaults` are not repeated here, see `scripts/macos-defaults.sh`.

**Clipboard and paste:**

| Shortcut                         | Use                                                                                      |
| -------------------------------- | ---------------------------------------------------------------------------------------- |
| `Option+Shift+Cmd+V`             | Paste and match style (strips formatting; for Slack, Jira, docs)                         |
| Universal Clipboard              | Copy on iPhone / iPad / Mac, paste on another nearby Apple device                        |
| Clipboard history (macOS Tahoe+) | Browse recent copied items                                                               |

**Screenshots and screen recording:**

| Shortcut                                | Use                                                                                      |
| --------------------------------------- | ---------------------------------------------------------------------------------------- |
| `Cmd+Shift+3` / `Cmd+Shift+4`           | Full screen / region screenshot to file                                                  |
| `Cmd+Ctrl+Shift+3` / `Cmd+Ctrl+Shift+4` | Same but to clipboard, skip file write                                                   |
| `Cmd+Shift+4` then `Space`              | Window screenshot (no shadow if `disable-shadow=true`, applied by `make defaults`)       |
| `Cmd+Shift+5`                           | Screenshot + screen recording UI (region / window / full, mic select, timer)             |

After capture, the floating thumbnail at bottom-right is draggable: drop it directly into Slack / Mail / a chat without saving to disk first.

**Finder and Save / Open dialogs:**

| Shortcut              | Use                                                                                |
| --------------------- | ---------------------------------------------------------------------------------- |
| `Cmd+Shift+.`         | Show / hide hidden files (Finder + Open / Save dialogs)                            |
| `Cmd+Shift+G`         | Go to folder by path (`~/.config`, `/opt/homebrew`, ...). Works inside dialogs too |
| `Cmd+Up` / `Cmd+Down` | Parent folder / open selected                                                      |
| `Option+Cmd+V`        | Move files after copy ("cut / paste" for files)                                    |
| `Space`               | Quick Look preview                                                                 |
| `Option+Space`        | Quick Look slideshow                                                               |
| `Option+Cmd+P`        | Toggle path bar                                                                    |
| `Cmd+/`               | Toggle status bar                                                                  |
| Drag file → Terminal  | Pastes escaped POSIX path                                                          |
| Drag file → dialog    | Selects that path                                                                  |

Control-click a folder in Finder path bar → copy pathname. Finder Quick Actions: rotate image / video, Markup, trim audio / video, convert HEIC ↔ JPEG / PNG, create PDF, all without opening an app.

**Get Info and metadata:**

| Shortcut                | Use                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------ |
| `Cmd+I`                 | Get Info on selected file / folder                                                   |
| `Option+Cmd+I`          | Inspector (single window that updates as you change Finder selection)                |
| Tag in Finder           | Color-coded, searchable via sidebar and Spotlight                                    |
| Stationery Pad checkbox | In Get Info; turns file into template, opening creates duplicate                     |

**Drag-and-drop tricks:**

| Action                                       | Result                                                       |
| -------------------------------------------- | ------------------------------------------------------------ |
| Drag selected text → Desktop                 | Creates `.textClipping` file                                 |
| Drag URL from browser → Desktop              | Creates `.webloc` shortcut                                   |
| Drag attachment from Mail → Desktop          | Saves file directly                                          |
| Drag file over folder, hover                 | Spring-loaded folder opens automatically (recursive)         |
| Drag file with `Option` held                 | Copy instead of move                                         |
| Drag file with `Option+Cmd` held             | Create alias (symlink-like)                                  |

**Window and app lifecycle:**

| Shortcut                 | Use                                                                  |
| ------------------------ | -------------------------------------------------------------------- |
| `Cmd+Tab`                | Switch apps                                                          |
| `` Cmd+` ``              | Switch windows in current app                                        |
| `Cmd+H`                  | Hide current app (cleaner than minimize)                             |
| `Option+Cmd+H`           | Hide all other apps                                                  |
| `Cmd+M` / `Option+Cmd+M` | Minimize current / all of current app                                |
| `Cmd+W` / `Option+Cmd+W` | Close window / all windows of current app (app stays running)        |
| `Cmd+Q`                  | Quit the app (not just close window)                                 |
| `Ctrl+Cmd+F`             | Toggle full screen                                                   |
| `Option+Cmd+Esc`         | Force Quit list                                                      |
| Dock long-press app icon | Force Quit when "(Not Responding)" appears                           |

Prefer **Hide** over **Minimize**. Minimized windows often vanish mentally; hidden apps return via `Cmd+Tab`. Remember `Cmd+W` only closes a window, the app keeps running, use `Cmd+Q` to actually quit.

**Mission Control and Spaces:**

| Shortcut                | Use                                                                |
| ----------------------- | ------------------------------------------------------------------ |
| `Ctrl+Up`               | Mission Control (all windows + Spaces)                             |
| `Ctrl+Down`             | App Exposé (windows of current app)                                |
| `Ctrl+←` / `Ctrl+→`     | Switch Space                                                       |
| `Ctrl+1` / `Ctrl+2` ... | Jump directly to Space N (enable in System Settings → Keyboard)    |
| Three-finger swipe up   | Mission Control                                                    |
| Three-finger swipe ←/→  | Switch Space                                                       |
| Drag window → top edge  | Brings up Mission Control; drop on a Space thumbnail to move it    |

**Spotlight:**

Not only app search. Inline math, currency, unit conversion, time zones, weather, stocks, app actions.

```text
25 usd in eur
340K in C
120 lb in kg
time in Tokyo
weather Berlin
15% of 2800
focus
timer 10 minutes
```

**Text input:**

| Shortcut                   | Use                                                              |
| -------------------------- | ---------------------------------------------------------------- |
| `Ctrl+Cmd+Space` or `Fn+E` | Emoji / symbol picker                                            |
| `Option+Delete`            | Delete previous word                                             |
| `Fn+Delete` or `Ctrl+D`    | Forward delete                                                   |
| `Ctrl+A` / `Ctrl+E`        | Start / end of line (most native fields)                         |
| `Ctrl+K`                   | Delete to end of line                                            |

Text Replacements (System Settings → Keyboard → Text Replacements) sync via iCloud and survive reinstall. Useful entries:

```text
@@      → email
;addr   → address
;shrug  → ¯\_(ツ)_/¯
;sig    → Slack / Jira signature
```

**Live Text:**

Hover over any image (Safari, Photos, Preview, screenshots, PDFs) → cursor turns into text selector → select / copy / lookup the text inside the image. Works on photos of receipts, code on whiteboards, error messages in screenshots. No OCR app needed.

**Continuity (Apple multi-device):**

| Feature             | What it does                                                                                |
| ------------------- | ------------------------------------------------------------------------------------------- |
| AirDrop             | Drop files Mac ↔ iPhone / iPad / Mac wirelessly                                             |
| Universal Clipboard | Copy on one device, paste on another (same Apple ID, Bluetooth + Wi-Fi)                     |
| Universal Control   | Single cursor + keyboard across Mac and nearby iPad / Mac (move cursor off edge)            |
| Continuity Camera   | Use iPhone as webcam, document scanner, or sketch input (File → Insert from iPhone)         |
| Handoff             | Start in Safari / Mail / Notes on one device, pick up on another via Dock / `Cmd+Tab` icon  |

**Menu bar:**

| Trick                                                  | Use                                                  |
| ------------------------------------------------------ | ---------------------------------------------------- |
| `Cmd+drag` menu bar icon                               | Rearrange                                            |
| `Cmd+drag` icon out                                    | Remove (most system icons)                           |
| `Option+click` Wi-Fi                                   | Show BSSID, channel, RSSI, country, security        |
| `Option+click` Wi-Fi → hold then click                 | Open Wireless Diagnostics                            |
| `Option+click` Bluetooth / battery / volume            | Deeper info or alternate actions                     |
| `Option+click` battery                                 | List apps draining battery                           |
| `Option+click` green window button                     | Toggle zoom instead of full screen                   |
| `Option+click` Notification Center (date / time)       | Toggle Do Not Disturb                                |

**Hot Corners:** set in System Settings → Desktop & Dock → Hot Corners with a modifier (`Cmd`, `Ctrl`, `Option`, `Shift`) so the action only fires on intent. Example: bottom-right + `Ctrl` = Lock Screen.

**Quick Actions / Shortcuts:** build a Shortcut in the Shortcuts app, then surface it via Finder right-click, Share Sheet, Services, Dock, Control Center, or assign a keyboard shortcut. Useful custom ones:

- Copy POSIX file path of selected Finder item
- Open folder in VSCode / Zed / Cursor
- Convert image to JPEG / PNG / WebP
- Resize image to 1600px (Jira / Slack uploads)
- New terminal here
- Compress selected files with date prefix

**Preview app (built-in PDF / image powerhouse):**

- Combine PDFs: open one in Preview → sidebar → drag other PDFs in
- Sign documents: trackpad signature or camera capture, stored in keychain
- Markup: crop, redact, annotate, add shapes / text (`Cmd+Shift+A` opens toolbar)
- Convert format: File → Export → choose JPEG / PNG / TIFF / HEIC / PDF, no third-party tool

**Shell helpers shipped with macOS:**

| Command                                       | Use                                                                              |
| --------------------------------------------- | -------------------------------------------------------------------------------- |
| `pbcopy` / `pbpaste`                          | Pipe to / from system clipboard (`cat key.pub \| pbcopy`)                        |
| `open .` / `open file.pdf` / `open -a App f`  | Open in Finder / default app / specific app                                      |
| `mdfind 'kMDItemFSName == "*.pem"'`           | Spotlight from shell                                                             |
| `mdls file`                                   | All Spotlight metadata of a file                                                 |
| `caffeinate -d` / `caffeinate -i`             | Keep display / system awake (Ctrl+C to stop)                                     |
| `say "build finished"`                        | Text-to-speech (good for long-running task completion notification)              |
| `xattr -d com.apple.quarantine <bin>`         | Un-quarantine a downloaded binary that Gatekeeper blocks                         |
| `pmset -g batt`                               | Battery state and history from CLI                                               |
| `networksetup -listallhardwareports`          | All network interfaces and MAC addresses                                         |

**Most valuable pattern: hold `Option` everywhere.** Changes menu items, window buttons, file drag behavior, Wi-Fi / Bluetooth / battery / volume menus, Apple menu (About → System Information), and many confirmation dialogs.

## Applications

**Prerequisites:**

- macOS available (Linux is a plus)

**Selection criteria (ranked by priority):**

1. Polished UX, feels native
2. Lightweight and simple, not bloated with features
3. Popular and actively maintained
4. Trusted and appreciated in developer communities (Reddit, GitHub, HN)
5. Rising or stable trends (avoid declining tools)

**Plus factors (not required):**

- Reasonable price or free
- Open source
- Enterprise backing or official status

Install via official installers or Homebrew Cask:

| Category              | Apps                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------ |
| Editor                | **VSCode**, Zed, Cursor                                                              |
| Terminal              | **Ghostty**, Kitty, Alacritty                                                        |
| AI                    | **Claude Code**, Codex, Gemini CLI, OpenCode                                         |
| Containers            | **OrbStack**, Colima, Podman Desktop                                                 |
| Kubernetes            | **Headlamp**, Aptakube, Freelens                                                     |
| Kubernetes Remote Dev | **Telepresence**, mirrord                                                            |
| Database              | **Beekeeper Studio**, TablePlus, Postico, MongoDB Compass                            |
| API Testing           | **Bruno**, Yaak, Hoppscotch                                                          |
| Medical Imaging       | **Horos**, Weasis, OsiriX Lite                                                       |
| Browser (Gecko)       | **Firefox**, Zen + **uBlock Origin**                                                 |
| Browser (Chromium)    | **Brave**, Arc, Helium + **uBlock Origin Lite**                                      |
| Browser (WebKit)      | **Safari**, Orion + **wBlock**                                                       |
| Search Engine         | **DuckDuckGo**, Kagi, Brave Search                                                   |
| Diagrams              | **Excalidraw**, tldraw                                                               |
| Diagram as Code       | **Mermaid**, D2                                                                      |
| Notes                 | **Apple Notes**, Bear, Obsidian                                                      |
| Todo                  | **Apple Reminders**, Things 3                                                        |
| Calendar              | **Apple Calendar**, Fantastical                                                      |
| Mail                  | **Apple Mail**, Mimestream                                                           |
| Password Manager      | **Apple Passwords**, 1Password, Bitwarden                                            |
| Office                | **Apple iWork** (Pages, Numbers, Keynote), Google Workspace, Microsoft 365           |
| macOS Utilities       | Rectangle, Maccy, Keka, KeepingYouAwake, Thaw, MiddleClick, LinearMouse, balenaEtcher |
| Networking            | Cloudflare WARP, LocalSend, Tailscale                                                |
| Linux Distros         | Bluefin, elementary OS, Fedora Silverblue, Fedora Workstation, Pop!_OS               |

**VSCode setup:**

- Enable settings sync with GitHub
- Sign in to Copilot Chat (base `github.copilot` installs as a dependency; next-edit suggestions intentionally off via `github.copilot.nextEditSuggestions.enabled: false`)
- Configure layout (View → Appearance / Customize Layout):
  - Quick input position: center
  - Panel alignment: justify
  - Secondary side bar: right

**Search engine setup:**

- Set DuckDuckGo (or Kagi / Brave Search) as browser default — all three support **bangs**: shortcuts that redirect a query to a target site's search.
- Syntax: `!<bang> <query>` (or `<query> !<bang>`).
- Most-used bangs:

  | Bang | Target |
  | --- | --- |
  | `!g` | Google (fallback when results miss) |
  | `!w` | Wikipedia |
  | `!yt` | YouTube |
  | `!maps` / `!gmaps` | Google Maps |
  | `!i` / `!images` | Image search |
  | `!tr` | Google Translate |
  | `!r` | Reddit |
  | `!a` | Amazon |
  | `!news` | Google News |
  | `!gh` | GitHub |
  | `!so` | Stack Overflow |
  | `!imdb` | IMDb |

- Full catalog: <https://duckduckgo.com/bang> (13k+, inherited by Kagi & Brave). Kagi adds custom user-defined bangs in settings.

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

For full audit recipe (TOML/JSON/YAML/JSONC parsers, `brew bundle check`, `shellcheck`, symlink walk, web verification of suspect keys) see `CLAUDE.md` "Config Validation" section.

## Updating

- `brew update && brew upgrade` — update Homebrew formulae and casks
- `make brew-export` — refresh `Brewfile` from current install state (then add any new work entries to `Brewfile.work` manually; see CLAUDE.md "Brewfile maintenance" for strip step semantics)
- `make brew-cleanup` — prune old versions and cache
- `flatpak update --user` — update installed Flathub apps (Linux)
- `make flatpaks-export` — refresh `flatpaks` from current install state (then add any new work entries to `flatpaks.work` manually; same strip semantics as `brew-export`)
- VSCode / Zed / Ghostty — auto-update enabled, no action needed
- Go: `brew upgrade go`. Node: `fnm install <version>`. Python: `uv python install <version>`.

## Casks

GUI applications, CLIs, and fonts installed via Homebrew Cask:

### Base Casks

| Cask                        | Description                      |
| --------------------------- | -------------------------------- |
| 1password                   | Password manager                 |
| 1password-cli               | 1Password CLI                    |
| arc                         | Web browser (Chromium)           |
| balenaetcher                | USB flash tool                   |
| brave-browser               | Web browser (Chromium)           |
| claude-code                 | Anthropic Claude CLI             |
| cloudflare-warp             | VPN / 1.1.1.1 client             |
| codex                       | OpenAI Codex CLI                 |
| firefox                     | Web browser                      |
| font-fira-code              | Fallback monospace font          |
| font-jetbrains-mono         | Primary monospace font           |
| font-symbols-only-nerd-font | Nerd Font icons (symbols only)   |
| ghostty                     | Terminal emulator                |
| horos                       | Medical imaging viewer (DICOM)   |
| keepingyouawake             | Prevent sleep                    |
| keka                        | File archiver                    |
| linearmouse                 | Per-device mouse customization   |
| localsend                   | Cross-platform LAN file sharing  |
| maccy                       | Clipboard manager                |
| middleclick                 | Three-finger tap as middle click |
| obsidian                    | Notes / knowledge base           |
| rectangle                   | Window manager                   |
| thaw                        | Menu bar manager                 |
| visual-studio-code          | Code editor                      |
| zed                         | Code editor                      |
| zen                         | Web browser (Gecko)              |

### Work Casks

| Cask             | Description                               |
| ---------------- | ----------------------------------------- |
| beekeeper-studio | Multi-engine SQL GUI                      |
| bruno            | API testing client                        |
| google-chrome    | Web browser                               |
| headlamp         | Kubernetes GUI                            |
| mongodb-compass  | MongoDB GUI                               |
| orbstack         | Docker/Linux VM (replaces Docker Desktop) |
| slack            | Team messaging                            |
| tailscale-app    | VPN/mesh networking                       |

### Linux-installable casks

Homebrew 4.5+ added preliminary Linux cask support. A small subset of `Brewfile` casks installs via `brew install --cask <name>` on Linuxbrew because the cask source declares either an `os macos: ..., linux: ...` block with `x86_64_linux` / `arm64_linux` sha256 entries (binary CLIs), or a `font` artifact (font files install to the platform font dir). All other casks are macOS-only by artifact (`app`, `pkg`, `darwin` arch) and skipped on Linux with a warning.

| Cask                        | Why Linux works                                  |
| --------------------------- | ------------------------------------------------ |
| 1password-cli               | `binary "op"` + linux sha256 + linux URL         |
| claude-code                 | `binary "claude"` + linux sha256 + linux URL     |
| codex                       | `binary "codex"` + linux sha256 + linux URL      |
| font-fira-code              | `font` artifact (cross-platform)                 |
| font-jetbrains-mono         | `font` artifact (cross-platform)                 |
| font-symbols-only-nerd-font | `font` artifact (cross-platform)                 |

Net: 6 of 34 casks are cross-platform via brew. The remaining 28 still need Flathub or distro packages on Linux (see next section).

## Flatpaks

GUI applications for Linux installed via Flathub at **user scope** (`~/.local/share/flatpak`, no sudo). Mirrors the `Brewfile` / `Brewfile.work` split.

- `make flatpaks-install-base` — install `flatpaks`
- `make flatpaks-install-work` — install `flatpaks.work`
- `make flatpaks-install` — both
- `make flatpaks-export` — refresh `flatpaks` from installed state (strips `flatpaks.work` entries; add new work entries manually)

All targets no-op on macOS. Requires `flatpak` (install via `brew install flatpak` on Linux). Bootstrap adds the Flathub user remote automatically on first run.

### Base Flatpaks

| Flathub ID                  | Paired cask        | Description                     |
| --------------------------- | ------------------ | ------------------------------- |
| app.zen_browser.zen         | zen                | Web browser (Gecko)             |
| com.brave.Browser           | brave-browser      | Web browser (Chromium)          |
| com.github.tchx84.Flatseal  | —                  | Flatpak permission editor       |
| com.onepassword.OnePassword | 1password          | Password manager                |
| com.visualstudio.code       | visual-studio-code | Code editor                     |
| dev.zed.Zed                 | zed                | Code editor                     |
| md.obsidian.Obsidian        | obsidian           | Notes / knowledge base          |
| org.localsend.localsend_app | localsend          | Cross-platform LAN file sharing |
| org.mozilla.firefox         | firefox            | Web browser                     |

### Work Flatpaks

| Flathub ID                | Paired cask      | Description          |
| ------------------------- | ---------------- | -------------------- |
| com.google.Chrome         | google-chrome    | Web browser          |
| com.mongodb.Compass       | mongodb-compass  | MongoDB GUI          |
| com.slack.Slack           | slack            | Team messaging       |
| com.usebruno.Bruno        | bruno            | API testing client   |
| io.beekeeperstudio.Studio | beekeeper-studio | Multi-engine SQL GUI |
| io.kinvolk.Headlamp       | headlamp         | Kubernetes GUI       |

### macOS-only (no Flathub equivalent)

Casks listed in [Linux-installable casks](#linux-installable-casks) above are intentionally excluded from this list — they install via brew on Linux directly.

- **CLI tools** — `cloudflare-warp` (`pkg` artifact, no Linux URL; use distro `cloudflare-warp` package on Linux).
- **GUI apps not on Flathub** — `arc`, `balenaetcher`, `ghostty`, `horos`, `orbstack`, `tailscale-app` (use distro packages, upstream binaries, or alternatives on Linux).
- **macOS-system tools** — `keepingyouawake`, `keka`, `linearmouse`, `maccy`, `middleclick`, `rectangle`, `thaw` (no direct Linux concept; equivalents are distro-specific GNOME/KDE settings or extensions).

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
| `templates/bookmarks.html` | Netscape bookmarks | Browser Bookmarks Manager → Import. See notes below. |

**`bookmarks.html`** ships universal-only URLs (no org-specific subdomains, no project domains). `Services`, `Dev`, `Stage`, `Prod` ship empty — fill with org/project-specific URLs in the browser after import.

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
