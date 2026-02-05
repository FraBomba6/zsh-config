#!/bin/bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[1;33m'

log_info() {
    echo -e "\033[0;36m[INFO]\033[0m $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

if ! command -v tmux &>/dev/null; then
    log_info "Installing tmux..."
    
    case "$PACKAGE_MANAGER" in
        brew)
            brew install tmux
            ;;
        apt)
            sudo apt update
            sudo apt install -y tmux
            ;;
        dnf)
            sudo dnf install -y tmux
            ;;
        yum)
            sudo yum install -y tmux
            ;;
        pacman)
            sudo pacman -S --noconfirm tmux
            ;;
        *)
            log_warn "Unsupported package manager: $PACKAGE_MANAGER"
            log_warn "Please install tmux manually"
            return 1
            ;;
    esac
    
    log_success "tmux installed"
else
    TMUX_VERSION=$(tmux -V | awk '{print $2}')
    log_success "tmux version $TMUX_VERSION is already installed"
fi

if [ ! -f "$HOME/.tmux.conf" ]; then
    log_info "Setting up tmux configuration..."
    ln -sf "$ZSH_CONFIG_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    log_success "tmux configuration linked"
fi

log_info "Tmux autostart is handled by oh-my-zsh plugin (configured in .zshrc)"
