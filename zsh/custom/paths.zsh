# Custom PATH additions
# This file is sourced early by .zshrc to ensure all binaries are available.
# Order matters: Homebrew/system paths first, then tools, then user paths.

# ---------------------------------------------------------------------------
# 1. Homebrew (macOS) -- must come first so brew-managed ruby, gem, etc. work
# ---------------------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ -d /opt/homebrew ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
  elif [ -d /usr/local/Homebrew ]; then
    export HOMEBREW_PREFIX="/usr/local"
  fi

  if [ -n "$HOMEBREW_PREFIX" ]; then
    export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

    # Homebrew-managed Ruby (ensures `gem`, `ruby` resolve to Homebrew versions)
    if [ -d "$HOMEBREW_PREFIX/opt/ruby/bin" ]; then
      export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"
    fi

    # Compiler flags for Homebrew libraries
    export CPPFLAGS="-I${HOMEBREW_PREFIX}/include${CPPFLAGS+ ${CPPFLAGS}}"
    export LDFLAGS="-L${HOMEBREW_PREFIX}/lib -Wl,-rpath,${HOMEBREW_PREFIX}/lib${LDFLAGS+ ${LDFLAGS}}"
  fi
fi

# ---------------------------------------------------------------------------
# 2. Ruby gems -- add ALL gem bin directories so gems survive Ruby upgrades
# ---------------------------------------------------------------------------
if [[ "$OSTYPE" == "darwin"* ]] && [ -n "$HOMEBREW_PREFIX" ]; then
  # Homebrew-managed gems: add every version's bin directory
  for gemdir in "$HOMEBREW_PREFIX"/lib/ruby/gems/*/bin(N); do
    export PATH="$gemdir:$PATH"
  done
fi

# User-local gems (Linux servers, --user-install, etc.)
for gemdir in "$HOME"/.gem/ruby/*/bin(N); do
  export PATH="$gemdir:$PATH"
done

# ---------------------------------------------------------------------------
# 3. FZF (fuzzy finder) -- prefer git-installed version over system package
# ---------------------------------------------------------------------------
if [ -d "$HOME/.fzf/bin" ]; then
  export PATH="$HOME/.fzf/bin:$PATH"
fi

# ---------------------------------------------------------------------------
# 4. Local bin directories
# ---------------------------------------------------------------------------
[ -d "$HOME/bin" ]        && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# 5. Language-specific tools (only if installed)
# ---------------------------------------------------------------------------

# Rust / Cargo
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
  [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env" 2>/dev/null
fi

# Flutter
[ -d "$HOME/flutter/bin" ] && export PATH="$HOME/flutter/bin:$PATH"

# Go
[ -d "$HOME/go/bin" ]      && export PATH="$HOME/go/bin:$PATH"
[ -d "/usr/local/go/bin" ] && export PATH="/usr/local/go/bin:$PATH"

# ---------------------------------------------------------------------------
# 6. Machine-specific paths
# ---------------------------------------------------------------------------
# Add machine-specific paths in ~/.zshrc.local or zsh/custom/local.zsh
# Example:
#   export PATH="/opt/my-tool/bin:$PATH"
