#!/bin/bash
set -e

ZSH_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.zsh-config-backup-$(date +%Y%m%d_%H%M%S)"
CONFIG_FILE="$ZSH_CONFIG_DIR/config.json"

QUIET=false

for arg in "$@"; do
    case $arg in
        --quiet|-q) QUIET=true ;;
    esac
done

COLORS='\033[0;36m' # Cyan
NC='\033[0m'       # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

log_info() {
    [ "$QUIET" = false ] && echo -e "${COLORS}[INFO]${NC} $1"
}

log_success() {
    [ "$QUIET" = false ] && echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    [ "$QUIET" = false ] && echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

prompt_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat << EOF
Portable Zsh Configuration Installer

Usage: $0 [OPTIONS]

Options:
  --help, -h        Show this help message
  --no-backup      Skip backup creation (not recommended)
  --skip-shell      Skip changing default shell

The installer will guide you through the setup process interactively.
EOF
    exit 0
fi

SKIP_BACKUP=false
SKIP_SHELL=false

for arg in "$@"; do
    case $arg in
        --no-backup) SKIP_BACKUP=true ;;
        --skip-shell) SKIP_SHELL=true ;;
    esac
done

log_info "=== Portable Zsh Configuration Installer ==="
log_info "Configuration directory: $ZSH_CONFIG_DIR"

source "$ZSH_CONFIG_DIR/scripts/detect_os.sh" || exit 1

log_info "Detected OS: $OS_NAME"
log_info "Detected package manager: $PACKAGE_MANAGER"

if ! command -v zsh &>/dev/null; then
    log_warn "Zsh is not installed. Will install now."
    source "$ZSH_CONFIG_DIR/scripts/install_dependencies.sh" || exit 1
else
    ZSH_VERSION=$(zsh --version | awk '{print $2}')
    log_success "Zsh version $ZSH_VERSION is already installed"
fi

if ! command -v git &>/dev/null; then
    log_warn "Git is not installed. Will install now."
    source "$ZSH_CONFIG_DIR/scripts/install_dependencies.sh" || exit 1
else
    log_success "Git $(git --version | awk '{print $3}') is already installed"
fi

if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
    log_error "Neither curl nor wget is installed. Please install one of them."
    exit 1
fi

