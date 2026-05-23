if [[ -z "${BREW_PREFIX:-}" ]]; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
  else
    BREW_PREFIX="/opt/homebrew"
  fi
fi

# History
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt hist_verify
setopt hist_reduce_blanks
setopt hist_ignore_space

# Shell options
setopt globdots
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# Aliases
alias kk='kubectl'
alias c='clear'
alias kctx='kubectl config current-context'
alias lzg='lazygit'

if command -v bat &>/dev/null; then alias cat='bat'; fi

# fd has no config file; defined outside the conditional so fzf can reuse it
_FD_OPTS="--hidden --follow --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .venv --exclude venv --exclude __pycache__ --exclude .pytest_cache --exclude .terraform --exclude vendor --exclude dist --exclude build --exclude coverage"
if command -v fd &>/dev/null; then
  alias fd="fd $_FD_OPTS"
fi

# eza: shared options reused by fzf preview
_EZA_LIST_OPTS="-lagF --icons=auto --group-directories-first --git --time-style=relative --header --hyperlink --smart-group"
_EZA_TREE_OPTS="-aF --icons=auto --tree --level=2 --group-directories-first --git-ignore"
if command -v eza &>/dev/null; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll="eza $_EZA_LIST_OPTS"
  alias lt="eza $_EZA_TREE_OPTS"
  alias lr="eza $_EZA_LIST_OPTS --sort=modified --reverse"
else
  alias ll='ls -lah'
fi

# Completions
ZSH_COMP_PATH="$BREW_PREFIX/share/zsh-completions"
if [[ -d "$ZSH_COMP_PATH" ]]; then
  FPATH="$ZSH_COMP_PATH:$FPATH"
fi
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# Autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
ZSH_AS_PATH="$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -f "$ZSH_AS_PATH" ]]; then
  source "$ZSH_AS_PATH"
fi

# fzf
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border"
  export FZF_CTRL_R_OPTS="--no-preview --height=50%"
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND="fd --type f $_FD_OPTS"
    export FZF_CTRL_T_COMMAND="fd --type f $_FD_OPTS"
    export FZF_ALT_C_COMMAND="fd --type d $_FD_OPTS"
  fi
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range=:500 {} 2>/dev/null || cat {}'"
  export FZF_ALT_C_OPTS="--preview 'eza $_EZA_TREE_OPTS --color=always {} 2>/dev/null || ls -la {}'"
  eval "$(fzf --zsh)"
fi

# fnm
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# uv
if command -v uv &>/dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# starship
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# atuin (binds Ctrl+R and Up arrow; must load after fzf)
if command -v atuin &>/dev/null; then
  eval "$(atuin init zsh)"
fi

# Syntax highlighting (load last)
ZSH_SH_PATH="$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [[ -f "$ZSH_SH_PATH" ]]; then
  source "$ZSH_SH_PATH"
fi
