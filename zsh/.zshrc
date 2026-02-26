# Enable Powerlevel10k instant prompt.
# Must stay at the very top. Console input (password prompts, y/n, etc.)
# must go above this block; everything else below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------------------------------------------------------------------------
# Oh My Zsh
# ---------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Autosuggestions tuning
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Plugins (built-in + custom that live in $ZSH_CUSTOM/plugins/)
plugins=(
  git
  wd
  tmux
  ssh
  docker
  gh
  colored-man-pages
  history-substring-search
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Tmux plugin configuration (oh-my-zsh plugin handles autostart)
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_AUTOSTART_ONCE=true
export ZSH_TMUX_AUTOCONNECT=true
export ZSH_TMUX_AUTOQUIT=true
export ZSH_TMUX_DEFAULT_SESSION_NAME="main"

source $ZSH/oh-my-zsh.sh

# ---------------------------------------------------------------------------
# Source custom configuration files from the repo
# ---------------------------------------------------------------------------
# Resolve the repo directory: follow the symlink from ~/.zshrc back to its
# parent, then up to zsh/custom/.  Falls back to ~/zsh-config if the symlink
# is missing (e.g. the file was copied instead of linked).
if [ -L "$HOME/.zshrc" ]; then
  _zshrc_real="$(readlink "$HOME/.zshrc")"
  ZSH_CONFIG_CUSTOM_DIR="$(cd "$(dirname "$_zshrc_real")" && pwd)/custom"
  unset _zshrc_real
else
  ZSH_CONFIG_CUSTOM_DIR="${HOME}/zsh-config/zsh/custom"
fi

# Load order matters:
#   paths     -> ensures binaries are on PATH first
#   conda     -> conda/mamba init + Docker Desktop fpath (before compinit)
#   aliases   -> command aliases (may depend on PATH)
#   sysutils  -> modern tool aliases (bat, fd, rg, eza)
#   colorls   -> ls/la aliases (needs colorls on PATH, takes precedence over eza)
#   fzf       -> fuzzy finder config + keybindings
#   docker    -> docker helpers
#   functions -> utility functions
for config_file in \
  "$ZSH_CONFIG_CUSTOM_DIR"/paths.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/conda.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/aliases.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/sysutils.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/colorls.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/fzf.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/docker.zsh \
  "$ZSH_CONFIG_CUSTOM_DIR"/functions.zsh; do
  [[ -f "$config_file" ]] && source "$config_file"
done
unset config_file

# ---------------------------------------------------------------------------
# Completions (run AFTER conda.zsh adds Docker Desktop fpath)
# ---------------------------------------------------------------------------
autoload -Uz compinit
compinit -i

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:default' list-colors ''

# ---------------------------------------------------------------------------
# Powerlevel10k configuration
# ---------------------------------------------------------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------
bindkey '^W' backward-kill-word
bindkey '^R' history-incremental-search-backward

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NOTIFY
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
unsetopt BEEP

# History (duplicated from .zshenv for non-login shells that skip .zshenv)
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt APPEND_HISTORY

# ---------------------------------------------------------------------------
# Local overrides (machine-specific, not tracked in git)
# ---------------------------------------------------------------------------
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f "$ZSH_CONFIG_CUSTOM_DIR/local.zsh" ]] && source "$ZSH_CONFIG_CUSTOM_DIR/local.zsh"

# ---------------------------------------------------------------------------
# Auto-start tmux on SSH connections (if tmux is installed)
# ---------------------------------------------------------------------------
if [[ -n "$SSH_TTY" ]] && [[ -z "$TMUX" ]] && command -v tmux &>/dev/null; then
  if tmux has-session -t main 2>/dev/null; then
    exec tmux attach-session -t main
  else
    exec tmux new-session -s main
  fi
fi
