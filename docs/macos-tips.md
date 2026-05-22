# macOS Tips

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
