#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "\033[0;36m[INFO]\033[0m $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]\033[0m $1"
}

SSH_DIR="$HOME/.ssh"

mkdir -p "$SSH_DIR"

log_success "SSH directory configured at $SSH_DIR"
log_info "Tmux auto-start is handled by .zshrc (SSH connections only)"
