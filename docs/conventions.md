# Conventions

Shared-behavior rules across every tool in this repo: theme, font, tab size, hidden files, telemetry, auto-update, git pager, and other invariants that must stay aligned when configs change. When adding a new tool, add rows for any behavior it shares with an existing tool.

## Editor settings

| Setting | VSCode | Zed | Micro | Ghostty | Bat | Delta | Yazi |
|---|---|---|---|---|---|---|---|
| Tab size | `editor.tabSize: 4` | `tab_size: 4` | `tabsize: 4` | — | `--tabs=4` | `tabs = 4` | `tab_size = 4` |
| Spaces (not tabs) | `editor.insertSpaces: true` | `hard_tabs: false` | `tabstospaces: true` | — | — | — | — |
| Final newline | `files.insertFinalNewline: true` | `ensure_final_newline_on_save: true` | `eofnewline: true` | — | — | — | — |
| Trim trailing WS | `files.trimTrailingWhitespace: true` | `remove_trailing_whitespace_on_save: true` | `rmtrailingws: true` | — | — | — | — |
| EOL | `files.eol: "\n"` | (default LF on macOS) | `fileformat: "unix"` | — | — | — | — |
| Word wrap | `editor.wordWrap: "off"` | `soft_wrap: "none"` | `wordwrap: false` | — | — | — | `wrap = "no"` |
| Scroll margin | `editor.cursorSurroundingLines: 3` | `vertical_scroll_margin: 3` | `scrollmargin: 3` | — | — | — | `scrolloff = 3` |
| Line height | `editor.lineHeight: 1.5` | `buffer_line_height: "comfortable"` (1.618) | — | — | — | — | — |
| Cursor | `cursorStyle: "line"`, width 2 | `cursor_shape: "bar"` (buffer + terminal) | — | `cursor-style = bar`, thickness 2 | — | — | — |
| Cursor blink | `cursorBlinking: "smooth"` | `cursor_blink: true`, terminal: `blinking: "on"` | — | `cursor-style-blink = true` | — | — | — |
| Font | JetBrains Mono 14pt + fallbacks (editor + terminal) | Same chain (buffer + terminal) | (terminal font) | Same chain | — | — | — |
| Ligatures | `editor.fontLigatures: true` | `buffer_font_features: null` (all on) | — | (default: on) | — | — | — |
| Theme (dark) | Catppuccin Macchiato | Catppuccin Macchiato | — | Catppuccin Macchiato | Catppuccin Macchiato | Catppuccin Macchiato | — |
| Theme (light) | Catppuccin Latte | Catppuccin Latte | — | Catppuccin Latte | Catppuccin Latte | — | — |
| Indent guides | `guides.indentation: true` | `indent_guides.enabled: true` | — | — | — | — | — |
| Bold = bright | — | — | — | `bold-color = bright` | — | — | — |
| Minimap | `minimap.enabled: false` | `minimap.show: "never"` | — | — | — | — | — |
| Rulers/Guides | `rulers: [120]` | `wrap_guides: [120]` | `colorcolumn: 120` | — | — | — | — |
| Sticky scroll | `stickyScroll.enabled: true` | `sticky_scroll.enabled: true` | — | — | — | — | — |
| Bracket colors | `bracketPairColorization.enabled: true` | `colorize_brackets: true` | `matchbrace: true` | — | — | — | — |
| Linked editing | `linkedEditing: true` | `linked_edits: true` | — | — | — | — | — |
| Whitespace | `renderWhitespace: "selection"` | `show_whitespaces: "selection"` | — | — | — | — | — |
| Line highlight | `renderLineHighlight: "all"` | `current_line_highlight: "all"` | `cursorline: true` | — | — | — | — |
| Semantic tokens | `semanticHighlighting.enabled: true` | `semantic_tokens: "combined"` | — | — | — | — | — |
| Hover delay | `editor.hover.delay: 200` | `hover_popover_delay: 200` | — | — | — | — | — |
| Option as Meta | `terminal.integrated.macOptionIsMeta: true` | `terminal.option_as_meta: true` | — | `macos-option-as-alt = true` | — | — | — |
| Git protocol | `github.gitProtocol: "ssh"` | — | — | — | — | — | — |
| Git pager | — | — | — | — | — | `pager = delta` | — |
| Git blame | `git.blame.editorDecoration.enabled` + `git.blame.statusBarItem.enabled` (author+date) | `inline_blame.enabled: true`, `show_commit_summary: false` | — | — | — | — | — |
| Show hidden | — | — | — | — | — | — | `show_hidden = true` |
| Follow symlinks | `search.followSymlinks: true` | — | — | — | — | — | — |
| Nerd fonts | Font fallback chain | Font fallback chain | — | Font fallback chain | — | — | — |
| Icons | `workbench.iconTheme` | `icon_theme` | — | — | — | — | (auto-detected) |
| Format on save | `editor.formatOnSave: true` | `format_on_save: "on"` | — | — | — | — | — |
| Auto save | `files.autoSave: "off"` | `autosave: "off"` | — | — | — | — | — |
| Detect indent | `editor.detectIndentation: true` | (default: true) | — | — | — | — | — |
| Auto indent on paste | `editor.autoIndentOnPaste: true` (+ `autoIndentOnPasteWithinString: true`) | `auto_indent_on_paste: true` | `smartpaste: true` | — | — | — | — |
| Inlay hints | `editor.inlayHints (enabled)` | `inlay_hints.enabled: true` | — | — | — | — | — |
| Close on file delete | `closeOnFileDelete: true` | `close_on_file_delete: true` | — | — | — | — | — |
| Auto-close brackets | `autoClosingBrackets: "languageDefined"` | `use_autoclose: true` | — | — | — | — | — |
| Completions on input | `editor.quickSuggestions: "on"` | `show_completions_on_input: true` | — | — | — | — | — |
| Syntax highlighting | — | — | `syntax: true` | — | — | — | — |
| Encoding | — | — | `encoding: "utf-8"` | — | — | — | — |
| Truecolor | — | — | `truecolor: "auto"` | — | — | — | — |
| Param hints | `parameterHints.enabled: true` | `auto_signature_help: true` | — | — | — | — | — |
| Completion docs | `editor.suggest.preview: true` | `show_completion_documentation: true` | — | — | — | — | — |
| Git gutter | (default: on) | `git.git_gutter: "tracked_files"` | `diffgutter: true` | — | `--style=changes` | — | — |
| Diff ignore WS | `diffEditor.ignoreTrimWhitespace: false` | — | — | — | — | (default: show) | — |
| Trim final NLs | `files.trimFinalNewlines: true` | (no equivalent — gap) | — | — | — | — | — |
| Auto indent | `editor.autoIndent: "full"` | (default: on) | `autoindent: true` | — | — | — | — |
| Format on paste | `editor.formatOnPaste: true` | — | `smartpaste: true` | — | — | — | — |
| Smart case search | — | `use_smartcase_search: true` | — | — | — | — | — |
| Dirs first | — | — | — | — | — | — | `sort_dir_first = true` |
| Inline diagnostics | ErrorLens extension | `diagnostics.inline.enabled: true` | — | — | — | — | — |
| Theme detection | `autoDetectColorScheme: true` | `theme.mode: "system"` | — | — | — | — | — |

