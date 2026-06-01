# Linux Packages

Recommended install path per `Brewfile` / `Brewfile.work` cask on Linux. Each entry links upstream so commands stay current at the source instead of rotting here.

Flatpak and Snap are intentionally not used: both sandbox `~/.config/<tool>/` to per-app paths, which breaks the repo's symlinks. Native `.deb` / `.rpm` packages read `$XDG_CONFIG_HOME` directly and integrate with `apt` / `dnf` for updates.

## Brew-installable on Linuxbrew (no extra work)

Installed automatically by `make brew-install-base` / `make brew-install-work` on Linux:

- Formulae: every `brew "..."` line (`atuin`, `bat`, `eza`, `fd`, `fzf`, `ghostty` deps, etc.)
- Binary casks (Linux URL + sha256): `1password-cli`, `claude-code`, `codex`
- Font casks (cross-platform): `font-fira-code`, `font-jetbrains-mono`, `font-symbols-only-nerd-font`

See [`casks.md`](casks.md#linux-installable-casks) for the cask list.

## Base apps

| App | Recommended method | Source |
|---|---|---|
| 1Password | Vendor apt / dnf repo (auto-updates) | <https://support.1password.com/install-linux/> |
| balenaEtcher | GitHub releases (`.deb` / `.rpm`) | <https://github.com/balena-io/etcher/releases> |
| Brave Browser | Vendor apt / dnf repo (auto-updates) | <https://brave.com/linux/> |
| Cloudflare WARP | Vendor apt / dnf repo (auto-updates) | <https://pkg.cloudflareclient.com/> (docs: <https://developers.cloudflare.com/warp-client/get-started/linux/>) |
| Firefox | Mozilla apt repo on Debian/Ubuntu; distro repo on Fedora | <https://support.mozilla.org/en-US/kb/install-firefox-linux> |
| Ghostty | Ubuntu 26.04+: distro repo. Older Debian/Ubuntu: `mkasberg/ghostty-ubuntu` PPA. Fedora: `pgdev/ghostty` Copr | <https://ghostty.org/docs/linux> |
| Helium Browser | Vendor apt repo (Debian/Ubuntu) or Fedora Copr `imput/helium` | <https://github.com/imputnet/helium-linux> |
| LocalSend | Vendor `.deb` / `.rpm` from GitHub releases | <https://localsend.org/download> |
| Obsidian | Vendor `.deb` (Debian/Ubuntu) or AppImage | <https://obsidian.md/download> |
| Telegram | Distro repo `telegram-desktop` (macOS `telegram` cask is the Cocoa build; Linux distros ship the cross-platform Qt build as `telegram-desktop`) | <https://desktop.telegram.org/> |
| VSCode | Microsoft apt / dnf repo (auto-updates) | <https://code.visualstudio.com/docs/setup/linux> |
| Zed | Official install script (installs to `~/.local`, respects `~/.config/zed/` symlink) | <https://zed.dev/docs/linux> |
| Zen Browser | Official install script (installs to `~/.tarball-installations/zen`) | <https://docs.zen-browser.app/guides/install-linux> |

## Work apps

| App | Recommended method | Source |
|---|---|---|
| Beekeeper Studio | Vendor apt repo (Debian/Ubuntu); `.rpm` from GitHub releases | <https://docs.beekeeperstudio.io/installation/linux/> |
| Bruno | Vendor apt repo (Debian/Ubuntu); `.rpm` from GitHub releases | <https://docs.usebruno.com/get-started/bruno-basics/download> |
| Google Chrome | Vendor `.deb` / `.rpm` (installer adds Google repo for auto-updates) | <https://www.google.com/chrome/> |
| Headlamp | Desktop `.deb` / `.rpm` from GitHub releases | <https://github.com/kubernetes-sigs/headlamp/releases> (docs: <https://headlamp.dev/docs/latest/installation/desktop/>) |
| MongoDB Compass | Vendor `.deb` / `.rpm` | <https://www.mongodb.com/try/download/compass> |
| Slack | Vendor `.deb` / `.rpm` (installer adds Slack repo for auto-updates) | <https://slack.com/downloads/linux> |
| Tailscale | Official install script for CLI + `tailscaled` daemon (no GUI). GUI tray is community: Trayscale (GTK/GNOME), KTailctl (KDE), or `gnome-shell-extension-tailscale-status` | <https://tailscale.com/install.sh> (docs: <https://tailscale.com/docs/install/linux>); Trayscale: <https://github.com/DeedleFake/trayscale> |

## Casks with no Linux build (skipped on Linux)

These install on macOS via brew and have no direct Linux package. GNOME / GTK preferred; well-maintained Electron alternatives listed where they add value.

GUI apps:

| Cask | Linux alternative |
|---|---|
| `horos` | Weasis (Java, cross-platform; no native GTK DICOM viewer exists). Alternatives: Aliza Free, 3D Slicer (Qt) |
| `iina` | Celluloid (GTK4 mpv frontend); Clapper (GTK4 GStreamer); stock `mpv` for CLI |
| `orbstack` | Podman Desktop (Electron, Red Hat) or Rancher Desktop (Electron, adds k3s/k8s); GNOME Boxes for VMs; Distrobox for CLI parity |
| `whatsapp` | ZapZap (GTK4 Wayland-native) or whatsapp-for-linux (GTK3); Beeper Desktop (Electron, multi-IM incl. WhatsApp) as paid all-in-one; `web.whatsapp.com` PWA as fallback |

macOS-system tools:

| Cask | GNOME / GTK alternative |
|---|---|
| `betterdisplay` | `ddcutil` + `ddcui` (Qt) for external DDC; GNOME Settings → Displays for fractional scaling |
| `keepingyouawake` | Caffeine GNOME Shell extension; CLI fallback `systemd-inhibit` |
| `keka` | File Roller (`gnome-archive-manager`, ships with GNOME); right-click in Files |
| `linearmouse` | Piper (GTK GUI for gaming mice); `libinput list-devices` + udev rules for per-device accel |
| `maccy` | GPaste (GTK daemon + GNOME Shell integration); Clipboard Indicator extension as lighter option |
| `middleclick` | `gsettings org.gnome.desktop.peripherals.touchpad middle-click-emulation` (2-finger only; no 3-finger gesture upstream) |
| `rectangle` | Built-in tiling (Super+Arrow, drag-to-edge) + Tiling Assistant extension; PaperWM or Forge for advanced layouts |
| `thaw` | Just Perfection + Top Bar Organizer extensions for top-bar layout control |

## Immutable distros (Bluefin, Fedora Silverblue)

Layer system packages via `rpm-ostree install <pkg>` then reboot, or install inside a Distrobox / Toolbox container. Apps that ship as AppImage (Bruno, Headlamp, LocalSend) or `~/.local` installers (Zed) work unchanged on the host without layering.
