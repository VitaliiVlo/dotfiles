# Linux Tips

Non-obvious shortcuts and behaviors worth remembering for Fedora, Silverblue, Bluefin, Vanilla OS, Zorin OS, Ubuntu. Default assumption: **GNOME on Wayland** across the set. Atomic-specific notes (rpm-ostree / bootc / ABRoot / apx) live in [Distro-specific deltas](#distro-specific-deltas). `gsettings` recipes already applied by `make linux-defaults` are not repeated here, see `scripts/linux-defaults.sh`. macOS equivalents live in [`macos-tips.md`](macos-tips.md).

Targets (current as of mid-2026):

| Stack                | Version baseline                                                                |
| -------------------- | ------------------------------------------------------------------------------- |
| GNOME                | **50 "Tokyo"** (March 2026, Wayland-only, stable VRR + fractional scaling) |
| GTK / libadwaita     | GTK 4.18+, libadwaita 1.8+                                                       |
| Qt / KDE Frameworks  | Qt 6.10+ (Plasma 6.6 Feb 2026, Plasma 6.7 June 2026), KF 6.24+                    |
| Wayland / portals    | `xdg-desktop-portal` 1.20+, `xdg-desktop-portal-gnome` 50, PipeWire 1.6+         |
| Fedora Workstation   | 44 (April 2026, GNOME 50, `dnf5` default)                                       |
| Silverblue    | 44 (April 2026, GNOME 50, atomic via `rpm-ostree` + `bootc`)                    |
| Bluefin              | Rolling on Fedora 44 base, **bootc**-based image                                 |
| Vanilla OS           | **2 "Orchid"** (Jul 2024 release, Debian sid base via Vib, GNOME 46 base + `vso update` advances, ABRoot atomic, `apx` subsystems) |
| Zorin OS             | **18.1** (April 2026, Ubuntu 24.04 HWE base, GNOME 46 themed, Wayland default, supported to April 2029) |
| Ubuntu LTS           | **26.04 LTS "Resolute Raccoon"** (April 2026, GNOME 50, Rust coreutils, systemd 259, cgroup v2 mandatory) |

## Clipboard and paste

Wayland clipboard is per-session and per-MIME. Use the Wayland tools, not the X11 ones (`xclip`/`xsel` only work under XWayland).

| Shortcut / command                | Use                                                                          |
| --------------------------------- | ---------------------------------------------------------------------------- |
| `Ctrl+Shift+V`                    | Paste plain (works in GNOME Terminal, Console, VTE-based terminals)          |
| `wl-copy < file.pub`              | Pipe into clipboard (`wl-clipboard` package)                                 |
| `wl-paste`                        | Print clipboard contents to stdout                                           |
| `wl-paste -t text/plain`          | Force plain-text MIME (strips formatting)                                    |
| `wl-paste -p`                     | Read the primary selection (middle-click buffer)                             |
| Middle-click                      | Paste primary selection (highlight = copy, no shortcut needed)               |

Primary selection and the Ctrl+C clipboard are independent buffers; both survive across Wayland clients but die with the session. For persistent history install the **Clipboard Indicator** GNOME extension (one-click via *Extension Manager* or extensions.gnome.org) — search bar in dropdown, image support, pinning, private mode.

## Screenshots and screen recording

GNOME 42+ ships a unified capture overlay; the standalone `gnome-screenshot` binary is no longer installed by default (still packaged separately if you want `--interactive` from scripts). Fedora / Silverblue / Bluefin / Vanilla / Zorin / Ubuntu all use it.

| Shortcut                       | Use                                                                              |
| ------------------------------ | -------------------------------------------------------------------------------- |
| `Print`                        | Screenshot UI (region / window / full, plus screen recording toggle)             |
| `Shift+Print`                  | Full screen to `~/Pictures/Screenshots` immediately                              |
| `Alt+Print`                    | Active window to file                                                            |
| `Ctrl+Print`                   | Full screen to clipboard, skip file                                              |
| `Ctrl+Alt+Shift+R`             | Start / stop screen recording (built-in, WebM, no audio)                         |
| `Super+Print`                  | Active window to clipboard                                                       |

Built-in recorder has no audio and no cursor toggle. For more control use **OBS Studio** (Flatpak `com.obsproject.Studio` everywhere; native `obs-studio` on Fedora-family via RPM Fusion, on Debian-family via apt). **Kooha** (Flatpak `io.github.seadve.Kooha`) is a simpler portal-based alternative.

## Files (Nautilus) and file dialogs

| Shortcut                  | Use                                                                            |
| ------------------------- | ------------------------------------------------------------------------------ |
| `Ctrl+H`                  | Show / hide hidden files (Nautilus + GTK Open / Save dialogs)                  |
| `Ctrl+L`                  | Type path (`~/.config`, `/etc`, ...). Works inside GTK dialogs too             |
| `Ctrl+1` / `Ctrl+2`       | Grid / list view                                                               |
| `Ctrl+T` / `Ctrl+W`       | New tab / close tab                                                            |
| `Ctrl+Alt+Up/Down`        | Move tab left / right                                                          |
| `Ctrl+D`                  | Bookmark current folder (appears in sidebar)                                   |
| `F2` / `F6`               | Rename / focus path bar                                                        |
| `Space`                   | Quick preview (install `sushi` / `gnome-sushi` from your distro's package manager) |
| Drag file → terminal      | Pastes escaped absolute path (GNOME Terminal, Console, Ghostty)                |
| Drag file → GTK dialog    | Selects that path                                                              |

Right-click a folder in the path bar → *Copy Location* (no native "copy path of selected" yet; install Nautilus extension *nautilus-copypath* from your distro's package manager, or use `realpath` from a shell). Trash lives at `~/.local/share/Trash`; restore via Files → Trash → right-click → Restore.

**Nautilus on GNOME 50** added: batch rename with visual highlighting, multiple file-type search filters (run as `Ctrl+F` then chip filters), faster thumbnail loading, and case-insensitive path bar completion (`~/dow` → `~/Downloads`).

## Properties and metadata

| Shortcut / command            | Use                                                                              |
| ----------------------------- | -------------------------------------------------------------------------------- |
| `Ctrl+I` (Nautilus)           | Properties on selected item                                                      |
| `gio info <file>`             | All GVFS metadata (MIME, owner, attributes) from CLI                             |
| `xdg-mime query default <mime>` | App that opens a given MIME type                                               |
| `xdg-mime default <app.desktop> <mime>` | Change default app for a MIME type                                     |
| `file <path>` / `stat <path>` | MIME by magic / inode stats                                                      |
| Emblems / tags                | Sidebar labels via Nautilus extension *nautilus-emblems* (Copr `eddsalkield/nautilus-emblems` on Fedora-family, native package on Debian-family) |

## Drag-and-drop tricks

| Action                                       | Result                                                                |
| -------------------------------------------- | --------------------------------------------------------------------- |
| Drag selected text → Desktop                 | Creates `.txt` snippet (GNOME, depending on source app)               |
| Drag URL from browser → Files / Desktop      | Creates `.desktop` shortcut                                           |
| Drag attachment from Thunderbird → Files     | Saves file directly                                                   |
| Drag with `Shift` held                       | Force move (across filesystems where copy is default)                 |
| Drag with `Ctrl` held                        | Force copy                                                            |
| Drag with `Ctrl+Shift` held                  | Create symlink                                                        |
| Hover over folder while dragging             | Spring-loaded folder opens after ~1s                                  |

## Window and app lifecycle

GNOME drops the Mac "app stays running with no window" model: closing the last window quits most apps. There is no global menu bar.

| Shortcut                  | Use                                                                             |
| ------------------------- | ------------------------------------------------------------------------------- |
| `Super`                   | Activities overview (windows + workspaces + search)                             |
| `Super+A`                 | App grid                                                                        |
| `Alt+Tab`                 | Switch apps (one entry per app)                                                 |
| `Alt+` `` ` ``            | Cycle windows within the current app                                            |
| `Super+H`                 | Hide / minimize current window                                                  |
| `Alt+F4`                  | Close window                                                                    |
| `Alt+F2`                  | Run-a-command prompt (`r` then Enter restarts GNOME Shell, X11 only)            |
| `Alt+Space`               | Window menu (move, resize, on-top, all workspaces)                              |
| `Super+Up`                | Maximize                                                                        |
| `Super+Down`              | Unmaximize / restore                                                            |
| `Super+Left` / `Super+Right` | Tile to half screen                                                          |
| `Ctrl+Alt+Delete`         | Log-out dialog (default on Ubuntu / Zorin; rebind in *Settings → Keyboard* on Fedora / Silverblue / Bluefin / Vanilla) |
| `Super+L`                 | Lock screen                                                                     |
| `Super+M` / `Super+V`     | Notification list / message tray                                                |

Force-quit a frozen client: `xkill`-equivalent on Wayland is `gnome-shell` Looking Glass (`Alt+F2` → `lg`) or `gdbus call --session --dest org.gnome.Shell ... ForceQuit`. Pragmatic option: `pkill -f <app>` from a terminal.

## Workspaces and overview

GNOME defaults to **dynamic** workspaces (a new empty one appears when the last is used). Switch to a fixed count in *Settings → Multitasking* if you prefer Spaces semantics.

| Shortcut                              | Use                                                       |
| ------------------------------------- | --------------------------------------------------------- |
| `Super+Page Up` / `Super+Page Down`   | Switch workspace                                          |
| `Super+Shift+Page Up` / `…Down`       | Move current window to prev / next workspace              |
| `Super+Home` / `Super+End`            | Jump to first / last workspace                            |
| `Ctrl+Alt+Left` / `Ctrl+Alt+Right`    | Switch workspace (alternate binding)                      |
| Four-finger swipe ←/→ (touchpad)      | Switch workspace                                          |
| Three-finger swipe up (touchpad)      | Activities overview                                       |
| Drag window → workspace strip in overview | Move to that workspace                                |

## GNOME search overlay

Press `Super`, start typing. Searches apps, settings panels, files (Tracker3 index), Characters, Calculator, clipboard (with extension), weather, time zones. Toggle providers in *Settings → Search*.

```text
25 usd in eur          # GNOME Calculator unit conversion
0xff + 0b101           # arithmetic across bases
restart                # logout-equivalent items
displays               # opens Settings → Displays
~/.config              # jumps Files there
```

## Text input

| Shortcut                        | Use                                                              |
| ------------------------------- | ---------------------------------------------------------------- |
| `Ctrl+.` then suggestion        | Emoji picker (works in any GTK 4 / libadwaita text field)        |
| `Ctrl+Shift+U` then hex + Space | Insert Unicode codepoint by hex (IBus, GTK)                      |
| `Alt+Backspace`                 | Delete previous word (most GTK fields, terminals)                |
| `Ctrl+Delete`                   | Delete next word                                                 |
| `Ctrl+A` / `Ctrl+E`             | Start / end of line (readline-style, terminals and many fields)  |
| `Ctrl+K`                        | Delete to end of line (readline)                                 |
| `Ctrl+U`                        | Delete to start of line (readline)                               |

## Reload and refresh

| Shortcut                   | Use                                                                       |
| -------------------------- | ------------------------------------------------------------------------- |
| `F5` / `Ctrl+R`            | Reload page (Firefox, Chrome, Brave, Zen); refresh view (Nautilus, Files) |
| `Ctrl+Shift+R` / `Ctrl+F5` | Hard reload, bypass cache (browsers)                                      |
| `F12` / `Ctrl+Shift+I`     | Open browser dev tools                                                    |
| `Ctrl+Shift+J`             | Dev tools console focus (Chromium browsers)                               |

## Cross-device sharing

No Apple Continuity. Use neutral, network-based tools:

| Tool                | What it does                                                                            |
| ------------------- | --------------------------------------------------------------------------------------- |
| **LocalSend** (see [`applications.md`](applications.md)) | AirDrop-style file send to phones / other desktops on the same LAN (Linux, macOS, Win, iOS, Android) |
| **KDE Connect** (see [`applications.md`](applications.md)) | Phone ↔ desktop: clipboard sync, file send, SMS, media control, find-my-phone, remote input. On GNOME use the **GSConnect** extension (`gnome-shell-extension-gsconnect`) for the same protocol. |
| **syncthing** (see [`applications.md`](applications.md)) | Continuous peer-to-peer folder sync between owned devices, no cloud server |

## Top bar and Quick Settings

GNOME's top-right cluster (network, Bluetooth, volume, battery, power profile) is the *Quick Settings* panel.

| Trick                                              | Use                                                          |
| -------------------------------------------------- | ------------------------------------------------------------ |
| Click clock                                        | Notifications + calendar + world clock                       |
| Click top-right cluster                            | Quick Settings (toggles + sliders + power-off menu)          |
| Scroll on volume slider                            | Fine adjust                                                  |
| `Shift`-click power-profile chip                   | (no-op in stock GNOME; many extensions add modifier actions) |
| Middle-click app icon in dash                      | Open new window                                              |
| `Ctrl+Alt+T`                                       | Open terminal (Ubuntu / Zorin default, **not Fedora / Silverblue / Bluefin / Vanilla**: add in *Settings → Keyboard → Custom Shortcuts*) |

**GNOME Tweaks** (`gnome-tweaks`) exposes settings the main *Settings* UI doesn't: font hinting, title-bar button layout, startup applications, animation speed, window-focus mode. **Extension Manager** (Flatpak `com.mattjakeman.ExtensionManager` everywhere) installs, configures, and updates GNOME shell extensions; replaces the deprecated `extensions.gnome.org` browser-only flow.

Useful extensions:

- **Caffeine** (`KeepingYouAwake` equivalent)
- **Clipboard Indicator** (Maccy equivalent)
- **AppIndicator and KStatusNotifierItem Support** (tray icons for Slack, Telegram, Discord; required on Fedora / Silverblue / Bluefin / Vanilla to see them at all; preinstalled on Zorin and Ubuntu)
- **GSConnect** (phone ↔ desktop integration; KDE Connect protocol on GNOME, see Cross-device sharing)
- **Removable Drive Menu** (eject USB drives from top bar)
- **Bluetooth Quick Connect** (pair / disconnect Bluetooth devices from top bar without opening Settings)
- **Dash to Dock** or **Dash to Panel** (preinstalled as `ubuntu-dock` stripped fork on Ubuntu, `dash-to-dock` proper on Zorin; on Fedora / Silverblue / Bluefin / Vanilla install manually). Same `org.gnome.shell.extensions.dash-to-dock` schema across ubuntu-dock + dash-to-dock, so `linux-defaults.sh` keys apply (click-action behavior diverges in edge cases). Dash to Panel uses its own `dash-to-panel` schema and is unaffected by the repo's gsettings keys.
- **Vitals** (CPU, memory, temps, fan in the top bar)
- **Brightness Control (DDC/CI)** (external monitor brightness via `ddcutil`, see Wayland notes for prereqs)
- **Just Perfection** (fine-grained shell tweaks)
- **Custom Hot Corners (Extended)** (more than the one top-left hot corner GNOME ships)
- **Tiling Shell** (Rectangle equivalent)

## Hot corner and gestures

GNOME ships exactly one hot corner: top-left → Activities. Toggle in *Settings → Multitasking → Hot Corner*. For more corners install the *Custom Hot Corners (Extended)* extension.

Touchpad gestures (libinput, work on every GNOME-on-Wayland distro):

| Gesture                    | Action                              |
| -------------------------- | ----------------------------------- |
| Three-finger swipe up      | Activities overview                 |
| Three-finger swipe down    | App grid                            |
| Three-finger swipe ← / →   | Switch workspace                    |
| Four-finger swipe ← / →    | Switch workspace (alternate)        |
| Pinch in / out             | Zoom in supported apps              |

Mouse-only users: enable *Mouse → Show position on Ctrl press* in **Settings → Accessibility → Pointing & Clicking** (Linux analog to macOS shake-to-find).

## Custom keyboard shortcuts

*Settings → Keyboard → View and Customize Shortcuts → Custom Shortcuts → +*. Common additions worth setting once:

| Binding             | Command                                                                          |
| ------------------- | -------------------------------------------------------------------------------- |
| `Ctrl+Alt+T`        | `ghostty` (Fedora / Silverblue / Bluefin / Vanilla lack this default; preset on Ubuntu / Zorin) |
| `Super+E`           | `nautilus` (Files)                                                                |
| `Super+Shift+S`     | `gnome-screenshot -i` (region capture without going through overlay; install `gnome-screenshot` from your distro's package manager, no longer pulled in by default) |
| `Super+B`           | Browser of choice                                                                 |
| `Pause` / `Scroll`  | `playerctl play-pause` / `playerctl next` (install `playerctl` from your distro's package manager) |

## Image viewer, document viewer, archives

- **Loupe** (`loupe`, see [`applications.md`](applications.md)) GNOME 45+ default image viewer, GPU-accelerated, replaces Eye of GNOME. `Ctrl+R` rotate, `Ctrl+C` copy, drag image out to save.
- **gThumb 4.0** (`gthumb`, see [`applications.md`](applications.md)) GTK 4 + libadwaita organizer / browser / light editor. Catalogs, tags, crop / rotate / color adjust, batch rename, RAW preview via gegl. Pair with Loupe for double-click view.
- **Papers** (see [`applications.md`](applications.md)) GTK 4 + libadwaita default PDF reader. PDF / PS / DjVu / Comic Book. `F5` presentation, `Ctrl+F` find, sidebar tabs include annotations + bookmarks.
- **File Roller** (`file-roller`, see [`applications.md`](applications.md)) double-click any archive (`.zip`, `.tar.*`, `.7z`, `.rar` with `unrar`/`unar`) to browse before extracting.
- **Loupe + gThumb + Papers** all support drag-out-to-save and inline cropping via *Edit → Crop*.

## Fingerprint sudo

If the laptop has a libfprint-supported reader, enroll a finger (`fprintd-enroll`) and enable the PAM module via the distro tool (Fedora / Silverblue / Bluefin: `authselect enable-feature with-fingerprint`; Ubuntu / Zorin / Vanilla: `sudo pam-auth-update`, tick fingerprint). After that, `sudo` in GNOME Terminal / Ghostty accepts the reader instead of a password. Reader support varies by hardware (check `lsusb` against libfprint's supported-devices list); many readers are unsupported, so treat this as opportunistic.

## Shell helpers shipped with most distros

| Command                                       | Use                                                                              |
| --------------------------------------------- | -------------------------------------------------------------------------------- |
| `wl-copy` / `wl-paste`                        | Pipe to / from Wayland clipboard (`wl-clipboard` package)                        |
| `xdg-open .` / `xdg-open file.pdf`            | Open in Files / default app (uses `mimeapps.list`)                               |
| `gio open <file>`                             | Same, via GIO (handles non-file URIs: `gio open https://...`)                    |
| `gio trash <file>`                            | Move to trash instead of `rm` (recoverable from Files → Trash)                   |
| `gio mount smb://server/share`                | Mount remote shares as if from Files sidebar                                     |
| `notify-send "Build done" "exit 0"`           | Desktop notification (also: `&& notify-send ...` after long jobs)                |
| `systemd-inhibit --what=idle:sleep make build` | Block idle/sleep for one command (macOS `caffeinate` analog)                    |
| `spd-say "build finished"`                    | Text-to-speech (speech-dispatcher; pre-installed on Debian-family, install on Fedora-family) |
| `tracker3 search "term"` / `locate file`      | System-wide file search (Tracker indexes GNOME-aware, `locate` via `plocate`)    |
| `nmcli` / `nmtui`                             | NetworkManager CLI / TUI: `nmcli device wifi list`, `nmcli connection up <name>` |
| `bluetoothctl`                                | BlueZ interactive shell: `scan on`, `pair`, `connect`                            |
| `loginctl lock-session`                       | Lock screen from script                                                          |
| `systemctl --user list-units`                 | List per-user systemd services (e.g. pipewire, xdg-desktop-portal)               |
| `journalctl --user -f`                        | Tail per-user journal (Wayland session errors, portal failures land here)        |
| `flatpak run <app.id>` / `flatpak list`       | Run / list Flatpaks (primary user-app channel on Silverblue, Bluefin, Vanilla; common on Fedora Workstation) |
| `gsettings list-recursively org.gnome.<…>`    | Inspect / dconf-dump current GNOME setting values                                |
| `dconf watch /`                               | Live-watch dconf writes (great for reverse-engineering a setting in Settings UI) |

## Wayland-specific notes

- **Per-app HiDPI scaling**: fractional scaling has shipped since GNOME 45 (toggleable on 45-47, on-by-default since GNOME 48, stable defaults in GNOME 50). *Settings → Displays → Scale*. Mixed-DPI multi-monitor works on Wayland, breaks on Xorg.
- **Variable Refresh Rate (VRR)**: opt-in *Settings → Displays → Variable Refresh Rate* on GNOME 46-49, on-by-default for capable displays in GNOME 50.
- **External monitor brightness (DDC/CI)**: *Settings → Displays* slider drives internal panels only. For DDC-capable external monitors install **ddcutil** from your distro's package manager, add user to `i2c` group (`sudo usermod -aG i2c $USER`, re-login). Adjust: `ddcutil setvcp 10 <0-100>`. GNOME extension *Brightness Control (DDC/CI)* wraps it for top-bar sliders.
- **Remote desktop**: built-in GNOME RDP server (*Settings → System → Remote Desktop → Enable Remote Desktop + RDP*). Connect from another machine via `xfreerdp` (package: `freerdp` on Fedora-family, `freerdp2-x11` on Debian-family) or **Remmina** (Flatpak `org.remmina.Remmina` everywhere). SSH still works exactly as on macOS.
- **Screensharing in browsers / Zoom / Slack**: requires `xdg-desktop-portal-gnome` (or `-gtk`). If picker is blank, `systemctl --user restart xdg-desktop-portal*`.
- **PipeWire** handles audio + screencast + camera; pulseaudio CLI tools (`pactl`, `pacmd`) still work via the `pipewire-pulse` shim.

## Distro-specific deltas

### Fedora Workstation / Silverblue / Bluefin

- Fedora 44 (April 28, 2026) ships GNOME 50, KDE Plasma 6.6, kernel 6.19, glibc 2.43 across all variants.
- Workstation package manager: `dnf5` (default since Fedora 41, Nov 2024). `dnf5 search`, `dnf5 install`, `dnf5 history`. Group install: `dnf5 group install "Development Tools"`.
- Codecs: enable **RPM Fusion** (`free` + `nonfree`) for h264, ffmpeg, Intel VAAPI drivers. One-liner: `dnf5 install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`. On Silverblue / Bluefin, layer the same RPMs via `rpm-ostree install <url>` then reboot.
- Silverblue (atomic): root image immutable. `rpm-ostree install <pkg>` layers packages onto the next deployment (reboot to apply); `rpm-ostree status` shows current + pending deployments; `rpm-ostree rollback` reverts to the previous one. Prefer **Flatpak** (`flatpak install flathub <app.id>`) or **Toolbox / Distrobox** (`toolbox create`, `distrobox create`) for everything user-space; layer only what must touch the host.
- Bluefin (atomic, Silverblue base + devex layer): migrated from pure `rpm-ostree` to **bootc**-based images during 2025. `bootc upgrade` / `bootc switch` move the deployed image; `rpm-ostree install` still works for ad-hoc layering. Prefer Flatpak or `brew` for user-space tools to keep the base image clean.
- Bluefin tasks via `ujust`: `ujust` (menu), `ujust toggle-pop-shell`, `ujust install-system-flatpaks`, `ujust setup-luks-tpm-unlock`, `ujust install-coding-extras`. Self-documenting; run with no args to browse.
- SELinux enforcing by default on all three. If an app refuses to read a file with no obvious permission issue, check `journalctl -t setroubleshoot` or `ausearch -m avc -ts recent`.

### Ubuntu (26.04 LTS "Resolute Raccoon")

- Package manager: `apt`. `apt update`, `apt install`, `apt full-upgrade`. `apt list --installed`, `apt-mark hold <pkg>` to pin.
- Ships GNOME 50 on a Wayland-only session (XWayland kept for legacy apps). systemd 259 with mandatory cgroup v2. Memory-safe **Rust-based core utilities** (uutils 0.8.0) replace GNU coreutils for ~80 binaries (`ls`, `cat`, `tr`, `sort`, `wc`, `head`, ...); `cp`, `mv`, `rm` remain GNU. Behavior is GNU-compatible but stricter on a few edge cases (locale handling, exit codes on malformed flags).
- Snaps preinstalled (Firefox, snap-store, Thunderbird is back to deb on 26.04). Disable / replace with deb / Flatpak by removing `snapd` if you prefer.
- NVIDIA Wayland performance noticeably improved (explicit-sync protocol, GBM by default). `ubuntu-drivers devices` + `ubuntu-drivers autoinstall` for NVIDIA / Broadcom.

### Vanilla OS

Latest: **Vanilla OS 2 "Orchid"** (July 2024, Debian sid base via Vib, GNOME 46, ABRoot atomic). Updates ride on `vso` (vanilla system operator); ABRoot keeps two parallel root images for atomic rollback. Host kept minimal; most user-space packages run inside `apx` subsystems (Distrobox wrapper) rather than on the host root.

- Package manager: **`apx`**. `apx install <pkg>` defaults to a managed Distrobox subsystem (`apx list` to inspect). For host-level layering: `apx install --sysprefix vso-core <pkg>` writes into the next ABRoot deployment, reboot to apply. No direct host `apt` by default.
- Updates: `vso update` (downloads to inactive root), reboot to apply. `vso config` for upgrade scheduling and channel pin. `vso trigger-update` for immediate check.
- Wayland session ships default. NVIDIA users: prefer the **`vanilla-exp`** image variant for a newer driver stack.
- GNOME 46 base lags GNOME 50 on Fedora 44 / Ubuntu 26.04; `vso update` may advance the host GNOME as the Vib pipeline cuts new Orchid images, so the gap depends on channel + update cadence rather than a fixed cycle count. Trade is atomic rollback safety + Debian package depth, not bleeding-edge GNOME features (HDR maturity, GNOME 50 Tokyo polish).
- Configs in this repo apply unchanged: XDG paths honored, `flatpak` + `brew` recommended for user-space tools.

### Zorin OS

Latest: **Zorin OS 18.1** (April 2026, Ubuntu 24.04 HWE base, GNOME 46-based with heavy theming, supported through April 2029).

- GNOME with a polished layout chooser (*Zorin Appearance*) that mimics macOS, Windows 11, Windows Classic, or GNOME. Most GNOME tips above apply.
- Tray icons work out of the box (AppIndicator extension preinstalled).
- **Zorin Connect** is GSConnect rebranded; pairs with the Zorin Connect Android app.
- Optional Zorin OS Pro layouts add Windows 11 / macOS-style polish; the free Core edition is the base for everything else in this section.

## Per-app update channels

Linux GUI apps install via vendor packages, not Linuxbrew casks. Update path per delivery mechanism:

- **Vendor apt/dnf repo** (covered by `sudo apt-get upgrade` / `sudo dnf upgrade`): 1Password, balenaEtcher, Brave, Cloudflare WARP, Firefox, Ghostty (Ubuntu universe or Fedora Copr), Google Chrome, Slack, Tailscale (CLI + daemon only; optional community GUI tray via Flathub `dev.deedles.Trayscale`), Telegram (Ubuntu apt `telegram-desktop`, Fedora RPM Fusion `telegram-desktop`), VSCodium (`vscodium.com/install` for apt/dnf repo setup).
- **Linuxbrew (`brew upgrade`)**: CLI casks that build for Linux (claude-code, codex, 1password-cli) plus the font casks (Fira Code, JetBrains Mono, Symbols Nerd Font). See [`casks.md`](casks.md) "Linux-installable casks".
- **In-app updater**: Obsidian, Zed.
- **Manual GitHub release re-download**: Beekeeper Studio, Bruno, Freelens, LocalSend.
- **Manual vendor download re-download**: MongoDB Compass (`mongodb.com/try/download/compass`).

macOS counterpart: cask auto-update via `brew upgrade` covers everything (the apps with in-app updaters still defer to cask). See [`../README.md#updating`](../README.md#updating) for the cross-platform toolchain update commands (Go, Node, Python).

## Hold Super, then... is not a thing

Unlike macOS `Option`, GNOME does not generally vary menu items / window-button behavior under modifier keys. The closest equivalents:

- `Super` overlay: pressing alone opens Activities; combined with letters / arrows triggers shortcuts.
- `Alt`-drag a window: move from any point (not just the title bar).
- `Super`-drag a window: resize from any point.
- `Ctrl`-scroll in Files / image viewer: zoom.
- Right-click most surfaces: usually the only path to "alternate" actions (no Option-click equivalent).