## Telemetry

Minimize across all tools:

| Tool | Setting | Value |
|---|---|---|
| VSCode | `telemetry.telemetryLevel` | `"crash"` |
| VSCode | `redhat.telemetry.enabled` | `false` |
| Zed | `telemetry.diagnostics` / `metrics` | `true` / `false` |
| Claude Code | `feedbackSurveyRate` | `0` |
| Codex | `analytics.enabled` / `feedback.enabled` | `false` / `false` |

## File search/listing tools

Must stay in sync across: `fd` alias in `.zshrc`, `.config/ripgrep/ripgreprc`, yazi, eza aliases, Finder defaults, superfile

| Behavior | fd | rg | yazi | eza | Finder | superfile |
|---|---|---|---|---|---|---|
| Hidden files | `--hidden` | `--hidden` | `show_hidden = true` | `-a` (in `ll`/`lt`) | `AppleShowAllFiles` | runtime toggle only (no config key) |
| Follow symlinks | `--follow` | `--follow` | `show_symlink = true` | — | — | always shown (no config key) |
| Dirs first | — | — | `sort_dir_first = true` | `--group-directories-first` | `_FXSortFoldersFirst` | hardcoded behavior (no config key) |
| Case insensitive | — | `--smart-case` | `sort_sensitive = false` | — | — | `case_sensitive_sort = false` |
| Sort by name (alphabetical) | — | — | `sort_by = "alphabetical"` | — | — | `default_sort_type = 0` |
| Sort reverse | — | — | `sort_reverse = false` | — | — | `sort_order_reversed = false` |
| No extra columns | — | — | `linemode = "none"` | — | — | `file_panel_extra_columns = 0` |

