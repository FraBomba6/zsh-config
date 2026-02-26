#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

log_info() {
    echo -e "\033[0;36m[INFO]\033[0m $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ---------------------------------------------------------------------------
# Pre-flight: need gem
# ---------------------------------------------------------------------------
if ! command -v gem &>/dev/null; then
    log_error "Ruby gem is not installed. Cannot install colorls."
    log_error "Please install ruby/gem first."
    return 1 2>/dev/null || exit 1
fi

# ---------------------------------------------------------------------------
# On Linux without root, default to user-install.  On macOS with Homebrew
# Ruby the system gem directory is already writable, so no override needed.
# ---------------------------------------------------------------------------
GEM_INSTALL_FLAGS=""
case "$(uname -s)" in
    Linux*)
        if [ "$(id -u)" -ne 0 ]; then
            GEM_INSTALL_FLAGS="--user-install"
            RUBY_API=$(ruby -e 'puts RbConfig::CONFIG["ruby_version"]' 2>/dev/null || echo "3.0.0")
            # Add both possible gem bin locations (depends on Ruby version/dist)
            export PATH="$HOME/.gem/ruby/$RUBY_API/bin:$HOME/.local/share/gem/ruby/$RUBY_API/bin:$PATH"
        fi
        ;;
esac

# ---------------------------------------------------------------------------
# Install or update
# ---------------------------------------------------------------------------
if command -v colorls &>/dev/null; then
    log_info "colorls is already installed. Updating..."
    gem update colorls $GEM_INSTALL_FLAGS 2>/dev/null || log_warn "gem update failed (may need sudo on some systems)"
    log_success "colorls updated"
else
    log_info "Installing colorls gem..."
    gem install colorls $GEM_INSTALL_FLAGS
    log_success "colorls installed"
fi

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
# Re-hash PATH so the shell picks up the new binary
hash -r 2>/dev/null

if command -v colorls &>/dev/null; then
    VERSION=$(colorls --version 2>/dev/null || echo "unknown")
    log_success "colorls is working (version: $VERSION)"
else
    log_warn "colorls binary not found on PATH yet."
    log_warn "It will be available after reloading your shell (source ~/.zshrc)."
fi
