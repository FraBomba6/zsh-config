# Custom PATH additions

# FZF (fuzzy finder) - use git version over package manager version
if [ -d "$HOME/.fzf/bin" ]; then
  export PATH="$HOME/.fzf/bin:$PATH"
fi

# Local bin directories
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Ruby gems (for colorls and other ruby tools)
if command -v gem &>/dev/null; then
  # Try user gem directory first (for --user-install gems)
  USER_GEM_BIN="$(gem env | grep 'USER INSTALLATION DIRECTORY' | cut -d ':' -f 2 | tr -d ' ')/bin"
  if [ -d "$USER_GEM_BIN" ]; then
    export PATH="$USER_GEM_BIN:$PATH"
  else
    # Fallback to system gem directory
    GEM_BIN_PATH="$(gem env | grep 'EXECUTABLE DIRECTORY' | cut -d ':' -f 2 | tr -d ' ')"
    if [ -n "$GEM_BIN_PATH" ]; then
      export PATH="$GEM_BIN_PATH:$PATH"
    fi
  fi
fi

# Homebrew (macOS)
if [[ "$OSTYPE" == "darwin"* ]] && [ -d /opt/homebrew/bin ]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ "$OSTYPE" == "darwin"* ]] && [ -d /usr/local/bin ]; then
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
  export HOMEBREW_PREFIX="/usr/local"
fi

# Flutter (if installed)
if [ -d "$HOME/flutter" ]; then
  export PATH="$HOME/flutter/bin:$PATH"
fi

# Rust (if installed)
if [ -d "$HOME/.cargo/bin" ]; then
  source "$HOME/.cargo/env" 2>/dev/null || true
fi

# User-specific paths (customize these)
# export PATH="/path/to/your/tool:$PATH"
# export PATH="$HOME/Tools:$PATH"