## Italic text rendering

Must stay consistent:

- VSCode Catppuccin: `italicComments: true`, `italicKeywords: true`
- bat: `--italic-text=always`
- Delta inherits from bat theme engine (Catppuccin Macchiato italic support)

## Smooth scrolling

Enabled everywhere:

- VSCode: `editor.smoothScrolling`, `workbench.list.smoothScrolling`, `terminal.integrated.smoothScrolling` (all `true`)
- Zed: native smooth scrolling (macOS)
- Ghostty: native smooth scrolling (macOS)

## AI agent

Enabled in both editors:

- VSCode: `chat.agent.enabled: true`
- Zed: `agent.enabled: true`
- Zed: `agent_servers` configured with `codex-acp` and `claude-acp` registries

**Zed keybindings:** `base_keymap: "VSCode"` — Zed mirrors VSCode shortcuts for consistency

## Pager = delta

Across all git-aware tools:

| Tool | Config | Value |
|---|---|---|
| `.config/git/config` | `core.pager` | `delta` |
| `.config/git/config` | `interactive.diffFilter` | `delta --color-only` |
| gh CLI | `pager` | `delta` |
| lazygit | `git.pagers` | `delta --paging=never` (lazygit handles scroll) |

## Modified file indicators

In tabs:

- VSCode: `workbench.editor.highlightModifiedTabs: true`
- Zed: `tabs.git_status: true`
- Micro: `diffgutter: true`

## Line numbers in preview tools

Consistent with editors showing line numbers:

- bat: `--style="numbers,changes,header,grid"`
- Delta: `line-numbers = true`

## Window/system theme follows OS

- Ghostty: `window-theme = system` + `theme = light:Catppuccin Latte,dark:Catppuccin Macchiato`
- Zed: `theme.mode: "system"` (light: Catppuccin Latte, dark: Catppuccin Macchiato)
- VSCode: `window.autoDetectColorScheme: true` (light: Catppuccin Latte, dark: Catppuccin Macchiato)
- bat: `--theme-dark="Catppuccin Macchiato"` + `--theme-light="Catppuccin Latte"` (auto-detects via macOS appearance)
- glow: `style: "auto"` (auto-detects)
- Codex: `tui.theme = "catppuccin-macchiato"` (TUI only, no light/system mode)
- Superfile: `theme = "catppuccin-macchiato"` (TUI only, no light/system mode; built-in theme file at `~/.config/superfile/theme/catppuccin-macchiato.toml` on both OSes; spf honors `$XDG_CONFIG_HOME` exported by `.zprofile` via `adrg/xdg`)
- btop: `color_theme = "catppuccin_macchiato"` (TUI only, no light/system mode; btop ships no Catppuccin themes by default, so `catppuccin_{macchiato,latte,frappe,mocha}.theme` are vendored from `catppuccin/btop` into `~/.config/btop/themes/`)

## Inline diagnostics

Errors/warnings shown on affected lines:

- VSCode: `errorlens` extension (installed via Brewfile)
- Zed: `diagnostics.inline.enabled: true` (built-in, matches ErrorLens behavior)

## Shell linting/formatting

Extension + binary pairs (both must be present):

