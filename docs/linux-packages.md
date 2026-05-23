# Linux Packages

Native install paths for every `Brewfile` / `Brewfile.work` cask that has a Linux build. Flatpak is intentionally not used: vendor `.deb` / `.rpm` packages respect `~/.config/<tool>/` so the repo's symlinks work unchanged, and vendor repos integrate with `apt` / `dnf` for updates.

Brew handles formulae and a small subset of cross-platform casks (binary CLIs + fonts) on Linuxbrew. Everything else is installed once via the vendor instructions below.

## Brew-installable on Linuxbrew (no extra work)

These install automatically via `make brew-install-base` / `make brew-install-work` on Linux:

- Formulae: every `brew "..."` line (`atuin`, `bat`, `eza`, `fd`, `fzf`, `ghostty` deps, etc.)
- Binary casks (linux URL + sha256): `1password-cli`, `claude-code`, `codex`
- Font casks (cross-platform): `font-fira-code`, `font-jetbrains-mono`, `font-symbols-only-nerd-font`

See [`casks.md`](casks.md#linux-installable-casks) for the cask list.

## Base apps

Run on a clean Linux host once. All commands are idempotent.

### 1Password

```bash
# deb
curl -sS https://downloads.1password.com/linux/keys/1password.asc \
  | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" \
  | sudo tee /etc/apt/sources.list.d/1password.list
sudo apt-get update && sudo apt-get install -y 1password

# rpm
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo'
sudo dnf install -y 1password
```

### balenaEtcher

Download latest `.deb` or `.rpm` from <https://github.com/balena-io/etcher/releases>:

```bash
# deb
sudo apt-get install -y ./balena-etcher_*_amd64.deb

# rpm
sudo dnf install -y ./balena-etcher-*.x86_64.rpm
```

### Brave Browser

```bash
# deb
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
  | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt-get update && sudo apt-get install -y brave-browser

# rpm
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install -y brave-browser
```

### Cloudflare WARP

```bash
# deb
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg \
  | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
sudo apt-get update && sudo apt-get install -y cloudflare-warp

# rpm
sudo dnf config-manager --add-repo https://pkg.cloudflareclient.com/cloudflare-warp-ascii.repo
sudo dnf install -y cloudflare-warp
```

### Firefox

```bash
# deb (Mozilla official apt repo)
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://packages.mozilla.org/apt/repo-signing-key.gpg \
  | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
  | sudo tee /etc/apt/sources.list.d/mozilla.list
sudo apt-get update && sudo apt-get install -y firefox

# rpm
sudo dnf install -y firefox  # ships in Fedora repos
```

### Ghostty

Official upstream: build from source, Snap, or AppImage. Native packages via community repos:

```bash
# deb (Ubuntu 26.04 universe)
sudo apt-get install -y ghostty

# deb (Debian / older Ubuntu, community)
# Releases at https://github.com/mkasberg/ghostty-ubuntu/releases
curl -fsSLO https://github.com/mkasberg/ghostty-ubuntu/releases/latest/download/ghostty_amd64.deb
sudo apt-get install -y ./ghostty_amd64.deb

# rpm (Fedora Copr)
sudo dnf copr enable -y pgdev/ghostty
sudo dnf install -y ghostty
```

### Helium Browser

```bash
# deb
curl -fsSL https://raw.githubusercontent.com/imputnet/helium-linux/main/pubkey.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/helium.gpg
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/helium.gpg] https://pkg.helium.computer/deb stable main" \
  | sudo tee /etc/apt/sources.list.d/helium.list
sudo apt-get update && sudo apt-get install -y helium-bin

# rpm (Fedora Copr)
sudo dnf copr enable -y imput/helium
sudo dnf install -y helium-bin
```

### LocalSend

Download latest `.deb` or `.rpm` from <https://github.com/localsend/localsend/releases>:

```bash
sudo apt-get install -y ./LocalSend-*-linux-x86-64.deb
sudo dnf install -y  ./LocalSend-*-linux-x86-64.rpm
```

### Obsidian

Download latest `.deb` or `.rpm` from <https://github.com/obsidianmd/obsidian-releases/releases>:

```bash
sudo apt-get install -y ./obsidian_*_amd64.deb
sudo dnf install -y  ./obsidian-*.x86_64.rpm
```

### VSCode

```bash
# deb
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | sudo gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
  | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt-get update && sudo apt-get install -y code

# rpm
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code
```

### Zed

Official upstream ships a tarball via install script (no deb/rpm). Installs to `~/.local` so it respects the repo's `~/.config/zed/settings.json` symlink:

```bash
curl -f https://zed.dev/install.sh | sh
```

Community packages (optional): `lucasliet/zed-deb` (Debian), Fedora Copr `che/zed`.

### Zen Browser

Official upstream ships tarball + AppImage. Native packages via community repos:

```bash
# deb (community)
# Releases at https://github.com/sh4r10/zen-browser-debian/releases
curl -fsSLO https://github.com/sh4r10/zen-browser-debian/releases/latest/download/zen-browser_amd64.deb
sudo apt-get install -y ./zen-browser_amd64.deb

# rpm (Fedora Copr)
sudo dnf copr enable -y sneexy/zen-browser
sudo dnf install -y zen-browser
```

## Work apps

### Beekeeper Studio

```bash
# deb
curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/beekeeper.gpg
echo "deb [signed-by=/etc/apt/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" \
  | sudo tee /etc/apt/sources.list.d/beekeeper-studio-app.list
sudo apt-get update && sudo apt-get install -y beekeeper-studio

# rpm
# Download latest from https://github.com/beekeeper-studio/beekeeper-studio/releases
sudo dnf install -y ./Beekeeper-Studio-*.x86_64.rpm
```

### Bruno

Download latest `.deb` or `.rpm` from <https://github.com/usebruno/bruno/releases>:

```bash
sudo apt-get install -y ./bruno_*_amd64.deb
sudo dnf install -y  ./bruno-*.x86_64.rpm
```

### Google Chrome

```bash
# deb
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
  | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update && sudo apt-get install -y google-chrome-stable

# rpm
sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
```

### Headlamp

Download latest `.deb` or `.rpm` from <https://github.com/kubernetes-sigs/headlamp/releases>:

```bash
sudo apt-get install -y ./Headlamp-*-linux-amd64.deb
sudo dnf install -y  ./Headlamp-*-linux-x86_64.rpm
```

### MongoDB Compass

Download latest `.deb` or `.rpm` from <https://www.mongodb.com/try/download/compass>:

```bash
sudo apt-get install -y ./mongodb-compass_*_amd64.deb
sudo dnf install -y  ./mongodb-compass-*.x86_64.rpm
```

### Slack

Download latest `.deb` or `.rpm` from <https://slack.com/downloads/linux>:

```bash
sudo apt-get install -y ./slack-desktop-*-amd64.deb
sudo dnf install -y  ./slack-*.x86_64.rpm
```

### Tailscale

CLI + daemon ship as `tailscale` package. GUI tray is community (`trayscale` AppImage, GNOME extension).

```bash
# deb / rpm (vendor installer)
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled
```

## Casks with no Linux build (skipped on Linux)

These install on macOS via brew and have no Linux equivalent:

- **GUI apps**: `horos` (DICOM viewer, macOS-only), `orbstack` (macOS host required)
- **macOS-system tools**: `betterdisplay`, `keepingyouawake`, `keka`, `linearmouse`, `maccy`, `middleclick`, `rectangle`, `thaw` (equivalents are distro-specific GNOME/KDE settings or extensions)

## Immutable distros (Bluefin, Fedora Silverblue)

Layer system packages via `rpm-ostree install <pkg>` then reboot, or install inside a Distrobox/Toolbox container. Apps that ship as AppImage (Bruno, Headlamp, LocalSend) or `~/.local` installers (Zed) work unchanged on the host without layering.
