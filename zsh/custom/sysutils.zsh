# System Utilities Aliases

# Modern CLI tools - only set aliases if the tool is installed

# bat - modern cat replacement (with syntax highlighting)
if command -v bat &>/dev/null; then
    alias cat='bat'
    alias catp='bat --paging=never'
    alias catn='bat --paging=never'
elif command -v batcat &>/dev/null; then
    alias cat='batcat'
    alias catp='batcat --paging=never'
    alias catn='batcat --paging=never'
    alias bat='batcat'
fi

# fd - modern find replacement
if command -v fd &>/dev/null; then
    alias find='fd'
    alias ffind='fd'
elif command -v fdfind &>/dev/null; then
    alias fd='fdfind'
    alias find='fdfind'
    alias ffind='fdfind'
fi

# ripgrep (rg) - modern grep replacement
if command -v rg &>/dev/null; then
    alias grep='rg'
    alias rgrep='rg'
fi

# eza - modern ls replacement (exa fork)
# eza is available as 'eza' directly. ls/la/ll/lt aliases are handled by
# colorls.zsh (if colorls is installed) or fall back to system ls.

# Modern utilities aliases
alias ping='ping -c 5'
alias ports='ss -tulanp'
alias mem='free -h'
alias cpu='lscpu'
alias temp='sensors 2>/dev/null || echo "sensors not installed"'

# Quick system info
sysinfo() {
    echo "=== System Info ==="
    uname -a
    echo ""
    echo "=== Memory ==="
    free -h 2>/dev/null || vm_stat 2>/dev/null
    echo ""
    echo "=== Disk ==="
    df -h | grep -vE '^Filesystem|tmpfs|cdrom'
    echo ""
    echo "=== CPU ==="
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sysctl -n machdep.cpu.brand_string
    else
        grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2
    fi
}

# Process management
alias psmem='ps aux --sort=-%mem | head -20'
alias pscpu='ps aux --sort=-%cpu | head -20'
