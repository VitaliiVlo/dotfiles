# Linux Tips

Non-obvious shortcuts and behaviors worth remembering for the distros tracked in [`applications.md`](applications.md) (Fedora, Bluefin, Zorin OS, Pop!_OS, Ubuntu, Linux Mint). Default assumption: **GNOME on Wayland**. Cinnamon (Linux Mint) and COSMIC (Pop!_OS 24.04 LTS+) deltas live in [Distro-specific deltas](#distro-specific-deltas). `gsettings` recipes already applied by `make linux-defaults` are not repeated here, see `scripts/linux-defaults.sh`. macOS equivalents live in [`macos-tips.md`](macos-tips.md).

Targets (current as of mid-2026):

| Stack                | Version baseline                                                                |
| -------------------- | ------------------------------------------------------------------------------- |
| GNOME                | 48 (March 2025), 49 (Sept 2025), **50 "Tokyo"** (March 2026, Wayland-only, stable VRR + fractional scaling) |
| GTK / libadwaita     | GTK 4.18+, libadwaita 1.8+                                                       |
| Qt / KDE Frameworks  | Qt 6.10+ (Plasma 6.6 Feb 2026, Plasma 6.7 June 2026), KF 6.24+                    |
| Wayland / portals    | `xdg-desktop-portal` 1.20+, `xdg-desktop-portal-gnome` 50, PipeWire 1.4+         |
| Fedora Workstation   | 44 (April 2026, GNOME 50, `dnf5` default)                                       |
| Bluefin              | Rolling on Fedora 44 base, **bootc**-based image                                 |
| Ubuntu LTS           | **26.04 LTS "Resolute Raccoon"** (April 2026, GNOME 50, Rust coreutils, systemd 259, cgroup v2 mandatory); 24.04 LTS still supported |
| Pop!_OS              | **24.04 LTS** (December 2025, COSMIC default; receives rolling COSMIC Epoch updates) |
| COSMIC               | Epoch 1.0.8+ (Feb 2026)                                                          |
| Linux Mint (Cinnamon)| **22.3 "Zena"** (Jan 2026, Cinnamon 6.4, Ubuntu 24.04 base, supported to April 2029) |
| Zorin OS             | **18.1** (April 2026, Ubuntu 24.04 HWE base, supported to April 2029)            |

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

Primary selection and the Ctrl+C clipboard are independent buffers; both survive across Wayland clients but die with the session. For a persistent history install **Clipse** (TUI) or **Maccy** equivalents like `gpaste`/`clipman`/GNOME extension *Clipboard Indicator*.

## Screenshots and screen recording

GNOME 42+ ships a unified capture overlay; the standalone `gnome-screenshot` binary is no longer installed by default (still packaged separately if you want `--interactive` from scripts). Pop!_OS / Ubuntu / Fedora / Bluefin / Zorin all use it.

| Shortcut                       | Use                                                                              |
| ------------------------------ | -------------------------------------------------------------------------------- |
| `Print`                        | Screenshot UI (region / window / full, plus screen recording toggle)             |
| `Shift+Print`                  | Full screen to `~/Pictures/Screenshots` immediately                              |
| `Alt+Print`                    | Active window to file                                                            |
| `Ctrl+Print`                   | Full screen to clipboard, skip file                                              |
| `Ctrl+Alt+Shift+R`             | Start / stop screen recording (built-in, WebM, no audio)                         |
| `Super+Print`                  | Active window to clipboard                                                       |

Built-in recorder has no audio and no cursor toggle. For anything beyond a quick clip on GNOME use **OBS Studio** (PipeWire capture, "Screen Capture (PipeWire)" source), **Kooha** (Flatpak `io.github.seadve.Kooha`, also portal-based), or **gpu-screen-recorder** (NVENC / VAAPI / AV1 hardware encode).

`grim` + `slurp`, `wf-recorder`, and `wl-screenrec` are **wlroots-only** (Sway, Hyprland, Wayfire) and do **not** work on GNOME's Mutter or COSMIC: they rely on the `wlr-screencopy-v1` protocol, which neither compositor implements. On GNOME / COSMIC, all third-party screen capture goes through `xdg-desktop-portal-gnome` / `xdg-desktop-portal-cosmic` (PipeWire stream).

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
| `Space`                   | Quick preview (install `sushi` first: `dnf install sushi`, `apt install sushi`) |
| Drag file → terminal      | Pastes escaped absolute path (GNOME Terminal, Console, Ghostty)                |
| Drag file → GTK dialog    | Selects that path                                                              |

Right-click a folder in the path bar → *Copy Location* (no native "copy path of selected" yet; install Nautilus extension *nautilus-copypath* or use `realpath`). Trash lives at `~/.local/share/Trash`; restore via Files → Trash → right-click → Restore.

**Nautilus on GNOME 50** added: batch rename with visual highlighting, multiple file-type search filters (run as `Ctrl+F` then chip filters), faster thumbnail loading, and case-insensitive path bar completion (`~/dow` → `~/Downloads`).

## Properties and metadata

| Shortcut / command            | Use                                                                              |
| ----------------------------- | -------------------------------------------------------------------------------- |
| `Ctrl+I` (Nautilus)           | Properties on selected item                                                      |
| `gio info <file>`             | All GVFS metadata (MIME, owner, attributes) from CLI                             |
| `xdg-mime query default <mime>` | App that opens a given MIME type                                               |
| `xdg-mime default <app.desktop> <mime>` | Change default app for a MIME type                                     |
| `file <path>` / `stat <path>` | MIME by magic / inode stats                                                      |
| Emblems / tags                | Sidebar labels via Nautilus extension *nautilus-emblems* (not on by default)     |

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
| `Ctrl+Alt+Delete`         | Log-out dialog (default on Ubuntu / Pop / Mint; rebind in *Settings → Keyboard* on Fedora / Bluefin / Zorin) |
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

For richer launching install **Ulauncher** or **GNOME Pie**; for fzf-style window switching the extension *Window Calls* + a custom keybinding works well.

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

System-wide text expansion: install **Espanso** (cross-platform, works on Wayland via virtual keyboard protocol). Falls back to clipboard-paste injection where the protocol is unavailable.

## OCR and image-to-text

No built-in equivalent of macOS Live Text. Closest options:

- **Frog** (`flatpak install flathub com.github.tenderowl.frog`) GUI OCR of regions, files, screenshots, drag-and-drop. Tesseract backend.
- **TextSnatcher** (`flatpak install flathub com.github.rajsolai.textsnatcher`) screenshot-then-OCR overlay; Tesseract backend.
- CLI: `tesseract input.png - -l eng`. Pre-process with `convert -density 300 ...` for low-res images.

## Cross-device sharing

No Apple Continuity. Use neutral, network-based tools:

| Tool                | What it does                                                                            |
| ------------------- | --------------------------------------------------------------------------------------- |
| **LocalSend**       | AirDrop-style file send to phones / other desktops on the same LAN (Linux, macOS, Win, iOS, Android) |
| **KDE Connect**     | Phone ↔ desktop: clipboard sync, file send, SMS, media control, find-my-phone, remote input (works fine in GNOME via `gnome-shell-extension-gsconnect`) |
| **Tailscale**       | Mesh VPN. `tailscale file cp ./report.pdf <host>:` for direct file send across machines |
| **Warpinator**      | Mint-native LAN file send (Cinnamon default, also Flatpak)                              |
| **syncthing**       | Folder sync between any two devices, no cloud                                           |

## Top bar and Quick Settings

GNOME's top-right cluster (network, Bluetooth, volume, battery, power profile) is the *Quick Settings* panel.

| Trick                                              | Use                                                          |
| -------------------------------------------------- | ------------------------------------------------------------ |
| Click clock                                        | Notifications + calendar + world clock                       |
| Click top-right cluster                            | Quick Settings (toggles + sliders + power-off menu)          |
| Scroll on volume slider                            | Fine adjust                                                  |
| `Shift`-click power-profile chip                   | (no-op in stock GNOME; many extensions add modifier actions) |
| Middle-click app icon in dash                      | Open new window                                              |
| `Ctrl+Alt+T`                                       | Open terminal (Ubuntu / Mint default, **not Fedora / Bluefin**: add in *Settings → Keyboard → Custom Shortcuts*) |

Useful extensions (install via *Extension Manager*, `extension-manager` package):

- **Caffeine** (`KeepingYouAwake` equivalent)
- **Clipboard Indicator** (Maccy equivalent)
- **AppIndicator and KStatusNotifierItem Support** (tray icons for Slack, Telegram, Discord; required on Fedora / Bluefin / Zorin to see them at all)
- **Dash to Dock** or **Dash to Panel** (already a focus on Zorin/Ubuntu; on Fedora install manually)
- **Vitals** (CPU, memory, temps, fan in the top bar)
- **Just Perfection** (fine-grained shell tweaks)
- **Tactile** / **Tiling Shell** (Rectangle equivalent)

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
| `Ctrl+Alt+T`        | `ghostty` (Fedora / Bluefin / Zorin lack this default)                            |
| `Super+E`           | `nautilus` (Files)                                                                |
| `Super+Shift+S`     | `gnome-screenshot -i` (region capture without going through overlay; install the `gnome-screenshot` package first, it is no longer pulled in by default) |
| `Super+B`           | Browser of choice                                                                 |
| `Pause` / `Scroll`  | `playerctl play-pause` / `playerctl next` (needs `playerctl` package)             |

## Image viewer, document viewer, archives

- **Loupe** (`loupe`) GNOME 45+ default image viewer, GPU-accelerated, replaces Eye of GNOME. `Ctrl+R` rotate, `Ctrl+C` copy, drag image out to save.
- **Papers** (formerly **Evince**, package `papers` on Fedora 41+ and Ubuntu 26.04+, still `evince` on Ubuntu 24.04 / Mint 22.x / Zorin 17) PDF / PS / DjVu / Comic Book. `F5` presentation, `Ctrl+F` find, sidebar tabs include annotations + bookmarks.
- **File Roller** (`file-roller`) double-click any archive (`.zip`, `.tar.*`, `.7z`, `.rar` with `unrar`/`unar`) to browse before extracting.
- **GNOME Image Viewer + Loupe + Papers** all support drag-out-to-save and Markup-style cropping via *Edit → Crop*.

For PDF signing / form-fill / page reordering use **Xournal++** (annotations + signatures) or **PDF Arranger** (split / merge / rotate / reorder pages, no quality loss).

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
| `spd-say "build finished"`                    | Text-to-speech (speech-dispatcher; pre-installed on Ubuntu/Pop, install on Fedora) |
| `tracker3 search "term"` / `locate file`      | System-wide file search (Tracker indexes GNOME-aware, `locate` via `plocate`)    |
| `nmcli` / `nmtui`                             | NetworkManager CLI / TUI: `nmcli device wifi list`, `nmcli connection up <name>` |
| `bluetoothctl`                                | BlueZ interactive shell: `scan on`, `pair`, `connect`                            |
| `loginctl lock-session`                       | Lock screen from script                                                          |
| `systemctl --user list-units`                 | List per-user systemd services (e.g. pipewire, xdg-desktop-portal)               |
| `journalctl --user -f`                        | Tail per-user journal (Wayland session errors, portal failures land here)        |
| `flatpak run <app.id>` / `flatpak list`       | Run / list Flatpaks (most desktop apps on Bluefin, Mint, Fedora Workstation)     |
| `gsettings list-recursively org.gnome.<…>`    | Inspect / dconf-dump current GNOME setting values                                |
| `dconf watch /`                               | Live-watch dconf writes (great for reverse-engineering a setting in Settings UI) |

## Wayland-specific notes

- **Per-app HiDPI scaling**: fractional scaling has shipped since GNOME 45 (toggleable on 45-47, on-by-default since GNOME 48, stable defaults in GNOME 50). *Settings → Displays → Scale*. Mixed-DPI multi-monitor works on Wayland, breaks on Xorg.
- **Variable Refresh Rate (VRR)**: opt-in *Settings → Displays → Variable Refresh Rate* on GNOME 46-49, on-by-default for capable displays in GNOME 50.
- **Color picker**: GNOME's built-in screenshot UI does not pick colors. Use the *Color Picker* GNOME extension, the `gcolor3` GTK app, KDE's `kcolorchooser`, or call the portal directly with `gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.Screenshot.PickColor / '{}'`.
- **Window position scripting**: not exposed on Wayland by design. Use `wmctrl` / `xdotool` only under XWayland (Electron, JetBrains pre-2024 builds). For Wayland-native automation: `ydotool` (uinput, needs `ydotoold` service) or per-compositor IPC (Sway/Hyprland only; GNOME exposes none).
- **Remote desktop**: built-in GNOME RDP server (*Settings → System → Remote Desktop → Enable Remote Desktop + RDP*). Connect with `xfreerdp` / Remmina from another machine. SSH still works exactly as on macOS.
- **Screensharing in browsers / Zoom / Slack**: requires `xdg-desktop-portal-gnome` (or `-gtk`). If picker is blank, `systemctl --user restart xdg-desktop-portal*`.
- **PipeWire** handles audio + screencast + camera; pulseaudio CLI tools (`pactl`, `pacmd`) still work via the `pipewire-pulse` shim.

## Distro-specific deltas

### Fedora Workstation / Bluefin

- Package manager: `dnf5` (default since Fedora 41, Nov 2024). `dnf5 search`, `dnf5 install`, `dnf5 history`. Group install: `dnf5 group install "Development Tools"`.
- Codecs: enable **RPM Fusion** (`free` + `nonfree`) for h264, ffmpeg, Intel VAAPI drivers. One-liner: `dnf5 install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`.
- Fedora 44 (April 28, 2026) ships GNOME 50, KDE Plasma 6.6, kernel 6.14, glibc 2.41.
- Bluefin (atomic): migrated from pure `rpm-ostree` to **bootc**-based images during 2025. `bootc upgrade` / `bootc switch` move the deployed image; `rpm-ostree install <pkg>` still works for layering packages onto it (reboot to apply). Prefer Flatpak or `brew` for user-space tools whenever possible to keep the base image clean.
- Bluefin tasks via `ujust`: `ujust` (menu), `ujust toggle-pop-shell`, `ujust install-system-flatpaks`, `ujust setup-luks-tpm-unlock`, `ujust install-coding-extras`. Self-documenting; run with no args to browse.
- SELinux is enforcing by default. If an app refuses to read a file with no obvious permission issue, check `journalctl -t setroubleshoot` or `ausearch -m avc -ts recent`.

### Ubuntu (26.04 LTS "Resolute Raccoon")

- Package manager: `apt`. `apt update`, `apt install`, `apt full-upgrade`. `apt list --installed`, `apt-mark hold <pkg>` to pin.
- Ships GNOME 50 on a Wayland-only session (XWayland kept for legacy apps). systemd 259 with mandatory cgroup v2. Memory-safe **Rust-based core utilities** replace GNU coreutils for most binaries (`ls`, `cp`, `mv`, ...); behavior is GNU-compatible but stricter on a few edge cases (locale handling, exit codes on malformed flags).
- Snaps preinstalled (Firefox, snap-store, Thunderbird is back to deb on 26.04). Disable / replace with deb / Flatpak by removing `snapd` if you prefer.
- NVIDIA Wayland performance noticeably improved (explicit-sync protocol, GBM by default). `ubuntu-drivers devices` + `ubuntu-drivers autoinstall` for NVIDIA / Broadcom.
- 24.04 LTS "Noble Numbat" remains supported until April 2029 (ESM to 2034). On 24.04, GNOME is 46, evince is the PDF reader, and Rust coreutils are not the default.

### Pop!_OS 24.04 LTS (COSMIC)

System76 cut Pop!_OS 24.04 LTS on December 11, 2025 with **COSMIC** (Rust-based DE) as the default, replacing the GNOME-plus-Pop-Shell stack from Pop!_OS 22.04. COSMIC Epoch 1.x ships continuous point releases (1.0.8 in Feb 2026). Pop!_OS 26.04 LTS is on the roadmap with a new versioning scheme.

Most GNOME shortcuts above do not apply on COSMIC. Highlights:

- Built-in auto-tiling everywhere (no Pop Shell extension). Toggle floating per-window `Super+G`. Stack mode `Super+S`.
- Tile resize / move with `Super+arrow`; detach window with `Super+Ctrl+arrow`; tile direction `Super+O`.
- Workspaces are per-display by default. Configure in `cosmic-settings → Workspaces`.
- App library `Super+A`; Launcher `Super`. Settings is a separate native app (`cosmic-settings`, not `gnome-control-center`).
- Files manager is **COSMIC Files** (not Nautilus). Terminal is **COSMIC Terminal**. Text editor is **COSMIC Edit**. Shortcut conventions track GNOME closely.
- App ecosystem: GTK / libadwaita / Qt apps all work; COSMIC reads `XDG_*` env vars normally, so the dotfiles in this repo apply unchanged.

For users still on **Pop!_OS 22.04 LTS** (GNOME 42 + Pop Shell): `Super+Y` toggle auto-tiling, `Super+arrow` tile direction, `Super+G` float exception, `Super+Ctrl+arrow` detach.

### Linux Mint (Cinnamon)

Latest: **Linux Mint 22.3 "Zena"** (January 2026, Cinnamon 6.4, Ubuntu 24.04 base, supported through April 2029). Mint exhausted its A-Z codename series with Zena; the next major release is slated for late 2026 with a longer development cycle. HWE ISOs ship kernel 6.17.

- Different DE: Cinnamon, not GNOME Shell. Notable shortcut deltas:
  - `Ctrl+Alt+T` opens terminal (default).
  - `Super+L` lock screen.
  - `Ctrl+Alt+arrow` switch workspace (no `Super+Page` binding by default).
  - `Ctrl+Alt+Up` Scale (Mission Control equivalent), `Ctrl+Alt+Down` Expo (workspaces grid).
- Files manager: **Nemo** (Nautilus fork). Same `Ctrl+H` / `Ctrl+L` / `F2`. Adds *Open as root* + dual-pane (`F3`).
- Default cross-device sharing: **Warpinator** (Mint's own).
- Software sources: deb + Flatpak. Snap disabled by default. Mint Update Manager batches updates by safety level.
- Timeshift preinstalled for system snapshots; configure on first boot.
- Cinnamon defaults to Xorg, not Wayland (Cinnamon's Wayland session is still experimental as of 6.4). Several Wayland-only tips in this doc (HDR, fractional scaling on mixed-DPI, `wl-clipboard`) do not apply unless you flip the session manually at the login screen.

### Zorin OS

Latest: **Zorin OS 18.1** (April 15, 2026, Ubuntu 24.04 HWE base, GNOME 46-based with heavy theming, supported through April 2029). Zorin OS 18 first shipped October 2025; 18.1 added 240+ Windows-app installer detection entries and the **Zorin OS Lite** (Xfce) edition is back.

- GNOME with a polished layout chooser (*Zorin Appearance*) that mimics macOS, Windows 11, Windows Classic, or GNOME. Most GNOME tips above apply.
- Tray icons work out of the box (AppIndicator extension preinstalled).
- **Zorin Connect** is GSConnect rebranded; pairs with the Zorin Connect Android app.
- Optional Zorin OS Pro layouts add Windows 11 / macOS-style polish; the free Core edition is the base for everything else in this section.

## Hold Super, then... is not a thing

Unlike macOS `Option`, GNOME does not generally vary menu items / window-button behavior under modifier keys. The closest equivalents:

- `Super` overlay: pressing alone opens Activities; combined with letters / arrows triggers shortcuts.
- `Alt`-drag a window: move from any point (not just the title bar).
- `Super`-drag a window: resize from any point.
- `Ctrl`-scroll in Files / image viewer: zoom.
- Right-click most surfaces: usually the only path to "alternate" actions (no Option-click equivalent).
