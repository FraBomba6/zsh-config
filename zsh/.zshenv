# Zsh Environment Variables
# Sourced by zsh BEFORE .zshrc for every zsh invocation (interactive and
# non-interactive).  Keep this file lean -- only pure env-var exports.
# Shell options (setopt) and aliases belong in .zshrc, not here.

# Editor
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-vim}

# History
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"

# XDG base directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# Locale
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# Less
export LESS='-R'
