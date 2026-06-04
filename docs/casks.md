# Casks

Homebrew Cask inventory: GUI applications, CLIs, and fonts. Split into a base set installed by `make brew-install-base` and a work set installed by `make brew-install-work`. A subset is cross-platform via Linuxbrew; the rest install on Linux via vendor deb/rpm.

## Base casks

| Cask                        | Description                      |
| --------------------------- | -------------------------------- |
| 1password                   | Password manager                 |
| 1password-cli               | 1Password CLI                    |
| balenaetcher                | USB flash tool                   |
| betterdisplay               | Display management (DDC, HiDPI)  |
| brave-browser               | Web browser (Chromium)           |
| claude-code                 | Anthropic Claude CLI             |
| cloudflare-warp             | VPN / 1.1.1.1 client             |
| codex                       | OpenAI Codex CLI                 |
| firefox                     | Web browser                      |
| font-fira-code              | Fallback monospace font          |
| font-jetbrains-mono         | Primary monospace font           |
| font-symbols-only-nerd-font | Nerd Font icons (symbols only)   |
| ghostty                     | Terminal emulator                |
| helium-browser              | Web browser (Chromium, privacy)  |
| horos                       | Medical imaging viewer (DICOM)   |
| iina                        | Video player (mpv-based)         |
| keepingyouawake             | Prevent sleep                    |
| keka                        | File archiver                    |
| linearmouse                 | Per-device mouse customization   |
| localsend                   | Cross-platform LAN file sharing  |
| maccy                       | Clipboard manager                |
| middleclick                 | Three-finger tap as middle click |
| obsidian                    | Notes / knowledge base           |
| rectangle                   | Window manager                   |
| telegram                    | Messaging                        |
| visual-studio-code          | Code editor                      |
| whatsapp                    | Messaging                        |
| zed                         | Code editor                      |
| zen                         | Web browser (Gecko)              |

## Work casks

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

## Linux-installable casks

Homebrew 4.5+ added preliminary Linux cask support. A small subset of `Brewfile` casks installs via `brew install --cask <name>` on Linuxbrew because the cask source declares either an `os macos: ..., linux: ...` block with `x86_64_linux` / `arm64_linux` sha256 entries (binary CLIs), or a `font` artifact (font files install to the platform font dir). All other casks are macOS-only by artifact (`app`, `pkg`, `darwin` arch) and skipped on Linux with a warning.

| Cask                        | Why Linux works                                  |
| --------------------------- | ------------------------------------------------ |
| 1password-cli               | `binary "op"` + linux sha256 + linux URL         |
| claude-code                 | `binary "claude"` + linux sha256 + linux URL     |
| codex                       | `binary "codex"` + linux sha256 + linux URL      |
| font-fira-code              | `font` artifact (cross-platform)                 |
| font-jetbrains-mono         | `font` artifact (cross-platform)                 |
| font-symbols-only-nerd-font | `font` artifact (cross-platform)                 |

Net: 6 of 37 casks are cross-platform via brew. The remaining 31 either install via vendor deb/rpm on Linux (20) or have no Linux build (11).
