# Conventions

Shared-behavior rules across every tool in this repo: theme, font, tab size, hidden files, telemetry, auto-update, git pager, and other invariants that must stay aligned when configs change. When adding a new tool, add rows for any behavior it shares with an existing tool.

Nested JSON / TOML keys are written in dotted-path shorthand (e.g. `tabs.git_status: true` for `"tabs": { "git_status": true }`). Cross-reference cells against the live config by walking the path.

## Editor settings

| Setting | VSCodium | Zed | Micro | Ghostty | Bat | Delta | Yazi |
|---|---|---|---|---|---|---|---|
| Tab size | `editor.tabSize: 4` | `tab_size: 4` | `tabsize: 4` | — | `--tabs=4` | `tabs = 4` | `tab_size = 4` |
| Spaces (not tabs) | `editor.insertSpaces: true` | `hard_tabs: false` | `tabstospaces: true` | — | — | — | — |
| Final newline | `files.insertFinalNewline: true` | `ensure_final_newline_on_save: true` | `eofnewline: true` | — | — | — | — |
| Trim trailing WS | `files.trimTrailingWhitespace: true` | `remove_trailing_whitespace_on_save: true` | `rmtrailingws: true` | — | — | — | — |
| EOL | `files.eol: "\n"` | (default LF on macOS) | `fileformat: "unix"` | — | — | — | — |
| Word wrap | `editor.wordWrap: "off"` | `soft_wrap: "none"` | `wordwrap: false` | — | — | — | `wrap = "no"` |
| Scroll margin | `editor.cursorSurroundingLines: 3` | `vertical_scroll_margin: 3` | `scrollmargin: 3` | — | — | — | `scrolloff = 3` |
| Line height | `editor.lineHeight: 1.5` | `buffer_line_height: "comfortable"` (1.618) | — | — | — | — | — |
| Cursor | `cursorStyle: "line"`, width 2 | `cursor_shape: "bar"` (buffer + terminal) | — | `cursor-style = bar`, `adjust-cursor-thickness = 2` | — | — | — |
| Cursor blink | `cursorBlinking: "smooth"` | `cursor_blink: true`, terminal: `blinking: "on"` | — | `cursor-style-blink = true` | — | — | — |
| Hide mouse on type | — | `hide_mouse: "on_typing_and_action"` | — | `mouse-hide-while-typing = true` | — | — | — |
| Font | JetBrains Mono 14pt + fallbacks (editor + terminal) | Same chain (buffer + terminal) | (terminal font) | Same chain | — | — | — |
| Ligatures | `editor.fontLigatures: true` | `buffer_font_features: null` (all on) | — | (default: on) | — | — | — |
| Theme (dark) | Catppuccin Macchiato | Catppuccin Macchiato | — | Catppuccin Macchiato | Catppuccin Macchiato | Catppuccin Macchiato | — |
| Theme (light) | Catppuccin Latte | Catppuccin Latte | — | Catppuccin Latte | Catppuccin Latte | — | — |
| Indent guides | `editor.guides.indentation: true` | `indent_guides.enabled: true` | — | — | — | — | — |
| Bold = bright | — | — | — | `bold-color = bright` | — | — | — |
| Minimap | `minimap.enabled: false` | `minimap.show: "never"` | — | — | — | — | — |
| Rulers/Guides | `rulers: [120]` | `wrap_guides: [120]` | `colorcolumn: 120` | — | — | — | — |
| Sticky scroll | `stickyScroll.enabled: true` | `sticky_scroll.enabled: true` | — | — | — | — | — |
| Bracket colors | `editor.bracketPairColorization.enabled: true` | `colorize_brackets: true` | `matchbrace: true` | — | — | — | — |
| Linked editing | `editor.linkedEditing: true` | `linked_edits: true` | — | — | — | — | — |
| Whitespace | `renderWhitespace: "selection"` | `show_whitespaces: "selection"` | — | — | — | — | — |
| Line highlight | `renderLineHighlight: "all"` | `current_line_highlight: "all"` | `cursorline: true` | — | — | — | — |
| Semantic tokens | `semanticHighlighting.enabled: true` | `semantic_tokens: "combined"` | — | — | — | — | — |
| Hover delay | `editor.hover.delay: 200` | `hover_popover_delay: 200` | — | — | — | — | — |
| Option as Meta | `terminal.integrated.macOptionIsMeta: true` | `terminal.option_as_meta: true` | — | `macos-option-as-alt = true` | — | — | — |
| Git protocol | `github.gitProtocol: "ssh"` | — | — | — | — | — | — |
| Git blame | `git.blame.editorDecoration.enabled` + `git.blame.statusBarItem.enabled` (author+date) | `inline_blame.enabled: true`, `show_commit_summary: false` | — | — | — | — | — |
| Show hidden | — | — | — | — | — | — | `show_hidden = true` |
| Follow symlinks | `search.followSymlinks: true` | — | — | — | — | — | — |
| Nerd fonts | Font fallback chain | Font fallback chain | — | Font fallback chain | — | — | — |
| Icons | `workbench.iconTheme` | `icon_theme` | — | — | — | — | (built-in) |
| Format on save | `editor.formatOnSave: true` | `format_on_save: "on"` | — | — | — | — | — |
| Code actions on save | `editor.codeActionsOnSave: { organizeImports, fixAll, addMissingImports = "explicit" }` | `code_actions_on_format: { organizeImports, fixAll, addMissingImports = true }` | — | — | — | — | — |
| Auto save | `files.autoSave: "off"` | `autosave: "off"` | — | — | — | — | — |
| Detect indent | `editor.detectIndentation: true` | — | — | — | — | — | — |
| Auto indent on paste | `editor.autoIndentOnPaste: true` (+ `autoIndentOnPasteWithinString: true`) | `auto_indent_on_paste: true` | `smartpaste: true` | — | — | — | — |
| Inlay hints | `editor.inlayHints (enabled)` | `inlay_hints.enabled: true` | — | — | — | — | — |
| Close on file delete | `closeOnFileDelete: true` | `close_on_file_delete: true` | — | — | — | — | — |
| Auto-close brackets | `editor.autoClosingBrackets: "languageDefined"` | `use_autoclose: true` | — | — | — | — | — |
| Completions on input | `editor.quickSuggestions: { other, comments, strings: "on" }` | `show_completions_on_input: true` | — | — | — | — | — |
| Syntax highlighting | — | — | `syntax: true` | — | — | — | — |
| Encoding | — | — | `encoding: "utf-8"` | — | — | — | — |
| Param hints | `parameterHints.enabled: true` | `auto_signature_help: true` | — | — | — | — | — |
| Completion docs | `editor.suggest.preview: true` | `show_completion_documentation: true` | — | — | — | — | — |
| Git gutter | (default: on) | `git.git_gutter: "tracked_files"` | `diffgutter: true` | — | `--style=changes` | — | — |
| Diff ignore WS | `diffEditor.ignoreTrimWhitespace: false` | — | — | — | — | (default: show) | — |
| Trim final NLs | `files.trimFinalNewlines: true` | (no equivalent — gap) | — | — | — | — | — |
| Auto indent | `editor.autoIndent: "full"` | — | `autoindent: true` | — | — | — | — |
| Format on paste | `editor.formatOnPaste: true` | — | `smartpaste: true` | — | — | — | — |
| Smart case search | — | `use_smartcase_search: true` | — | — | — | — | — |
| Dirs first | — | — | — | — | — | — | `sort_dir_first = true` |
| Inline diagnostics | ErrorLens extension | `diagnostics.inline.enabled: true` | — | — | — | — | — |
| Theme detection | `window.autoDetectColorScheme: true` | `theme.mode: "system"` | — | — | — | — | — |

