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
# Migration cleanup: remove the legacy colorls gem if present
# ---------------------------------------------------------------------------
if command -v colorls &>/dev/null && command -v gem &>/dev/null; then
    log_info "Removing existing colorls gem (superseded by logo-ls)..."
    gem uninstall -x -a colorls 2>/dev/null \
        || log_warn "Could not uninstall colorls gem automatically (try manually: gem uninstall -x -a colorls)"
fi

# ---------------------------------------------------------------------------
# Ensure ~/.local/bin exists and is on PATH for this session
# ---------------------------------------------------------------------------
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if ! command -v curl &>/dev/null; then
    log_error "curl is required to install logo-ls"
    return 1 2>/dev/null || exit 1
fi

# ---------------------------------------------------------------------------
# Install via upstream get.sh (the canonical method from canta2899/logo-ls)
# Same command works for updates.
# ---------------------------------------------------------------------------
log_info "Downloading logo-ls via upstream get.sh..."
if curl -fsSL https://raw.githubusercontent.com/canta2899/logo-ls/refs/heads/main/get.sh | sh; then
    hash -r 2>/dev/null
    if command -v logo-ls &>/dev/null; then
        VERSION=$(logo-ls --version 2>/dev/null | head -1 || echo "unknown")
        log_success "logo-ls installed ($VERSION)"
    else
        log_warn "logo-ls installed to ~/.local/bin but not yet on PATH"
        log_warn "It will be available after reloading your shell (source ~/.zshrc)"
    fi
    log_info "Note: logo-ls requires Nerd Fonts in your terminal for icons to render"
else
    log_error "logo-ls installation failed"
    return 1 2>/dev/null || exit 1
fi
