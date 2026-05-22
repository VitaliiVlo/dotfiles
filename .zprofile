if [[ -z "${BREW_PREFIX:-}" ]]; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
  else
    BREW_PREFIX="/opt/homebrew"
  fi
fi
eval "$($BREW_PREFIX/bin/brew shellenv)"

# Core
# VISUAL covers sudoedit / crontab -e / less +v; EDITOR is the fallback consumer.
export VISUAL="code --wait --reuse-window"
export EDITOR="$VISUAL"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# Go
export GOPRIVATE="github.com/vitalii-vlo/*"
export PATH="$HOME/go/bin:$PATH"

# uv (global Python CLI tools via `uv tool install`)
export PATH="$HOME/.local/bin:$PATH"

# OrbStack
ORBSTACK_INIT="$HOME/.orbstack/shell/init.zsh"
if [[ -f "$ORBSTACK_INIT" ]]; then
  source "$ORBSTACK_INIT"
fi