## Telemetry

Minimize across all tools:

| Tool | Setting | Value |
|---|---|---|
| VSCodium | `telemetry.telemetryLevel` | `"crash"` |
| VSCodium | `redhat.telemetry.enabled` | `false` |
| Zed | `telemetry.diagnostics` / `metrics` | `true` / `false` |
| Claude Code | `feedbackSurveyRate` | `0` |
| Codex | `analytics.enabled` / `feedback.enabled` | `false` / `false` |
| gh | `telemetry` | `disabled` |

Codex `[history].persistence = "save-all"` is local-only conversation retention (replay / context recovery), distinct from the analytics opt-out above. No upstream egress.

## File search/listing tools

Must stay in sync across: `fd` alias in `.zshrc`, `.config/ripgrep/ripgreprc`, yazi, eza aliases, Finder defaults (macOS), Nautilus defaults (Linux/GNOME), superfile

| Behavior | fd | rg | yazi | eza | Finder | Nautilus | superfile |
|---|---|---|---|---|---|---|---|
| Hidden files | `--hidden` | `--hidden` | `show_hidden = true` | `-a` (in `ll`/`lt`) | `AppleShowAllFiles` | `org.gtk.Settings.FileChooser show-hidden` (GTK schema, applies to Nautilus + every GTK file picker; replaces deprecated `org.gnome.nautilus.preferences show-hidden-files`) | runtime toggle only (no config key) |
| Follow symlinks | `--follow` | `--follow` | `show_symlink = true` | — | — | — | always shown (no config key) |
| Dirs first | — | — | `sort_dir_first = true` | `--group-directories-first` | `_FXSortFoldersFirst` | `org.gtk.Settings.FileChooser sort-directories-first` + `org.gtk.gtk4.Settings.FileChooser sort-directories-first` | hardcoded behavior (no config key) |
| Case insensitive | — | `--smart-case` | `sort_sensitive = false` | — | — | — | `case_sensitive_sort = false` |
| Sort by name (alphabetical) | — | — | `sort_by = "alphabetical"` | — | — | — | `default_sort_type = 0` |
| Sort reverse | — | — | `sort_reverse = false` | — | — | — | `sort_order_reversed = false` |
| No extra columns | — | — | `linemode = "none"` | — | — | — | `file_panel_extra_columns = 0` |
| Search current folder only | — | — | — | — | `FXDefaultSearchScope = "SCcf"` | `org.gnome.nautilus.preferences recursive-search = 'never'` | — |
| Default view | — | — | — | — | `FXPreferredViewStyle = "Nlsv"` (list) | `org.gnome.nautilus.preferences default-folder-viewer = 'list-view'` | — |