- `shellcheck` (brew) ↔ `timonwong.shellcheck` (VSCode extension); both in `Brewfile`. Extension auto-discovers binary from `PATH`.
- `shfmt` (brew) ↔ `foxundermoon.shell-format` (VSCode extension); both in `Brewfile`. Extension auto-discovers binary from `PATH`.
- Zed: built-in shell highlighting; no extension installed. `shellcheck`/`shfmt` invoked directly from `PATH` if a project formatter is configured.

## Extension management

Reproducible across machines:

- VSCode: `vscode` entries in `Brewfile` (managed by `brew bundle dump` / `brew bundle install`). Built-in extensions (e.g. `GitHub.copilot-chat` bundled since VSCode 1.99) are not enumerated by `code --list-extensions`, so they never appear in the Brewfile and must not be added by hand: `brew bundle dump` strips them on the next export.
- Zed: `auto_install_extensions` in `.config/zed/settings.json` (auto-installed on launch)

**Zed overrides from defaults:** `auto_signature_help: true` (Zed default is `false`, set to match VSCode `parameterHints.enabled`)

## Trim final newlines

Known gap:

- VSCode: `files.trimFinalNewlines: true` (trims extra blank lines at EOF)
- Zed: `ensure_final_newline_on_save: true` (adds one, does NOT trim extras)
- Micro: `eofnewline: true` (adds one, does not trim extras)

## Hidden files at shell level

Supplements the file-search table above with case-insensitive matching:

- zsh: `setopt globdots` (glob matches dotfiles — consistent with fd/rg `--hidden`)
- zsh completions: `matcher-list 'm:{a-zA-Z}={A-Za-z}'` (supplements smart-case in rg/Zed/yazi)

## Nerd Font icons

`Symbols Nerd Font Mono` in font fallback chain enables icons across:

- starship: nerd-font-symbols preset (`.config/starship.toml`)
- eza: `--icons=auto` in aliases
- lazygit: `nerdFontsVersion: "3"`
- yazi: auto-detected
- superfile: `nerdfont = true` + `show_select_icons = true` (explicit)
- VSCode/Zed: via font fallback chain
- Ghostty: via font fallback chain (`Symbols Nerd Font Mono`)

## Shell integration

- Ghostty: `shell-integration = zsh`
- `.zshrc`: sources fzf (`fzf --zsh`), fnm, uv, zoxide, starship

## Clipboard whitespace

- Ghostty: `clipboard-trim-trailing-spaces = true` (trim on copy)
- Editors: trim trailing whitespace on save (VSCode, Zed, Micro)

## Update channel and auto-update

Stable everywhere, auto-update enabled:

| Tool | Auto-update | Channel | Setting |
|---|---|---|---|
| Claude Code | manual (Brew owns) | — | `autoUpdatesChannel: "stable"` set but `brew upgrade --cask claude-code` is authoritative |
| Codex | manual (Brew owns) | — | No internal flag; `brew upgrade --cask codex` (or `codex update`) |
| Ghostty | download | `stable` | `auto-update = download`, `auto-update-channel = stable` |
| VSCode | `"default"` (enabled) | stable | `update.mode: "default"` |
| VSCode extensions | enabled | — | `extensions.autoUpdate: true`, `extensions.autoCheckUpdates: true` |
| Zed | enabled | stable | `auto_update: true` |
| Zed extensions | auto-install on launch | — | `auto_install_extensions` |
| Go tools (VSCode) | enabled | — | `go.toolsManagement.autoUpdate: true` |
| atuin | disabled (Brew owns) | — | `update_check = false` |
| superfile | disabled (Brew owns) | — | `auto_check_update = false` |
| lazygit | disabled (Brew owns) | — | `update.method: never` |
| tlrc cache | enabled | — | `[cache].auto_update = true` |
| Homebrew | manual (`make brew-install`) | — | No auto-update |

**Codex ↔ Claude shared docs:** Codex `project_doc_fallback_filenames = ["CLAUDE.md"]` — both agents read same `CLAUDE.md` files

## Exclusion lists

