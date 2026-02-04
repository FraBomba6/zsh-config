# Colorls Integration with Fallback

if command -v colorls &>/dev/null; then
  # colorls is installed
  COLORLS_PATH=$(dirname $(gem which colorls))
  TAB_COMPLETE="$COLORLS_PATH/tab_complete.sh"

  # Source tab completion if available
  if [ -f "$TAB_COMPLETE" ]; then
    source "$TAB_COMPLETE" 2>/dev/null || true
  fi

  # Enhanced aliases
  alias ls='colorls'
  alias la='colorls -la'
  alias ll='colorls -alF'
  alias lt='colorls --tree=level 2'
  alias ld='colorls -ld'

  # colorls options
  export COLORLS_ICONS='auto'
  export COLORLS_MODE='dark'
else
  # colorls not installed - use system ls with colors
  alias ls='ls --color=auto'
  alias la='ls -la --color=auto'
  alias ll='ls -alF --color=auto'
  alias lt='tree -L 2 2>/dev/null || ls -R'

  # Warn user once per session
  if [[ -z "$COLORLS_WARNED" ]]; then
    echo "Note: colorls not found. Using system ls with colors."
    echo "Install colorls with: gem install colorls"
    export COLORLS_WARNED=1
  fi
fi

# If tree is installed, use it for lt
if command -v tree &>/dev/null; then
  if command -v colorls &>/dev/null; then
    alias lt='colorls --tree=level 2'
  else
    alias lt='tree -L 2'
  fi
fi
