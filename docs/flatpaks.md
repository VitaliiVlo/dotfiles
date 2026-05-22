# Flatpaks

GUI applications for Linux installed via Flathub at **user scope** (`~/.local/share/flatpak`, no sudo). Mirrors the `Brewfile` / `Brewfile.work` split.

- `make flatpaks-install-base` — install `flatpaks`
- `make flatpaks-install-work` — install `flatpaks.work`
- `make flatpaks-install` — both
- `make flatpaks-export` — refresh `flatpaks` from installed state (strips `flatpaks.work` entries; add new work entries manually)

All targets no-op on macOS. Requires `flatpak` (install via `brew install flatpak` on Linux). Bootstrap adds the Flathub user remote automatically on first run.

## Base Flatpaks

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

## Work Flatpaks

| Flathub ID                | Paired cask      | Description          |
| ------------------------- | ---------------- | -------------------- |
| com.google.Chrome         | google-chrome    | Web browser          |
| com.mongodb.Compass       | mongodb-compass  | MongoDB GUI          |
| com.slack.Slack           | slack            | Team messaging       |
| com.usebruno.Bruno        | bruno            | API testing client   |
| io.beekeeperstudio.Studio | beekeeper-studio | Multi-engine SQL GUI |
| io.kinvolk.Headlamp       | headlamp         | Kubernetes GUI       |

## macOS-only (no Flathub equivalent)

Casks listed in [Linux-installable casks](casks.md#linux-installable-casks) are intentionally excluded from this list — they install via brew on Linux directly.

- **CLI tools** — `cloudflare-warp` (`pkg` artifact, no Linux URL; use distro `cloudflare-warp` package on Linux).
- **GUI apps not on Flathub** — `arc`, `balenaetcher`, `ghostty`, `horos`, `orbstack`, `tailscale-app` (use distro packages, upstream binaries, or alternatives on Linux).
- **macOS-system tools** — `keepingyouawake`, `keka`, `linearmouse`, `maccy`, `middleclick`, `rectangle`, `thaw` (no direct Linux concept; equivalents are distro-specific GNOME/KDE settings or extensions).