Must stay in sync across: `.config/ripgrep/ripgreprc`, `fd` alias in `.zshrc`, VSCode `search.exclude`, Zed `file_scan_exclusions`, `.config/git/ignore`. Core set: `.git`, `node_modules`, `.venv`, `venv`, `__pycache__`, `.pytest_cache`, `.terraform`, `vendor`, `dist`, `build`, `coverage`

## Git settings

Must stay consistent across: `.config/git/config` (authoritative), VSCode, Zed, `gh` CLI, lazygit

| Setting | `.config/git/config` | VSCode | gh CLI | lazygit | Zed |
|---|---|---|---|---|---|
| Protocol | `url.insteadOf` (SSH) | `gitProtocol: "ssh"` | `git_protocol: ssh` | (uses git) | (uses git) |
| Auto fetch | — | `autofetch: true` (300s) | — | `autoFetch: true` (default 60s) | no setting (gap) |
| Prune on fetch | `fetch.prune = true` | `pruneOnFetch: true` | — | — | (uses git) |
| Rebase on pull | `pull.rebase = true` | `rebaseWhenSync: true` | — | — | (uses git) |
| Autostash | `rebase.autostash = true` | `autoStash: true` | — | — | (uses git) |
| Branch protection | — | `branchProtection: [main, master]` | — | `disableForcePushing: true` | no setting (gap) |
| Inline blame | — | `blame.editorDecoration.enabled` + `blame.statusBarItem.enabled` | — | — | `inline_blame.enabled: true` |
| Blame format | — | `${authorName} (${authorDateAgo})` | — | — | `show_commit_summary: false` |
| Editor | `core.editor = code --wait` | — | — | `editPreset: vscode` | — |
| Nerd fonts | — | — | — | `nerdFontsVersion: "3"` | — |

Zed delegates git workflow (rebase, autostash, prune, SSH) to `.config/git/config` — consistent by inheritance. Two known gaps: no auto-fetch, no branch protection.

`.config/git/config` authoritative settings: `init.defaultBranch = main`, `merge.conflictstyle = zdiff3`, `rerere.enabled = true`, `rerere.autoupdate = true`, `push.autoSetupRemote = true`, `diff.algorithm = histogram`, `diff.colorMoved = default`, `diff.renames = true`, `diff.mnemonicPrefix = true`, `log.date = relative`, `branch.sort = -committerdate`. Delta config: `dark = true`, `line-numbers = true`, `side-by-side = true`, `hyperlinks = true`, `navigate = true`. `[filter "lfs"]` block pre-configured for git-lfs — no need to run `git lfs install`.

**VSCode `git.blame.*` is split** into `git.blame.editorDecoration.enabled` (inline editor decoration) and `git.blame.statusBarItem.enabled` (status bar item), each with its own `template`. Do not use the legacy flat `git.blame.enabled` key — it is silently ignored.

`.config/git/config` section order: Identity (`user`, `url`) → Core (`core`, `init`, `interactive`) → Pager (`delta`) → Display (`diff`, `merge`, `log`, `branch`) → Workflow (`fetch`, `pull`, `rebase`, `push`, `rerere`) → Filters (`filter "lfs"`) → Aliases (`alias`, last). Add new sections under the matching group.

## VISUAL / EDITOR env vars

Must match across: `.zprofile` (`VISUAL="code --wait --reuse-window"`, `EDITOR="$VISUAL"`), `.config/git/config` (`core.editor`), `.config/gh/config.yml` (`editor: code --wait`), `.config/yazi/yazi.toml` (`[opener.edit]` runs `code --wait "$@"`), lazygit (`editPreset: vscode`), Codex (`file_opener = "vscode"`), Superfile (`editor`/`dir_editor = "code --wait"`).

`VISUAL` is set first because modern consumers (`sudoedit`, `crontab -e`, `less +v`, `man -e`) check `VISUAL` before `EDITOR`. `EDITOR` is the historical fallback for line editors. Setting both to the same value covers every consumer. `--reuse-window` lives only on the env-var path; per-tool configs keep plain `code --wait`. If window-explosion ever becomes annoying in `git commit` / `gh pr edit` / yazi / superfile, propagate `--reuse-window` there too, but be aware the editor tab will attach to whatever VSCode window is currently focused, which can misroute commit messages between projects.

