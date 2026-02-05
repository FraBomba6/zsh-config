# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Autosuggestions configuration
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Plugins
plugins=(
  git
  wd
  tmux
  ssh
  docker
  gh
  colored-man-pages
  history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Start Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Source zsh environment
[[ -f ~/.zshenv ]] && source ~/.zshenv

# Source custom configurations
ZSH_CONFIG_CUSTOM_DIR="${ZSH_CONFIG_DIR:-$HOME/zsh-config}/zsh/custom"

# Load custom files in order
for config_file in "$ZSH_CONFIG_CUSTOM_DIR"/{paths,aliases,functions,fzf,colorls,docker,conda,sysutils}.zsh; do
  [[ -f "$config_file" ]] && source "$config_file"
done

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf key bindings and completions
if command -v fzf &>/dev/null; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# z (directory jumper) key bindings
if command -v _z &>/dev/null; then
  autoload -Uz _z && eval "$(z --init zsh)"
fi

# Better completion
autoload -Uz compinit
compinit -i

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colors for completion
zstyle ':completion:*:default' list-colors ''

# Kill entire word with Ctrl+W
bindkey '^W' backward-kill-word

# Better history search with Ctrl+R
bindkey '^R' history-incremental-search-backward

# Auto-cd
setopt AUTO_CD

# Extended globbing
setopt EXTENDED_GLOB

# Notify when background jobs finish
setopt NOTIFY

# Auto pushd
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# cd beep
unsetopt BEEP
