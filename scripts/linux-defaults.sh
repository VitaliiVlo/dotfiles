#!/usr/bin/env bash

set -euo pipefail

heading() { printf "\n\033[1;34m%s\033[0m\n" "$*"; }
set_if_exists() {
    local schema="$1" key="$2" value="$3"
    if ! gsettings list-keys "$schema" 2>/dev/null | grep -qx "$key"; then
        echo "linux-defaults: schema $schema missing, skipping $key" >&2
        return 0
    fi
    if ! gsettings set "$schema" "$key" "$value" 2>/dev/null; then
        echo "linux-defaults: failed to set $schema $key=$value (type mismatch?), skipping" >&2
        return 0
    fi
}

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "linux-defaults: Linux only (current: $(uname -s)), skipping."
    exit 0
fi

if ! command -v gsettings >/dev/null 2>&1; then
    echo "linux-defaults: gsettings not found (GNOME only), skipping." >&2
    exit 0
fi

# Skip silently if running outside a GNOME session (e.g. KDE, headless, SSH)
if [[ -z "${XDG_CURRENT_DESKTOP:-}" ]] || [[ "${XDG_CURRENT_DESKTOP^^}" != *"GNOME"* ]]; then
    echo "linux-defaults: not a GNOME session (XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-unset}), skipping." >&2
    exit 0
fi

heading "→ Creating folders…"
mkdir -p "$HOME/Projects"
# XDG user-dir convention; GNOME Screenshot UI defaults to this path.
mkdir -p "$HOME/Pictures/Screenshots"

heading "→ Configuring input…"
# Natural scrolling (touchpad + mouse)
set_if_exists org.gnome.desktop.peripherals.touchpad natural-scroll true
set_if_exists org.gnome.desktop.peripherals.mouse natural-scroll true
# Key repeat (mirror macOS ApplePressAndHoldEnabled=false behavior)
set_if_exists org.gnome.desktop.peripherals.keyboard repeat true
set_if_exists org.gnome.desktop.peripherals.keyboard delay 'uint32 250'
set_if_exists org.gnome.desktop.peripherals.keyboard repeat-interval 'uint32 30'

heading "→ Configuring Files (Nautilus)…"
# List view default
set_if_exists org.gnome.nautilus.preferences default-folder-viewer "'list-view'"
# Show hidden files (GTK schema, applies to Nautilus + every GTK file picker)
set_if_exists org.gtk.Settings.FileChooser show-hidden true
# Sort folders before files
set_if_exists org.gtk.Settings.FileChooser sort-directories-first true
set_if_exists org.gtk.gtk4.Settings.FileChooser sort-directories-first true
# Search current folder only (mirror Finder SCcf)
set_if_exists org.gnome.nautilus.preferences recursive-search "'never'"

heading "→ Configuring desktop…"
# Click-to-minimize when clicking active app on dash (close to macOS Dock click)
set_if_exists org.gnome.shell.extensions.dash-to-dock click-action "'minimize'"
set_if_exists org.gnome.desktop.interface show-battery-percentage true
set_if_exists org.gnome.desktop.interface clock-show-seconds false
set_if_exists org.gnome.desktop.interface clock-show-weekday true
# Color scheme follows dark preference by default (Catppuccin Macchiato)
set_if_exists org.gnome.desktop.interface color-scheme "'prefer-dark'"
# Hot corner: GNOME exposes single boolean (top-left → Activities); minimal analog to macOS wvous-*-corner block
set_if_exists org.gnome.desktop.interface enable-hot-corners true

heading "→ Configuring power…"
# Don't auto-suspend on AC
set_if_exists org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "'nothing'"

heading "Linux (GNOME) defaults applied."
