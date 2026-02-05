#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'
CYAN='\033[0;36m'

QUIET=false

for arg in "$@"; do
    case $arg in
        --quiet|-q) QUIET=true ;;
    esac
done

log_info() {
    [ "$QUIET" = false ] && echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    [ "$QUIET" = false ] && echo -e "${GREEN}[SUCCESS]${NC} $1"
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
Portable Zsh Configuration Uninstaller

Usage: $0 [OPTIONS]

Options:
  --help, -h        Show this help message
  --remove-configs   Remove configuration files
  --remove-packages   Remove installed packages
  --restore-backup   Restore from backup
  --full             Full uninstall (configs + packages + restore backup)

Without options, only removes symlinks and keeps backups.
EOF
    exit 0
fi

REMOVE_CONFIGS=false
REMOVE_PACKAGES=false
RESTORE_BACKUP=false

for arg in "$@"; do
    case $arg in
        --remove-configs) REMOVE_CONFIGS=true ;;
        --remove-packages) REMOVE_PACKAGES=true ;;
        --restore-backup) RESTORE_BACKUP=true ;;
        --full) REMOVE_CONFIGS=true; REMOVE_PACKAGES=true; RESTORE_BACKUP=true ;;
    esac
done

log_info "=== Portable Zsh Configuration Uninstaller ==="

# Find most recent backup
BACKUP_DIR=$(ls -td ~/zsh-config-backup-* 2>/dev/null | head -1)

if [ -n "$BACKUP_DIR" ]; then
    log_info "Found backup: $BACKUP_DIR"
fi

# Restore backup if requested
if [ "$RESTORE_BACKUP" = true ] && [ -n "$BACKUP_DIR" ]; then
    if prompt_yes_no "Restore from backup: $BACKUP_DIR?"; then
        if [ -f "$BACKUP_DIR/.zshrc" ]; then
            cp "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
            log_success "Restored .zshrc"
        fi
        if [ -f "$BACKUP_DIR/.p10k.zsh" ]; then
            cp "$BACKUP_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
            log_success "Restored .p10k.zsh"
        fi
        if [ -f "$BACKUP_DIR/.zshenv" ]; then
            cp "$BACKUP_DIR/.zshenv" "$HOME/.zshenv"
            log_success "Restored .zshenv"
        fi
        if [ -f "$BACKUP_DIR/.tmux.conf" ]; then
            cp "$BACKUP_DIR/.tmux.conf" "$HOME/.tmux.conf"
            log_success "Restored .tmux.conf"
        fi
        if [ -f "$BACKUP_DIR/.ssh_rc" ]; then
            cp "$BACKUP_DIR/.ssh_rc" "$HOME/.ssh/rc"
            log_success "Restored .ssh/rc"
        fi
    fi
fi

# Remove symlinks
log_info "Removing configuration symlinks..."
[ -L "$HOME/.zshrc" ] && rm "$HOME/.zshrc" && log_success "Removed .zshrc symlink"
[ -L "$HOME/.p10k.zsh" ] && rm "$HOME/.p10k.zsh" && log_success "Removed .p10k.zsh symlink"
[ -L "$HOME/.zshenv" ] && rm "$HOME/.zshenv" && log_success "Removed .zshenv symlink"
[ -L "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf" && log_success "Removed .tmux.conf symlink"

# Remove configs if requested
if [ "$REMOVE_CONFIGS" = true ]; then
    if prompt_yes_no "Remove Oh My Zsh directory?"; then
        rm -rf "$HOME/.oh-my-zsh"
        log_success "Removed Oh My Zsh"
    fi

    if prompt_yes_no "Remove FZF?"; then
        rm -rf "$HOME/.fzf"
        rm -f "$HOME/.fzf.zsh" "$HOME/.fzf.bash" 2>/dev/null || true
        log_success "Removed FZF"
    fi

    if prompt_yes_no "Remove custom plugins?"; then
        rm -rf "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
        rm -rf "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
        rm -rf "$HOME/.oh-my-zsh/custom/plugins/z"
        log_success "Removed custom plugins"
    fi

    if prompt_yes_no "Remove Powerlevel10k?"; then
        rm -rf "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        log_success "Removed Powerlevel10k"
    fi

    if prompt_yes_no "Remove SSH rc?"; then
        rm -f "$HOME/.ssh/rc"
        log_success "Removed .ssh/rc"
    fi
fi

# Remove packages if requested
if [ "$REMOVE_PACKAGES" = true ]; then
    if prompt_yes_no "Remove installed packages?"; then
        source scripts/detect_os.sh
        case "$PACKAGE_MANAGER" in
            brew)
                if prompt_yes_no "Remove tmux?"; then
                    brew uninstall tmux
                    log_success "Removed tmux"
                fi
                if prompt_yes_no "Remove fzf?"; then
                    brew uninstall fzf
                    log_success "Removed fzf"
                fi
                ;;
            apt)
                if prompt_yes_no "Remove tmux?"; then
                    sudo apt remove -y tmux
                    log_success "Removed tmux"
                fi
                if prompt_yes_no "Remove fzf?"; then
                    sudo apt remove -y fzf
                    log_success "Removed fzf"
                fi
                ;;
            dnf|yum)
                if prompt_yes_no "Remove tmux?"; then
                    sudo dnf remove -y tmux 2>/dev/null || sudo yum remove -y tmux
                    log_success "Removed tmux"
                fi
                if prompt_yes_no "Remove fzf?"; then
                    sudo dnf remove -y fzf 2>/dev/null || sudo yum remove -y fzf
                    log_success "Removed fzf"
                fi
                ;;
            pacman)
                if prompt_yes_no "Remove tmux?"; then
                    sudo pacman -Rns --noconfirm tmux
                    log_success "Removed tmux"
                fi
                if prompt_yes_no "Remove fzf?"; then
                    sudo pacman -Rns --noconfirm fzf
                    log_success "Removed fzf"
                fi
                ;;
        esac
    fi
fi

# Ask about cleanup
if prompt_yes_no "Remove all backups?"; then
    rm -rf ~/zsh-config-backup-*
    log_success "Removed all backups"
fi

cat << EOF
${GREEN}
╔════════════════════════════════════════════════════════════╗
║                    Uninstall Complete!                             ║
╚════════════════════════════════════════════════════════════╝${NC}

${CYAN}Notes:${NC}
- If you restored a backup, you may need to reconfigure your shell
- To change your default shell back to bash: ${YELLOW}chsh -s $(which bash)${NC}
- Backups were kept unless you chose to remove them

${CYAN}Documentation:${NC}
- Uninstall options: ${YELLOW}./uninstall.sh --help${NC}
- Reinstall:        ${YELLOW}cd ~/zsh-config && ./install.sh${NC}
EOF