**Claude ↔ Codex** allowed commands must stay in sync between `.config/claude/settings.json` and `.config/codex/rules/`

## Marketplace identifiers

Intentionally divergent between Claude and Codex when both tools register the same upstream repo, because Codex CLI does not support renaming a marketplace key after `codex plugin marketplace add` (the key is fixed by the add command). Current state for the shared `caveman` repo (https://github.com/JuliusBrussee/caveman):

- `.config/claude/settings.json` → `extraKnownMarketplaces.caveman`
- `.config/codex/config.toml` → `[marketplaces.caveman-repo]` + `[plugins."caveman@caveman-repo"]`

Do not attempt to rename the Codex side to `caveman` — Codex will treat it as a new, unregistered marketplace and the plugin enable line will dangle.

**Built-in Codex marketplaces:** `openai-curated` is pre-registered by the Codex CLI binary — do not declare `[marketplaces.openai-curated]` in `.config/codex/config.toml`. Plugin references like `[plugins."slack@openai-curated"]` resolve through the built-in registry. Only third-party marketplaces (e.g. `caveman-repo`) need explicit `[marketplaces.<name>]` blocks.

**Third-party marketplace state fields:** Codex CLI writes `last_updated` and `last_revision` into the `[marketplaces.<name>]` block on every `codex plugin marketplace update`. They are intentionally **not** committed in `.config/codex/config.toml` because each refresh produces a noisy diff. Only `source_type` and `source` are tracked; the timestamp + revision fields repopulate locally after the first update.

**Per-machine team marketplaces:** `scripts/local-overrides.py` injects extra `extraKnownMarketplaces.<key>` entries (Claude) and `[projects."<path>"]` trust blocks (Codex) from `.local/source.toml`. Tracked configs ship with only the shared `caveman` market; team-specific entries land in the working tree on each `make local-overrides` run. See README "Local overrides".

## Brewfile maintenance

- `Brewfile` is **the dump target**: `make brew-export` overwrites it via `brew bundle dump --force`, then strips any line that also appears in `Brewfile.work`. Net effect: base stays curated, work entries stay separate. **macOS only**: the target self-skips on Linux because Linuxbrew install state covers only the Linux-installable cask subset (see `casks.md`), so a Linux dump would wipe the macOS-only cask entries from `Brewfile` (work casks live in `Brewfile.work`, which `brew bundle dump --file=Brewfile` never touches).
- `Brewfile.work` is **manually curated**: `brew bundle dump` does not respect file boundaries, so new work entries must be added by hand to `Brewfile.work` after install. Otherwise the next `make brew-export` will leak them into base.
- `Brewfile.work` lines must use the same format `brew bundle dump` emits (`cask "name"`, `brew "name"`, etc.). The strip step prefilters `Brewfile.work` through `grep -E '^(brew|cask|tap|vscode|mas|go|uv|npm) "'` before whole-line fixed-string match, so blank lines and comments in `Brewfile.work` are tolerated, but malformed entries (wrong prefix, trailing whitespace) still leak through.
- Do not re-sort either Brewfile by hand — `brew bundle dump` owns ordering.

## Linux GUI apps

Vendor `.deb` / `.rpm` packages install separately from the Brewfile. Per-app install commands live in [`linux-packages.md`](linux-packages.md). Flatpak is intentionally not used: vendor packages respect `~/.config/<tool>/`, integrate with `apt` / `dnf` for updates, and avoid the `XDG_CONFIG_HOME` remap that would break the repo's symlinks. Casks without a Linux build (`horos`, `orbstack`, macOS-system tools) are listed in `linux-packages.md` under "Casks with no Linux build".

**Tailscale name divergence:** the macOS cask is `tailscale-app` (the GUI bundle). On Linux the upstream installer ships `tailscale` (CLI + `tailscaled` daemon only; no GUI tray, see `linux-packages.md`). The two are intentionally different packages; do not rename the cask to match the Linux package or vice versa.
