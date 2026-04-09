# logo-ls Integration with Fallback
#
# This file is sourced AFTER paths.zsh, so ~/.local/bin (where get.sh
# installs the binary) is already on PATH.
#
# Requires Nerd Fonts in the terminal for icons to render properly.

if command -v logo-ls &>/dev/null; then
  # ── logo-ls found on PATH ──────────────────────────────────────────
  alias ls='logo-ls'
  alias la='logo-ls -la'
  alias ll='logo-ls -al'          # colorls -alF: -F classify is not supported by logo-ls
  alias ld='logo-ls -ld'
  alias lgs='logo-ls -D'          # -D = --git-status

  # logo-ls has no tree mode; fall back to system tree if available
  if command -v tree &>/dev/null; then
    alias lt='tree -L 2'
  else
    alias lt='logo-ls -R'         # recursive list as last resort
  fi

else
  # ── logo-ls NOT found -- use system ls with colors ─────────────────
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
