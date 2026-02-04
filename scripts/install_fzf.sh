#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'

log_info() {
    echo -e "\033[0;36m[INFO]\033[0m $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

FZF_DIR="$HOME/.fzf"

if [ -d "$FZF_DIR" ]; then
    log_info "FZF is already installed. Updating..."
    cd "$FZF_DIR"
    git pull origin master
    cd - > /dev/null
else
    log_info "Installing FZF..."
    git clone --depth=1 https://github.com/junegunn/fzf.git "$FZF_DIR"
fi

log_info "Running FZF install script..."
"$FZF_DIR/install" --key-bindings --completion --no-update-rc 2>/dev/null || true

log_success "FZF installed successfully"
