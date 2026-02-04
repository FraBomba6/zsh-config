# Zsh Environment Variables
# This file is sourced before .zshrc and sets environment variables

# Editor
export EDITOR=${EDITOR:-vim}
export VISUAL=${VISUAL:-vim}

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_VERIFY
setopt APPEND_HISTORY

# XDG directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# Language
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# Less colors
export LESS='-R'
export LESS_TERMCAP='mb:E[01;31m:me:E[0m:se:E[0;2m:so:E[0;32m:ue:E[0m:bo:E[01;34m:md:E[01;31m:mr:E[01;37m:mh:E[13m'

# Colorls (will be properly configured in .zshrc)
if command -v colorls &>/dev/null; then
    export COLORLS_DIR=$(dirname $(gem which colorls))
fi