## Italic text rendering

Must stay consistent:

- VSCodium Catppuccin: `italicComments: true`, `italicKeywords: true`
- bat: `--italic-text=always`
- Delta inherits from bat theme engine (Catppuccin Macchiato italic support)

## Smooth scrolling

Enabled everywhere:

- VSCodium: `editor.smoothScrolling`, `workbench.list.smoothScrolling`, `terminal.integrated.smoothScrolling` (all `true`)
- Zed: native smooth scrolling
- Ghostty: native smooth scrolling

## AI agent

Enabled in both editors:

- VSCodium: `chat.agent.enabled: true`
- Zed: `agent.enabled: true`
- Zed: external agents (Claude, Codex) install via the ACP Registry (`zed: acp registry` or Agent Settings); `agent_servers` is not required for registry agents and only configures custom non-registry agents or per-agent overrides under `agent_servers.<agent-id>`

**Zed keybindings:** `base_keymap: "VSCode"` (literal Zed enum value, same Code OSS keymap as VSCodium) — Zed mirrors VSCodium shortcuts for consistency

## Pager = delta

Across all git-aware tools:

| Tool | Config | Value |
|---|---|---|
| `.config/git/config` | `core.pager` | `delta` |
| `.config/git/config` | `interactive.diffFilter` | `delta --color-only` |
| gh CLI | `pager` | `delta` |
| lazygit | `git.pagers` | `pager: delta --paging=never` + `colorArg: always` (lazygit handles scroll; `colorArg` keeps delta input colored) |

## Modified file indicators

In tabs:

- VSCodium: `workbench.editor.highlightModifiedTabs: true`
- Zed: `tabs.git_status: true`
- Micro: `diffgutter: true`

## Line numbers in preview tools

Consistent with editors showing line numbers:

- bat: `--style="numbers,changes,header,grid"`
- Delta: `line-numbers = true`
- glow: `showLineNumbers: true` (TUI only; pager mode unaffected)

## Window/system theme follows OS

- Ghostty: `window-theme = system` + `theme = light:Catppuccin Latte,dark:Catppuccin Macchiato`
- Zed: `theme.mode: "system"` (light: Catppuccin Latte, dark: Catppuccin Macchiato)
- VSCodium: `window.autoDetectColorScheme: true` + `workbench.preferredLightColorTheme: "Catppuccin Latte"` + `workbench.preferredDarkColorTheme: "Catppuccin Macchiato"`
- bat: `--theme-dark="Catppuccin Macchiato"` + `--theme-light="Catppuccin Latte"` (auto-detects via macOS appearance)
- glow: `style: "auto"` (auto-detects)
- Codex: `tui.theme = "catppuccin-macchiato"` (TUI only, no light/system mode)
- Superfile: `theme = "catppuccin-macchiato"` (TUI only, no light/system mode; built-in theme file at `~/.config/superfile/theme/catppuccin-macchiato.toml` on both OSes; spf honors `$XDG_CONFIG_HOME` exported by `.zprofile` via `adrg/xdg`)
- btop: `color_theme = "catppuccin_macchiato"` (TUI only, no light/system mode; btop ships no Catppuccin themes by default, so `catppuccin_{macchiato,latte,frappe,mocha}.theme` are vendored from `catppuccin/btop` into `~/.config/btop/themes/`)

## Inline diagnostics

Errors/warnings shown on affected lines:

- VSCodium: `errorlens` extension (installed via Brewfile)
- Zed: `diagnostics.inline.enabled: true` (built-in, matches ErrorLens behavior)
- Both cap at `warning`: VSCodium `errorLens.enabledDiagnosticLevels: ["error", "warning"]`, Zed `diagnostics.inline.max_severity: "warning"`

## Shell linting/formatting

Single extension wraps both linter and formatter:

- `shellcheck` (brew) + `shfmt` (brew) ↔ `mads-hartmann.bash-ide-vscode` (VSCodium extension); all three in `Brewfile`. The extension's bundled `bash-language-server` (shipped in the VSIX) auto-discovers `shellcheck` and `shfmt` from `PATH`. Flags pinned in `.config/vscodium/settings.json`: `bashIde.shfmt.caseIndent: true` + `bashIde.shfmt.keepPadding: true` match `make validate`'s `shfmt -ci -kp`; `bashIde.shfmt.simplifyCode: false` prevents shfmt's `-s` from rewriting valid scripts; `bashIde.enableSourceErrorDiagnostics: true` surfaces bash parse errors as diagnostics. `keepPadding` is upstream-deprecated but still the only knob exposing the `-kp` flag.
- Zed: bundled `bash-language-server` via native shell support; same `shellcheck`/`shfmt` binaries from `PATH`. `simplifyCode: false` + `enableSourceErrorDiagnostics: true` mirrored via `lsp.bash-language-server.settings.bashIde.{shfmt.simplifyCode, enableSourceErrorDiagnostics}`. `caseIndent` and `keepPadding` are not exposed by Zed's bashls integration — see the indent gap below.
- **Indent gap (known):** `make validate` runs `shfmt -d -i 4 -ci -kp` (4-space indent) on `scripts/*.sh`, but bash-language-server exposes no `bashIde.shfmt.indent` knob, so save-on-format from VSCodium and Zed uses shfmt's default tab indent. Scripts in this repo are 4-space; saving from either editor without a manual `shfmt -w -i 4 -ci -kp` pass before commit will break `make validate`. Add `.editorconfig` with `[*.sh] indent_size = 4` to close the gap (bash-language-server reads `.editorconfig` and forwards `-i 4` to shfmt).

