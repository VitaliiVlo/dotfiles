# XDG Base Directory Spec (set explicitly so non-fallback consumers see them)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

if [[ -z "${BREW_PREFIX:-}" ]]; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
  else
    BREW_PREFIX="/opt/homebrew"
  fi
fi
[[ -x "$BREW_PREFIX/bin/brew" ]] && eval "$("$BREW_PREFIX/bin/brew" shellenv)"

# Editor + ripgrep
# VISUAL covers sudoedit / crontab -e / less +v; EDITOR is the fallback consumer.
export VISUAL="codium --reuse-window --wait --"
export EDITOR="$VISUAL"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/ripgreprc"

# Go (Go does not honor XDG natively; explicit GOPATH redirects everything)
export GOPATH="$XDG_DATA_HOME/go"
export GOPRIVATE="github.com/your-org/*"
export PATH="$GOPATH/bin:$PATH"

# uv (global Python CLI tools via `uv tool install`)
export PATH="$HOME/.local/bin:$PATH"
