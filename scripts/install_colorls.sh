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

if ! command -v gem &>/dev/null; then
    log_error "Ruby gem is not installed. Cannot install colorls."
    log_error "Please install ruby/gem first."
    return 1
fi

# Always use --user-install for servers without root permissions
# Set up user gem environment
export GEM_HOME="$HOME/.gem"

# Get Ruby version for bin path (works on both macOS and Linux)
RUBY_VERSION=$(ruby -e 'puts RUBY_VERSION.split(".")[0..1].join(".")' 2>/dev/null || echo "3.0")
export PATH="$HOME/.gem/ruby/${RUBY_VERSION}.0/bin:$PATH"

if command -v colorls &>/dev/null; then
    log_warn "colorls is already installed: $(gem which colorls)"
    log_info "Updating colorls..."
    gem update colorls
    log_success "colorls updated"
else
    log_info "Installing colorls gem..."
    gem install colorls
    log_success "colorls installed"
fi

COLORLS_PATH="$(dirname $(gem which colorls))"
TAB_COMPLETE_FILE="$COLORLS_PATH/tab_complete.sh"

if [ -f "$TAB_COMPLETE_FILE" ]; then
    log_success "colorls tab completion available at: $TAB_COMPLETE_FILE"
else
    log_warn "colorls tab completion file not found. Skipping."
fi

log_info "Testing colorls installation..."
# Use full path from gem to test, since PATH may not be updated in current shell
COLORLS_BIN="$HOME/.gem/ruby/${RUBY_VERSION}.0/bin/colorls"
if [ -x "$COLORLS_BIN" ]; then
    VERSION=$("$COLORLS_BIN" --version 2>/dev/null || echo "unknown")
    log_success "colorls is working (version: $VERSION)"
else
    log_warn "colorls binary not found at expected location"
    log_warn "It will be available after reloading your shell"
fi
