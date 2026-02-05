#!/bin/bash
set -e

BACKUP_DIR="$HOME/.zsh-config-backup-$(date +%Y%m%d_%H%M%S)"
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

mkdir -p "$BACKUP_DIR"

FILES_TO_BACKUP=(
    "$HOME/.zshrc"
    "$HOME/.p10k.zsh"
    "$HOME/.zshenv"
    "$HOME/.tmux.conf"
)

BACKUP_COUNT=0

for file in "${FILES_TO_BACKUP[@]}"; do
    if [ -f "$file" ] || [ -L "$file" ]; then
        cp -L "$file" "$BACKUP_DIR/$(basename $file)" 2>/dev/null || true
        if [ $? -eq 0 ]; then
            log_info "Backed up: $file"
            ((BACKUP_COUNT++))
        fi
    fi
done

if [ $BACKUP_COUNT -gt 0 ]; then
    log_success "Created backup at: $BACKUP_DIR"
    echo "  Backed up $BACKUP_COUNT file(s)"
else
    log_info "No existing configuration files to backup"
fi

export BACKUP_DIR
