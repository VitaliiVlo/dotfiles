# Applications

Curated GUI app picks per category. Cross-platform where possible, with macOS as the primary lens for tie-breakers.

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

Bold primary lives in whichever column applies. Within each column, order alternatives by polish, popularity, or cross-platform reach as fits the category. `—` means no pick in that column.

| Category | Apple-only | Linux-only | Cross-platform |
|---|---|---|---|
| Editor | — | — | **VSCodium**, Zed, Cursor |
| Terminal | — | — | **Ghostty**, Kitty, Alacritty |
| AI | — | — | **Claude Code**, Codex, Antigravity CLI, Copilot CLI |
| Containers | **OrbStack**, Colima | Docker Engine, Pods | Podman Desktop |
| Kubernetes | — | — | **Freelens**, Aptakube, Headlamp |
| Database | Postico | — | **Beekeeper Studio**, DBeaver, TablePlus, MongoDB Compass |
| API Testing | — | — | **Bruno**, Yaak, Hoppscotch |
| Browser (Gecko) | — | — | **Firefox**, Zen, LibreWolf + **uBlock Origin** |
| Browser (Chromium) | — | — | **Brave**, Helium, Chrome + **uBlock Origin Lite** |
| Browser (WebKit) | **Safari**, Orion + **wBlock** | — | — |
| Search Engine | — | — | **DuckDuckGo**, Kagi, Brave Search, Google Search |
| Maps | Apple Maps | GNOME Maps | **Google Maps**, Waze, Organic Maps, Mapy.com |
| Diagrams | — | — | **Excalidraw**, tldraw |
| Diagram as Code | — | — | **Mermaid**, D2 |
| Notes | **Apple Notes**, Bear | Iotas | Obsidian, Joplin, Logseq, Standard Notes |
| Todo | **Apple Reminders**, Things 3 | Planify, Errands | Todoist |
| Calendar | **Apple Calendar**, Fantastical | GNOME Calendar, Evolution | Google Calendar, Proton Calendar, Thunderbird |
| Mail | **Apple Mail**, Mimestream | Geary, Evolution | Thunderbird, Gmail, Outlook, Proton Mail |
| Contacts | **Apple Contacts**, Cardhop | GNOME Contacts, Evolution | Google Contacts, Thunderbird |
| Communication (Work) | — | — | **Slack**, Microsoft Teams, Google Meet |
| Communication (Home) | — | — | **Telegram**, WhatsApp, Signal |
| Photos | **Apple Photos** | gThumb | Google Photos |
| Image Editor | **Pixelmator Pro**, Affinity | — | Pinta, GIMP, Krita |
| Video Player | **QuickTime**, IINA | Celluloid | VLC |
| Music | **Apple Music** | — | Spotify, YouTube Music |
| Password Manager | Apple Passwords | KeePassXC | **1Password**, Bitwarden, Proton Pass |
| Office | **iWork** | — | LibreOffice, OnlyOffice, Google Workspace, Microsoft 365, Proton Docs |
| PDF | **Apple Preview** | Papers | — |
| Image Viewer | **Apple Preview** | **Loupe** | — |
| Backup | **Time Machine** | Déjà Dup, Timeshift, Pika Backup | — |
| Cloud Storage | **iCloud Drive** | — | Dropbox, Google Drive, OneDrive, Proton Drive |
| Networking | — | Trayscale (Tailscale GUI) | **Tailscale**, Cloudflare WARP, Proton VPN |
| File Transfer | **AirDrop** | KDE Connect | LocalSend, syncthing |
| Medical Imaging | **Horos** | — | Weasis |
| Utilities (catch-all) | **Rectangle**, BetterDisplay, Keka, KeepingYouAwake, LinearMouse, Maccy, MiddleClick | Extension Manager, File Roller, Flatseal, GNOME Tweaks, Sushi | balenaEtcher |
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

Set DuckDuckGo (or Kagi / Brave Search) as browser default. All three support **bangs**: shortcuts that redirect a query to a target site's search. Syntax: `!<bang> <query>` (or `<query> !<bang>`).

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

Full catalog: <https://duckduckgo.com/bang> (thousands, inherited by Kagi and Brave). Kagi adds custom user-defined bangs in settings.
