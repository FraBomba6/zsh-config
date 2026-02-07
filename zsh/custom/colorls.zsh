# Colorls Integration with Fallback
#
# This file is sourced AFTER paths.zsh, so all gem bin directories
# should already be on PATH by the time we get here.

if command -v colorls &>/dev/null; then
  # ── colorls found on PATH ──────────────────────────────────────────
  # Try to find tab_complete.sh via `gem which`; fall back to searching
  # gem directories directly (handles Ruby version upgrades gracefully).
  _colorls_tab_complete=""

  if command -v gem &>/dev/null; then
    _colorls_lib="$(gem which colorls 2>/dev/null)"
    if [ -n "$_colorls_lib" ]; then
      _colorls_tab_complete="$(dirname "$_colorls_lib")/tab_complete.sh"
    fi
  fi

  # Fallback: search across all gem directories
  if [ ! -f "$_colorls_tab_complete" ]; then
    for _candidate in \
      ${HOMEBREW_PREFIX:-/opt/homebrew}/lib/ruby/gems/*/gems/colorls-*/lib/tab_complete.sh(N) \
      $HOME/.gem/ruby/*/gems/colorls-*/lib/tab_complete.sh(N); do
      if [ -f "$_candidate" ]; then
        _colorls_tab_complete="$_candidate"
        break
      fi
    done
  fi

  # Source tab completion if found
  if [ -f "$_colorls_tab_complete" ]; then
    source "$_colorls_tab_complete" 2>/dev/null
  fi

  unset _colorls_lib _colorls_tab_complete _candidate

  # Aliases
  alias ls='colorls'
  alias la='colorls -la'
  alias ll='colorls -alF'
  alias lt='colorls --tree=2'
  alias ld='colorls -ld'
  alias lgs='colorls --gs'

else
  # ── colorls NOT found -- use system ls with colors ─────────────────
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS BSD ls uses -G for color
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi

  alias la='ls -la'
  alias ll='ls -alF'
  alias ld='ls -ld'

  if command -v tree &>/dev/null; then
    alias lt='tree -L 2'
  else
    alias lt='ls -R'
  fi
fi