## Go tooling

gopls settings pinned identically on both editors so Go files format and surface the same UI regardless of which editor saves:

| Setting | VSCodium | Zed |
|---|---|---|
| gofumpt | `gopls.formatting.gofumpt: true` | `lsp.gopls.initialization_options.gofumpt: true` |
| Semantic tokens | `gopls.ui.semanticTokens: true` | `lsp.gopls.initialization_options.semanticTokens: true` |
| Completion placeholders | `gopls.ui.completion.usePlaceholders: true` | `lsp.gopls.initialization_options.usePlaceholders: true` |
| Staticcheck lints | `gopls.ui.diagnostic.staticcheck: true` | `lsp.gopls.initialization_options.staticcheck: true` |
| Extra analyses | `gopls.ui.diagnostic.analyses: {unusedparams, unusedvariable, unusedwrite, any, nilness, unreachable, shadow: true}` | `lsp.gopls.initialization_options.analyses: {…same set}` |
| Codelenses | `gopls.codelenses: {generate, tidy, upgrade_dependency, vendor, test}` | `lsp.gopls.initialization_options.codelenses: {…same set}` |
| Inlay hints | `go.inlayHints.{assignVariableTypes, constantValues, rangeVariableTypes: true}` (vscode-go) | `lsp.gopls.initialization_options.hints: {…same flags}` |

vscode-go extension namespaces gopls settings under `formatting.*` / `ui.*` / `go.inlayHints.*`; Zed has no go extension translation layer, so settings pass straight through to gopls using canonical top-level keys.

## Python tooling

basedpyright (type LSP) + ruff (lint/format) pinned identically on both editors:

| Setting | VSCodium | Zed |
|---|---|---|
| Type-check mode | `basedpyright.analysis.typeCheckingMode: "standard"` | `lsp.basedpyright.settings.basedpyright.analysis.typeCheckingMode: "standard"` |
| Diagnostic scope | `basedpyright.analysis.diagnosticMode: "openFilesOnly"` | `lsp.basedpyright.settings.basedpyright.analysis.diagnosticMode: "openFilesOnly"` |
| Auto-import suggestions | `basedpyright.analysis.autoImportCompletions: true` | `lsp.basedpyright.settings.basedpyright.analysis.autoImportCompletions: true` |
| Library code → types | `basedpyright.analysis.useLibraryCodeForTypes: true` | `lsp.basedpyright.settings.basedpyright.analysis.useLibraryCodeForTypes: true` |
| Inlay hints | `basedpyright.analysis.inlayHints.{callArgumentNames, variableTypes, functionReturnTypes, genericTypes: true}` | `lsp.basedpyright.settings.basedpyright.analysis.inlayHints: {…same}` |
| Ruff as Python formatter | `[python] editor.defaultFormatter: "charliermarsh.ruff"` (global `formatOnSave: true` + `codeActionsOnSave: {organizeImports, fixAll: "explicit"}` already cover format + ruff-aliased actions) | `formatter: "auto"` + `code_actions_on_format` (Zed auto-routes Python to bundled ruff LSP) |
| Ruff config source priority | `ruff.configurationPreference: "filesystemFirst"` | `lsp.ruff.settings.configurationPreference: "filesystemFirst"` |
| Pylance silenced | `python.languageServer: "None"` (prevents ms-python from re-enabling Jedi/Pylance) | n/a (Zed has no competing Python LSP) |

## TypeScript tooling

VSCodium runs bundled `tsserver` (VSCode core); Zed runs bundled `vtsls` (different LSP wrapping tsserver). Both pinned to the same behaviors:

