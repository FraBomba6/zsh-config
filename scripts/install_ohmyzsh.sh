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

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

if [ -d "$OH_MY_ZSH_DIR" ]; then
    log_info "Oh My Zsh is already installed at $OH_MY_ZSH_DIR"
    log_info "Updating Oh My Zsh..."
    cd "$OH_MY_ZSH_DIR"
    git pull origin master || log_warn "Failed to update Oh My Zsh"
    cd - > /dev/null
    log_success "Oh My Zsh updated"
else
    log_info "Installing Oh My Zsh..."
    REMOTE="https://github.com/ohmyzsh/ohmyzsh.git"

    if command -v git &>/dev/null; then
        git clone --depth=1 "$REMOTE" "$OH_MY_ZSH_DIR"
        log_success "Oh My Zsh installed at $OH_MY_ZSH_DIR"
    elif command -v curl &>/dev/null; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    elif command -v wget &>/dev/null; then
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O-)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log_error "Neither git nor curl/wget is available"
        exit 1
    fi
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$OH_MY_ZSH_DIR/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

log_info "Installing Powerlevel10k theme..."
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    log_success "Powerlevel10k theme installed"
else
    log_info "Powerlevel10k is already installed. Updating..."
    cd "$P10K_DIR"
    git pull origin master
    cd - > /dev/null
    log_success "Powerlevel10k theme updated"
fi

log_success "Oh My Zsh and Powerlevel10k setup complete"
