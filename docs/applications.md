# Applications

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