| Setting | VSCodium (`js/ts.*`) | Zed (`lsp.vtsls.settings.{typescript,javascript}.*`) |
|---|---|---|
| Update imports on file move | `updateImportsOnFileMove.enabled: "always"` | `updateImportsOnFileMove: { enabled: "always" }` |
| Auto-imports | `suggest.autoImports: true` | `suggest: { autoImports: true }` |
| Complete function calls | `suggest.completeFunctionCalls: true` | `suggest: { completeFunctionCalls: true }` |
| Inlay hints (parameter names, literals) | `inlayHints.parameterNames.enabled: "literals"` | `inlayHints: { parameterNames: { enabled: "literals" } }` |
| Inlay hints (function-like return types) | `inlayHints.functionLikeReturnTypes.enabled: true` | `inlayHints: { functionLikeReturnTypes: { enabled: true } }` |
| Inlay hints (variable types) | `inlayHints.variableTypes.enabled: true` | `inlayHints: { variableTypes: { enabled: true } }` |
| Inlay hints (property declaration types) | `inlayHints.propertyDeclarationTypes.enabled: true` | `inlayHints: { propertyDeclarationTypes: { enabled: true } }` |
| Inlay hints (enum member values) | `inlayHints.enumMemberValues.enabled: true` | `inlayHints: { enumMemberValues: { enabled: true } }` |
| Type-only auto-imports (TS 5.0+) | `js/ts.preferences.preferTypeOnlyAutoImports: true` (unified namespace; supersedes the `typescript.*` + `javascript.*` variants, retained as aliases) | `preferences: { preferTypeOnlyAutoImports: true }` (vtsls schema keeps typescript + javascript split — pass through tsserver protocol) |
| tsserver memory ceiling | `js/ts.tsserver.maxMemory: 8192` (renamed from `typescript.tsserver.maxTsServerMemory`, retained as an alias) | `typescript.tsserver: { maxTsServerMemory: 8192 }` (vtsls passes the legacy tsserver-protocol key through; vtsls did not unify the namespace) |

vtsls accepts the same dotted-namespace as tsserver under its `settings`; the JS and TS sub-objects mirror each other so `.js` and `.ts` files behave identically. `maxTsServerMemory` raised from the 3072 MB default insures against monorepo TypeScript OOM.

## Extension management

Reproducible across machines:

- VSCodium: `vscode` entries in `Brewfile` (managed by `brew bundle dump` / `brew bundle install`). Auto-installed VSCodium extensions (e.g. `ms-vscode.js-debug`, via `product.json` `builtInExtensions`) are not enumerated by `codium --list-extensions`, so they never appear in the Brewfile and must not be added by hand: `brew bundle dump` strips them on the next export.
- Zed: `auto_install_extensions` in `.config/zed/settings.json` (auto-installed on launch)

**Zed overrides from defaults:** `auto_signature_help: true` (Zed default is `false`, set to match VSCodium `parameterHints.enabled`); `close_on_file_delete: true` (Zed default is `false`, set to match VSCodium `closeOnFileDelete`).

**Per-extension parity:** Zed's `auto_install_extensions` is intentionally narrower than VSCodium's `vscode "..."` list. Zed bundles language servers (gopls, basedpyright, tsserver) and ships ruff/prettier-style formatting via `formatter: "auto"`, so most VSCodium language/lint/format extensions have no Zed counterpart by design.

**TOML LSP:** `tombi-toml.tombi` (Brewfile) on VSCodium ↔ `tombi` in `auto_install_extensions` on Zed. Same upstream LSP both sides; chosen over `tamasfe.even-better-toml` (taplo upstream stalled).

**Prettier formatter parity:** Both editors run Prettier for the same language set so save-on-format is byte-identical across editors. VSCodium pins `esbenp.prettier-vscode` as `[lang] editor.defaultFormatter` for JS/JSX/TS/TSX/JSON/JSONC/JSON5/YAML/Markdown/MDX/HTML/CSS/SCSS/Less. Zed pins `languages.<Lang>.formatter = "prettier"` for the same set; JSONC/JSON5/YAML/Markdown/MDX already use bundled Prettier by Zed default and need no explicit pin. `.prettierrc` in a project is honored on both sides.

**ESLint:** both editors auto-activate ESLint when the project ships `node_modules/eslint`. VSCodium via `dbaeumer.vscode-eslint` extension; Zed via the bundled `eslint` LSP exposed under `lsp.eslint.settings`. No global enable needed; activation is per-project on both sides.

**Protobuf parity gap:** VSCodium runs `bufbuild.vscode-buf` for buf-backed lint, format, and breaking-change checks on `.proto` files. Zed has no equivalent extension (no `buf` entry in `zed-industries/extensions`); the `proto` extension covers tree-sitter syntax highlighting only. Fallback on Zed: run `buf lint`, `buf format`, `buf breaking` via CLI (`brew "buf"`).

