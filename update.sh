#!/bin/bash
set -e

ZSH_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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

log_info "=== Portable Zsh Configuration Update ==="

source "$ZSH_CONFIG_DIR/scripts/detect_os.sh"

log_info "Updating Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    cd "$HOME/.oh-my-zsh"
    git pull origin master || log_warn "Failed to update Oh My Zsh"
    cd - > /dev/null
    log_success "Oh My Zsh updated"
fi

log_info "Updating plugins..."

# Update zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git pull origin master
    cd - > /dev/null
    log_success "zsh-autosuggestions updated"
fi

# Update zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git pull origin master
    cd - > /dev/null
    log_success "zsh-syntax-highlighting updated"
fi

# Update z
if [ -d "$ZSH_CUSTOM/plugins/z" ]; then
    cd "$ZSH_CUSTOM/plugins/z"
    git pull origin master
    cd - > /dev/null
    log_success "z updated"
fi

log_info "Updating FZF..."
if [ -d "$HOME/.fzf" ]; then
    cd "$HOME/.fzf"
    git pull origin master
    cd - > /dev/null
    log_success "FZF updated"
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc 2>/dev/null || true
fi

log_info "Updating Powerlevel10k..."
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    cd "$ZSH_CUSTOM/themes/powerlevel10k"
    git pull origin master
    cd - > /dev/null
    log_success "Powerlevel10k updated"
fi

if command -v colorls &>/dev/null; then
    log_info "Updating colorls..."
    gem update colorls 2>/dev/null || log_warn "Failed to update colorls"
    log_success "colorls checked"
fi

log_info "Pulling latest configuration..."
cd "$ZSH_CONFIG_DIR"
git pull origin main || log_warn "Failed to update configs"

log_success "Update complete!"
echo ""
log_info "Reload your shell to apply changes:"
echo "  ${YELLOW}source ~/.zshrc${NC}"
echo "  Or start a new terminal session"
