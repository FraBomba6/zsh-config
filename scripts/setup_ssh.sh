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

SSH_DIR="$HOME/.ssh"
RC_FILE="$SSH_DIR/rc"

mkdir -p "$SSH_DIR"

cat << 'EOF' > "$RC_FILE"
#!/bin/bash

# Auto-start tmux on SSH connections
# This script checks if already inside tmux before starting a new session

if [ -z "$TMUX" ] && [ -z "$SSH_TTY" ]; then
    # Check if tmux is installed
    if command -v tmux &>/dev/null; then
        # Try to attach to existing session or create new one
        tmux attach-session -t main 2>/dev/null || tmux new-session -s main
    fi
fi
EOF

chmod +x "$RC_FILE"
log_success "SSH tmux integration configured at $RC_FILE"
log_info "Tmux will auto-start on SSH connections when enabled"
