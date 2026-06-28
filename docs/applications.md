# Applications

Curated GUI app picks per category. Cross-platform where possible, with macOS as the primary lens for tie-breakers.

See also [Resources](resources.md) for external discovery and reference sites.

## Selection criteria

Ranked by priority:

1. Polished UX, feels native
2. Lightweight and simple, not bloated with features
3. Popular and actively maintained
4. Trusted and appreciated in developer communities (Reddit, GitHub, HN)
5. Rising or stable trends (avoid declining tools)

Plus factors (not required): reasonable price or free, open source, enterprise backing or official status.

## Picks by category

Install via official installers or Homebrew Cask.

Bold primaries (one or more per category) come first in each column, then non-bold alternatives ordered by polish, popularity, or cross-platform reach as fits the category. `—` means no pick in that column.

### Development

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Editor | — | — | **VSCodium**, **Zed**, Cursor |
| Terminal | — | — | **Ghostty**, Kitty, Alacritty |
| AI | — | — | **Claude Code**, **Codex**, Antigravity CLI |
| Containers | **OrbStack**, Colima | Docker Engine, Pods | Podman Desktop |
| Kubernetes | — | — | **Freelens**, Aptakube, Headlamp |
| Database | Postico | — | **Beekeeper Studio**, **MongoDB Compass**, DBeaver, TablePlus |
| API Testing | — | — | **Bruno**, Yaak, Hoppscotch |
| Diagrams | — | — | **Excalidraw**, tldraw |
| Diagram as Code | — | — | **Mermaid**, D2 |

### Web & search

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Browser (Gecko) | — | — | **Firefox**, LibreWolf, Zen + **uBlock Origin** |
| Browser (Chromium) | — | — | **Brave**, Chrome, Helium + **uBlock Origin Lite** |
| Browser (WebKit) | **Safari**, Orion + **wBlock** | — | — |
| Search Engine | — | — | **Brave**, DuckDuckGo, Startpage, Kagi, Google |
| Maps | Apple Maps | GNOME Maps | **Google Maps**, Waze, Organic Maps, Mapy.com |

### Mail, calendar & contacts

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Mail/Calendar/Contacts provider | **iCloud** | — | **Google**, Proton, Fastmail, Outlook |
| Mail app | **Apple Mail**, Mimestream | Geary, Evolution | Thunderbird |
| Calendar app | **Apple Calendar**, Fantastical | GNOME Calendar, Evolution | Thunderbird |
| Contacts app | **Apple Contacts**, Cardhop | GNOME Contacts, Evolution | Thunderbird |

**Mail/Calendar/Contacts** split into provider (account/backend) and app (client). Apple iCloud, Google, and Fastmail speak open protocols (IMAP/CalDAV/CardDAV), so any app works. Proton is E2EE: mail needs the paid Bridge, and calendar/contacts work only in Proton's own app. Tuta is excluded: no IMAP/CalDAV at all, it locks you into its own apps.

### Notes, docs & productivity

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Notes | **Apple Notes**, Bear | Iotas | **Obsidian**, Joplin, Logseq |
| Markdown Editor | iA Writer | Apostrophe, Ghostwriter | **Typora**, Zettlr |
| Todo | **Apple Reminders**, Things 3 | Planify, Errands | Todoist |
| Office | **iWork** | — | LibreOffice, OnlyOffice, Google Workspace, Microsoft 365, Proton Docs |
| PDF | **Apple Preview** | Papers | — |

### Communication

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Communication (Work) | — | — | **Slack**, **Google Meet**, Microsoft Teams |
| Communication (Home) | Messages, FaceTime | — | **Telegram**, **WhatsApp**, Signal, Discord |

### Media & creative

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Photos | **Apple Photos** | gThumb | Google Photos, Ente |
| Image Editor | **Affinity**, Pixelmator Pro | — | Pinta, GIMP, Krita |
| Image Viewer | **Apple Preview** | **Loupe** | — |
| Video Player | **IINA**, QuickTime | Celluloid | VLC |
| Music | **Apple Music** | — | Spotify, YouTube Music |

### Files, security & network

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Password Manager | Apple Passwords | KeePassXC | **1Password**, Bitwarden, Proton Pass |
| Cloud Storage | **iCloud Drive** | — | Dropbox, Google Drive, Proton Drive |
| File Transfer | **AirDrop** | KDE Connect | LocalSend, syncthing |
| Backup | **Time Machine** | Déjà Dup, Timeshift, Pika Backup | — |
| Networking | — | Trayscale (Tailscale GUI) | **Tailscale**, **Cloudflare WARP**, Proton VPN, Mullvad VPN, IVPN |

### System & other

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Utilities (catch-all) | Rectangle, BetterDisplay, Keka, KeepingYouAwake, LinearMouse, Maccy, MiddleClick | Extension Manager, File Roller, Flatseal, GNOME Tweaks, Sushi | balenaEtcher |
| Medical Imaging | **Horos** | — | Weasis |
| Linux Distros | — | **Fedora**, Silverblue, Bluefin, Vanilla OS, Zorin OS, Ubuntu (versions + deltas in [`linux-tips.md`](linux-tips.md#distro-specific-deltas)) | — |

## VSCodium setup

- Marketplace is Open VSX by default (`open-vsx.org`). Pylance, Remote-SSH, Live Share are MS-only with no Open VSX mirror; repo uses open replacements (`basedpyright`, `open-remote-ssh`). Dev Containers (`ms-azuretools.vscode-containers`) and the `ms-python.*` core mirror on Open VSX.
- Settings sync via this dotfiles repo (`.config/vscodium/settings.json` symlinked to `VSCodium/User/settings.json`). Built-in MS settings sync not available (no MS account integration in VSCodium build).
- No Copilot (extension requires VSCode-family per MS ToS). Use Claude Code or Codex CLI instead.
- Configure layout (View → Appearance / Customize Layout):
  - Quick input position: center
  - Panel alignment: justify
  - Secondary side bar: right

## Search engine setup

Set Brave Search (or DuckDuckGo / Kagi) as browser default. All three support **bangs**: shortcuts that redirect a query to a target site's search. Syntax: `!<bang> <query>` (or `<query> !<bang>`).

Most-used bangs:

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

Full catalog: <https://duckduckgo.com/bang> (thousands; Kagi and Brave ship their own large, overlapping sets). Kagi adds custom user-defined bangs in settings.