**Occurrence-highlight parity gap:** VSCodium pins `editor.occurrencesHighlight: "multiFile"` (highlight a symbol's occurrences across files; VSCode default is `"singleFile"`). Zed has no multi-file occurrence-highlight setting; `selection_highlight` (default on) highlights the current selection within the active buffer only. Divergence is inherent to the editors, not config drift.

## Trim final newlines

Known gap:

- VSCodium: `files.trimFinalNewlines: true` (trims extra blank lines at EOF)
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
- VSCodium/Zed: via font fallback chain
- Ghostty: via font fallback chain (`Symbols Nerd Font Mono`)

## Shell integration

- Ghostty: `shell-integration = zsh`
- `.zshrc`: sources fzf (`fzf --zsh`), fnm, uv, zoxide, starship, atuin (after fzf, owns `Ctrl+R` and Up arrow)

## Clipboard whitespace

- Ghostty: `clipboard-trim-trailing-spaces = true` (trim on copy)
- Editors: trim trailing whitespace on save (VSCodium, Zed, Micro)

## Update channel and auto-update

Stable everywhere, auto-update enabled:

| Tool | Auto-update | Channel | Setting |
|---|---|---|---|
| Claude Code | manual (Brew owns) | — | `autoUpdatesChannel: "stable"` set but `brew upgrade --cask claude-code` is authoritative |
| Codex | manual (Brew owns) | — | No internal flag; `brew upgrade --cask codex` (or `codex update`) |
| Ghostty | download | `stable` | `auto-update = download`, `auto-update-channel = stable` |
| VSCodium | `"default"` (enabled) | stable | `update.mode: "default"` |
| VSCodium extensions | enabled | — | `extensions.autoUpdate: true`, `extensions.autoCheckUpdates: true` |
| Zed | enabled | stable | `auto_update: true` |
| Zed extensions | auto-install on launch | — | `auto_install_extensions` |
| Go tools (VSCodium) | enabled | — | `go.toolsManagement.autoUpdate: true` |
| atuin | disabled (Brew owns) | — | `update_check = false` |
| btop | disabled (Brew owns) | — | No internal update flag |
| superfile | disabled (Brew owns) | — | `auto_check_update = false` |
| lazygit | disabled (Brew owns) | — | `update.method: never` |
| tlrc cache | enabled | — | `[cache].auto_update = true` |
| Homebrew | manual (`make brew-install`) | — | No auto-update |

**Codex ↔ Claude shared docs:** Codex `project_doc_fallback_filenames = ["CLAUDE.md"]` — both agents read same `CLAUDE.md` files

## Exclusion lists

**Search-tool core set** (must stay in sync across `.config/ripgrep/ripgreprc`, `fd` alias in `.zshrc`, VSCodium `search.exclude`, Zed `file_scan_exclusions`): `.git`, `node_modules`, `.venv`, `venv`, `__pycache__`, `.pytest_cache`, `.terraform`, `vendor`, `dist`, `build`, `coverage`. Zed `file_scan_exclusions` is a strict superset; it adds VCS-other (`.svn`, `.hg`, `.jj`, `CVS`), OS-junk (`.DS_Store`, `Thumbs.db`), and IDE-junk (`.classpath`, `.settings`).

**Git global ignore** (`.config/git/ignore`) covers the same dependency / build / cache dirs (`node_modules`, `.venv`, `venv`, `__pycache__`, `.pytest_cache`, `.terraform`, `vendor`, `dist`, `build`, `coverage`) but intentionally **omits `.git` itself** (git would otherwise treat any nested `.git` directory as ignored, breaking submodules and worktrees). Do not add `.git` to `.config/git/ignore` for "consistency" with the search-tool list above; the two invariants are separate.

## Git settings

Must stay consistent across: `.config/git/config` (authoritative), VSCodium, Zed, `gh` CLI, lazygit

| Setting | `.config/git/config` | VSCodium | gh CLI | lazygit | Zed |
|---|---|---|---|---|---|
| Protocol | `url.insteadOf` (SSH) | `gitProtocol: "ssh"` | `git_protocol: ssh` | (uses git) | (uses git) |
| Auto fetch | — | `autofetch: true` (300s) | — | `autoFetch: true` (default 60s) | no setting (gap) |
| Prune on fetch | `fetch.prune = true` | `pruneOnFetch: true` | — | — | (uses git) |
| Rebase on pull | `pull.rebase = true` | `rebaseWhenSync: true` | — | — | (uses git) |
| Autostash | `rebase.autostash = true` | `autoStash: true` | — | — | (uses git) |
| Branch protection | — | `branchProtection: [main, master]` | — | `disableForcePushing: true` | no setting (gap) |
| Inline blame | — | `git.blame.editorDecoration.enabled` + `git.blame.statusBarItem.enabled` | — | — | `git.inline_blame.enabled: true` |
| Blame format | — | `${authorName} (${authorDateAgo})` (set on both `git.blame.editorDecoration.template` + `git.blame.statusBarItem.template`) | — | — | `git.inline_blame.show_commit_summary: false` |
| Editor | `core.editor = codium --reuse-window --wait --` | — | — | `os.edit/editAtLine/editAtLineAndWait` use `codium --reuse-window [--goto] [--wait] -- ...`; `os.openDirInEditor` uses bare `codium -- {{dir}}` (no `--reuse-window`); `editInTerminal: false`. No `vscodium` preset upstream; mirrors `vscode` preset with `code`→`codium`. | — |
| Nerd fonts | — | — | — | `nerdFontsVersion: "3"` | — |

Zed delegates git workflow (rebase, autostash, prune, SSH) to `.config/git/config` — consistent by inheritance. Two known gaps: no auto-fetch, no branch protection.

`.config/git/config` authoritative settings: `core.autocrlf = input`, `init.defaultBranch = main`, `merge.conflictstyle = zdiff3`, `rerere.enabled = true`, `rerere.autoupdate = true`, `push.autoSetupRemote = true`, `diff.algorithm = histogram`, `diff.colorMoved = default`, `diff.renames = true`, `diff.mnemonicPrefix = true`, `log.date = relative`, `branch.sort = -committerdate`. Delta config: `dark = true`, `line-numbers = true`, `side-by-side = true`, `hyperlinks = true`, `navigate = true`. `[filter "lfs"]` block pre-configured for git-lfs — no need to run `git lfs install`.

**VSCodium uses the same `git.blame.*` split** as VSCode (Code OSS heritage): `git.blame.editorDecoration.enabled` (inline editor decoration) and `git.blame.statusBarItem.enabled` (status bar item), each with its own `template`. Do not use the legacy flat `git.blame.enabled` key — it is silently ignored.

`.config/git/config` section order: Identity (`user`, `url`) → Core (`core`, `init`, `interactive`) → Pager (`delta`) → Display (`diff`, `merge`, `log`, `branch`) → Workflow (`fetch`, `pull`, `rebase`, `push`, `rerere`) → Filters (`filter "lfs"`) → Aliases (`alias`, last). Add new sections under the matching group.

## VISUAL / EDITOR env vars

Must match across:

Canonical template = lazygit upstream `vscode` preset (`pkg/config/editor_presets.go`) with `code` → `codium`. Flag order: `codium --reuse-window [--goto] [--wait] --`. Directory targets: bare `codium --`.

- `.config/lazygit/config.yml`: `edit` = `codium --reuse-window -- {{filename}}`; `editAtLine` = `codium --reuse-window --goto -- {{filename}}:{{line}}`; `editAtLineAndWait` = `codium --reuse-window --goto --wait -- {{filename}}:{{line}}`; `openDirInEditor` = `codium -- {{dir}}`; `editInTerminal: false`. Source of truth.
- `.zprofile`: `VISUAL="codium --reuse-window --wait --"`, `EDITOR="$VISUAL"`
- `.config/git/config`: `core.editor = codium --reuse-window --wait --`
- `.config/gh/config.yml`: `editor: codium --reuse-window --wait --`
- `.config/superfile/config.toml`: `editor = "codium --reuse-window --wait --"`; `dir_editor = "codium --"`
- `.config/yazi/yazi.toml`: `[opener.edit]` shell-branches: `if [ -d "$0" ]; then codium -- "$0"; else codium --reuse-window -- "$0"; fi`. File branch matches lazygit `edit`; dir branch matches lazygit `openDirInEditor`. `orphan = true` detaches codium so it survives yazi exit. Single opener; yazi's default folder rule routes `*/` to `edit`.
- `.config/codex/config.toml`: `file_opener = "none"` — Codex enum is `vscode|vscode-insiders|windsurf|cursor|none`, no `vscodium`; `vscode` emits `vscode://file/...` URIs but VSCodium only registers `vscodium://`, so clicks would silently fail. `none` drops the URI scheme; citations stay copy-pasteable as plain `path:line`. Revisit when Codex adds `vscodium`.

`VISUAL` is set first because modern consumers (`sudoedit`, `crontab -e`, `less +v`, `man -e`) check `VISUAL` before `EDITOR`. `EDITOR` is the historical fallback for line editors. Setting both to the same value covers every consumer.

**Conventions:**

- **File targets use `--reuse-window`** (attach as new tab to focused VSCodium window). Tradeoff: tab routes to whichever window is focused, which can misroute commit messages between projects. Accepted to avoid window-explosion.
- **Directory targets OMIT `--reuse-window`.** With `--reuse-window`, opening a directory REPLACES the workspace folder in the focused window (clobbers the current project). Bare `codium -- DIR` opens as a new workspace window.
- **`--wait` is added only where the caller blocks on editor exit and needs the file-saved signal**: git commit, gh edit, sudoedit/crontab via `$VISUAL`, superfile TUI handoff, lazygit `editAtLineAndWait`. Non-blocking callers (yazi `orphan = true`, lazygit `edit`/`editAtLine`/`openDirInEditor`) omit `--wait` — with `--wait` they would leave the codium CLI process idle or block lazygit's refresh until tab close.
- **`--` argument separator** ends every file-target codium invocation in this repo. Lazygit templates put it explicitly (`-- {{filename}}`); git, gh, superfile, yazi, and `$VISUAL` end the command string with a trailing ` --` so the caller's appended path lands after it. Protects against filenames starting with a dash being misparsed as flags. Omitted only when nothing follows (e.g. spf `dir_editor` and lazygit `openDirInEditor` use bare paths but those have known caller behavior).

**Claude ↔ Codex** allowed commands must stay in sync between `.config/claude/settings.json` and `.config/codex/rules/`. Scratch dirs are intentionally per-agent: Claude uses `/tmp/claude` (allow-listed in `.config/claude/settings.json`, mandated by `.config/claude/CLAUDE.md` `## Scratch Files`); Codex uses `/tmp/codex` (allow-listed in `.config/codex/rules/shell.rules`, mandated by `.config/codex/AGENTS.md` `## Scratch Files`).

## Marketplace identifiers

Intentionally divergent between Claude and Codex when both tools register the same upstream repo, because Codex CLI does not support renaming a marketplace key after `codex plugin marketplace add` (the key is fixed by the add command). Current state for the shared third-party marketplaces:

- `caveman` (https://github.com/JuliusBrussee/caveman):
  - `.config/claude/settings.json` → `extraKnownMarketplaces.caveman`
  - `.config/codex/config.toml` → `[marketplaces.caveman-repo]` + `[plugins."caveman@caveman-repo"]`
- `context7` (https://github.com/upstash/context7) — Codex-only:
  - `.config/codex/config.toml` → `[marketplaces.context7-marketplace]` + `[plugins."context7@context7-marketplace"]`
  - Claude uses `context7@claude-plugins-official` via the bundled official marketplace, so no `extraKnownMarketplaces` entry is needed.

Do not attempt to rename the Codex side to `caveman` — Codex will treat it as a new, unregistered marketplace and the plugin enable line will dangle.

**Built-in Codex marketplaces:** `openai-curated` is pre-registered by the Codex CLI binary — do not declare `[marketplaces.openai-curated]` in `.config/codex/config.toml`. Plugin references like `[plugins."slack@openai-curated"]` resolve through the built-in registry. Only third-party marketplaces (e.g. `caveman-repo`) need explicit `[marketplaces.<name>]` blocks. The `[marketplaces.<name>]` + `[plugins."<id>@<name>"]` schema is read by Codex CLI but is not surfaced in the public config reference; verify with `codex plugin marketplace list` and `codex plugin list` after edits.

**Third-party marketplace state fields:** Codex CLI writes `last_updated` and `last_revision` into the `[marketplaces.<name>]` block on every `codex plugin marketplace update`. They are intentionally **not** committed in `.config/codex/config.toml` because each refresh produces a noisy diff. Only `source_type` and `source` are tracked; the timestamp + revision fields repopulate locally after the first update.

**Per-machine team marketplaces:** `scripts/local-overrides.py` injects extra `extraKnownMarketplaces.<key>` entries (Claude) and `[projects."<path>"]` trust blocks (Codex) from `.local/source.toml`. Tracked configs ship with only the shared `caveman` market; team-specific entries land in the working tree on each `make local-overrides` run. See README "Local overrides".

**Codex marketplace/plugin overrides are intentionally not per-machine.** Codex CLI fixes the marketplace key at `codex plugin marketplace add` time (no rename), so the shared-key model that `local-overrides.py` uses for Claude does not map cleanly. Team-private Codex marketplaces must be added directly to `.config/codex/config.toml` (or registered via the CLI) and kept uncommitted manually. Revisit the schema if a second user ever needs this flow.

## Claude/Codex plugin set parity

Plugin sets are intentionally asymmetric:

- Shared: caveman, context7, slack, posthog, datadog, superpowers, atlassian (Codex side: `atlassian-rovo`).
- Claude-only: LSP plugins (Go, Python, TypeScript) and Anthropic first-party plugins. The live list is `enabledPlugins` in `.config/claude/settings.json`; this doc covers only the category split. Codex Marketplace registers no equivalents; LSPs are bundled in the Codex CLI itself.

## Brewfile maintenance

- `Brewfile` is **the dump target**: `make brew-export` overwrites it via `brew bundle dump --force --no-describe`, then strips any line that also appears in `Brewfile.work`. The `--no-describe` flag suppresses the per-entry `# Description` comments that `brew bundle dump` emits by default; both Brewfiles stay bare so the strip step never leaves orphan comment lines. Net effect: base stays curated, work entries stay separate. **macOS only**: the target self-skips on Linux because Linuxbrew install state covers only the Linux-installable cask subset (see `casks.md`), so a Linux dump would wipe the macOS-only cask entries from `Brewfile` (work casks live in `Brewfile.work`, which `brew bundle dump --file=Brewfile` never touches).
- `Brewfile.work` is **manually curated**: `brew bundle dump` does not respect file boundaries, so new work entries must be added by hand to `Brewfile.work` after install. Otherwise the next `make brew-export` will leak them into base.
- `Brewfile.work` lines must use the same format `brew bundle dump` emits (`cask "name"`, `brew "name"`, etc.). The strip step prefilters `Brewfile.work` through `grep -E '^(brew|cask|tap|vscode|mas|go|uv|npm) "'` before whole-line fixed-string match, so blank lines and comments in `Brewfile.work` are tolerated, but malformed entries (wrong prefix, trailing whitespace) still leak through.
- Do not re-sort either Brewfile by hand — `brew bundle dump` owns ordering.

## Linux GUI apps

Vendor `.deb` / `.rpm` packages install separately from the Brewfile. Flatpak is avoided for any app whose config this repo symlinks (`~/.config/<tool>/`): vendor packages respect `$XDG_CONFIG_HOME`, integrate with `apt` / `dnf` for updates, and avoid the per-app sandbox path remap that would break the symlinks in `scripts/symlinks.sh`. Apps with no repo-managed config (one-shot GUIs in `linux-tips.md`) can still use Flatpak.

**Tailscale name divergence:** the macOS cask is `tailscale-app` (the GUI bundle). On Linux the upstream installer ships `tailscale` (CLI + `tailscaled` daemon only; no GUI tray). The two are intentionally different packages; do not rename the cask to match the Linux package or vice versa.

**Telegram name divergence:** the macOS cask is `telegram` (Cocoa build). On Linux distros ship the cross-platform Qt build as `telegram-desktop` (apt/dnf). Same upstream app, different package name; do not rename either to match the other.