if [ "$SKIP_BACKUP" = false ]; then
    if [ -f "$HOME/.zshrc" ] || [ -f "$HOME/.p10k.zsh" ] || [ -f "$HOME/.zshenv" ]; then
        log_info "Creating backup of existing configurations..."
        mkdir -p "$BACKUP_DIR"
        [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc"
        [ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$BACKUP_DIR/.p10k.zsh"
        [ -f "$HOME/.zshenv" ] && cp "$HOME/.zshenv" "$BACKUP_DIR/.zshenv"
        [ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$BACKUP_DIR/.tmux.conf"
        [ -f "$HOME/.ssh/rc" ] && cp "$HOME/.ssh/rc" "$BACKUP_DIR/.ssh_rc"
        log_success "Backup created at: $BACKUP_DIR"
    fi
else
    log_warn "Skipping backup as requested"
fi

TMUX_INSTALL=false
TMUX_AUTO_SSH=false
COLORLS_INSTALL=true

echo ""
log_info "=== Configuration Options ==="

if prompt_yes_no "Install tmux?"; then
    TMUX_INSTALL=true
    if prompt_yes_no "  Auto-start tmux on SSH connections?"; then
        TMUX_AUTO_SSH=true
    fi
fi

if ! command -v colorls &>/dev/null; then
    if command -v gem &>/dev/null; then
        log_info "colorls is not installed."
        if prompt_yes_no "Install colorls (provides colored ls and la aliases)?"; then
            COLORLS_INSTALL=true
        else
            COLORLS_INSTALL=false
        fi
    else
        log_warn "Ruby/gem not found. colorls will not be installed."
        log_warn "Fallback ls aliases will be used instead."
        COLORLS_INSTALL=false
    fi
else
    log_success "colorls is already installed"
    COLORLS_INSTALL=true
fi

CONDA_INSTALL=false
if ! command -v conda &>/dev/null && [ ! -d "$HOME/miniforge3" ]; then
    if prompt_yes_no "Install Miniforge (Conda) for Python environment management?"; then
        CONDA_INSTALL=true
    fi
elif [ -d "$HOME/miniforge3" ]; then
    log_success "Miniforge is already installed at ~/miniforge3"
    log_info "Conda integration will be configured in .zshrc"
    CONDA_INTEGRATED=true
fi

UPDATE_CONFIG=true
cat << EOF > "$CONFIG_FILE"
{
  "version": "1.0.0",
  "install_date": "$(date +%Y-%m-%d)",
  "os": "$OS_NAME",
  "package_manager": "$PACKAGE_MANAGER",
  "features": {
    "tmux": {
      "installed": $TMUX_INSTALL,
      "auto_on_ssh": $TMUX_AUTO_SSH
    },
    "colorls": {
      "installed": $COLORLS_INSTALL,
      "auto_installed": false
    },
    "conda": {
      "installed": ${CONDA_INSTALL:-false},
      "integrated": ${CONDA_INTEGRATED:-false},
      "path": null
    },
    "plugins": {
      "fzf": true,
      "z": true,
      "docker": true,
      "gh": true,
      "colored_man_pages": true,
      "history_substring_search": true
    }
  }
}
EOF

log_success "Configuration saved to $CONFIG_FILE"

log_info "Installing Oh My Zsh..."
source "$ZSH_CONFIG_DIR/scripts/install_ohmyzsh.sh"

log_info "Installing plugins..."
source "$ZSH_CONFIG_DIR/scripts/install_plugins.sh"

if [ "$COLORLS_INSTALL" = true ] && ! command -v colorls &>/dev/null; then
    log_info "Installing colorls..."
    source "$ZSH_CONFIG_DIR/scripts/install_colorls.sh"
fi

if [ "$TMUX_INSTALL" = true ]; then
    log_info "Setting up tmux..."
    source "$ZSH_CONFIG_DIR/scripts/install_tmux.sh"
fi

if [ "$TMUX_AUTO_SSH" = true ]; then
    log_info "Setting up SSH tmux integration..."
    source "$ZSH_CONFIG_DIR/scripts/setup_ssh.sh"
fi

log_info "Setting up Zsh configuration..."

ln -sf "$ZSH_CONFIG_DIR/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$ZSH_CONFIG_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

if [ ! -f "$HOME/.zshenv" ] || [ "$SKIP_BACKUP" = true ]; then
    ln -sf "$ZSH_CONFIG_DIR/zsh/.zshenv" "$HOME/.zshenv"
fi

if [ "$TMUX_INSTALL" = true ]; then
    ln -sf "$ZSH_CONFIG_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

log_success "Zsh configuration linked successfully"

if [ "$CONDA_INSTALL" = true ]; then
    log_info "Setting up Conda/Miniforge..."
    if [[ "$OS_NAME" == "macos" ]]; then
        MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname -m)-macosx.sh"
    elif [[ "$OS_NAME" == "linux" ]]; then
        MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname -m)-linux.sh"
    else
        log_warn "Unsupported OS for Miniforge installation. Skipping."
        CONDA_INSTALL=false
    fi

    if [ "$CONDA_INSTALL" = true ]; then
        INSTALL_DIR="$HOME/miniforge3"
        if [ ! -d "$INSTALL_DIR" ]; then
            log_info "Downloading Miniforge installer..."
            curl -L "$MINIFORGE_URL" -o /tmp/miniforge.sh
            bash /tmp/miniforge.sh -b -p "$INSTALL_DIR"
            rm /tmp/miniforge.sh

            sed -i.bak 's|"conda_install_path": null|"conda_install_path": "'"$INSTALL_DIR"'"|' "$CONFIG_FILE"
        else
            log_warn "Miniforge already installed at $INSTALL_DIR"
        fi
    fi
elif [ "$CONDA_INTEGRATED" = true ]; then
    log_info "Integrating existing Miniforge installation..."
    log_success "Conda integration configured"
fi

if [ "$SKIP_SHELL" = false ]; then
    CURRENT_SHELL=$(basename "$SHELL")
    if [ "$CURRENT_SHELL" != "zsh" ]; then
        log_info "Changing default shell to zsh..."
        if command -v chsh &>/dev/null; then
            chsh -s "$(which zsh)"
            log_success "Default shell changed to zsh"
            log_warn "You'll need to logout and login again for the change to take effect."
        else
            log_warn "chsh not available. Please manually change your default shell to zsh:"
            echo "  chsh -s $(which zsh)"
        fi
    else
        log_success "Zsh is already your default shell"
    fi
else
    log_info "Skipping shell change as requested"
fi

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Installation Complete!                    ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "What was installed:"

echo "  ✓ Zsh configuration with Powerlevel10k theme"
echo "  ✓ Oh My Zsh framework"
echo "  ✓ Plugins: zsh-autosuggestions, zsh-syntax-highlighting, fzf, z"

if [ "$TMUX_INSTALL" = true ]; then
    echo "  ✓ Tmux terminal multiplexer"
    if [ "$TMUX_AUTO_SSH" = true ]; then
        echo "  ✓ SSH auto-tmux integration"
    fi
fi

if [ "$COLORLS_INSTALL" = true ]; then
    echo "  ✓ colorls with ls and la aliases"
else
    echo "  ✓ ls and la aliases (using system ls)"
fi

if [ "$CONDA_INSTALL" = true ]; then
    echo "  ✓ Miniforge (Conda) for Python environments"
fi

echo ""
echo -e "${COLORS}Next Steps:${NC}"
echo -e "1. Reload your shell: ${YELLOW}source ~/.zshrc${NC}"
echo "2. Or start a new terminal session"
echo -e "3. Run ${YELLOW}p10k configure${NC} to customize the theme"
echo ""
echo -e "${COLORS}Useful Commands:${NC}"
echo -e "- Update configs: ${YELLOW}cd ~/zsh-config && ./update.sh${NC}"
echo -e "- Uninstall:      ${YELLOW}cd ~/zsh-config && ./uninstall.sh${NC}"
echo -e "- Customize:      ${YELLOW}vim ~/zsh-config/zsh/custom/aliases.zsh${NC}"
echo ""
echo -e "${COLORS}Documentation:${NC}"
echo -e "- README:         ${YELLOW}~/zsh-config/README.md${NC}"
echo -e "- Customize:      ${YELLOW}~/zsh-config/docs/CUSTOMIZATION.md${NC}"
echo -e "- Troubleshoot:   ${YELLOW}~/zsh-config/docs/TROUBLESHOOTING.md${NC}"
echo ""
echo -e "${GREEN}Enjoy your new Zsh setup!${NC}"

# Automatically reload shell to apply changes
if prompt_yes_no "Reload shell now to apply changes?"; then
    exec zsh -l
fi
