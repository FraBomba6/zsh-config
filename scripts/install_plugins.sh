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

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

log_info "Installing zsh plugins..."

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log_info "Cloning zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    log_success "zsh-autosuggestions installed"
else
    log_info "Updating zsh-autosuggestions..."
    cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git pull origin master
    cd - > /dev/null
    log_success "zsh-autosuggestions updated"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    log_info "Cloning zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    log_success "zsh-syntax-highlighting installed"
else
    log_info "Updating zsh-syntax-highlighting..."
    cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git pull origin master
    cd - > /dev/null
    log_success "zsh-syntax-highlighting updated"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/z" ]; then
    log_info "Cloning z (directory jumper)..."
    git clone --depth=1 https://github.com/agkozak/zsh-z.git "$ZSH_CUSTOM/plugins/z"
    log_success "z (directory jumper) installed"
else
    log_info "Updating z..."
    cd "$ZSH_CUSTOM/plugins/z"
    git pull origin master
    cd - > /dev/null
    log_success "z (directory jumper) updated"
fi

log_info "Installing fzf..."
source "$ZSH_CONFIG_DIR/scripts/install_fzf.sh"

log_success "All plugins installed successfully"
