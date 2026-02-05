# Colorls Integration with Fallback

if command -v colorls &>/dev/null; then
  COLORLS_PATH=$(dirname $(gem which colorls))
  TAB_COMPLETE="$COLORLS_PATH/tab_complete.sh"

  if [ -f "$TAB_COMPLETE" ]; then
    source "$TAB_COMPLETE" 2>/dev/null || true
  fi

  alias ls='colorls'
  alias la='colorls -A'
  alias ll='colorls -l --sd'
  alias lla='colorls -lA --sd'
  alias lt='colorls --tree=2'
  alias lf='colorls -f'
  alias ldir='colorls -d'
  alias lgs='colorls --gs'
  alias llgs='colorls -lA --sd --gs'
  alias ltr='colorls -lt --r'
  alias lS='colorls -S'
  alias lx='colorls -X'

  export COLORLS_ICONS='auto'
  export COLORLS_MODE='dark'
else
  if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi

  alias la='ls -A'
  alias ll='ls -lh'
  alias lla='ls -lAh'
  alias lf='ls -F | grep -v /$'
  alias ldir='ls -d */'
  alias ltr='ls -lht'
  alias lS='ls -lS'
  alias lx='ls -lX'
  alias lgs='ls --color=never'

  if command -v tree &>/dev/null; then
    alias lt='tree -L 2'
  else
    alias lt='ls -R'
  fi
fi
