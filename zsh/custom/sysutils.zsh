# System Utilities Aliases

# Disk usage - prefer ncdu > dust > du
if command -v ncdu &>/dev/null; then
    alias duf='ncdu'
elif command -v dust &>/dev/null; then
    alias duf='dust'
fi

# Cat alternatives - prefer bat > cat
if command -v bat &>/dev/null; then
    alias cat='bat'
    alias catp='bat --paging=never'
    alias catn='bat --paging=never'
elif command -v batcat &>/dev/null; then
    # Debian/Ubuntu installs bat as batcat
    alias cat='batcat'
    alias catp='batcat --paging=never'
    alias bat='batcat'
fi

# Find alternatives - prefer fd > find
if command -v fd &>/dev/null; then
    alias find='fd'
    alias ffind='fd'
elif command -v fdfind &>/dev/null; then
    # Debian/Ubuntu installs fd as fdfind
    alias fd='fdfind'
    alias ffind='fdfind'
fi

# Grep alternatives - prefer rg > grep
if command -v rg &>/dev/null; then
    alias grep='rg'
    alias rgrep='rg'
fi

# ls alternatives - eza (modern exa fork)
if command -v eza &>/dev/null; then
    alias eza='eza'
fi

# Modern utilities aliases
alias ping='ping -c 5'                    # Limit ping count
alias ports='ss -tulanp'                  # Show listening ports
alias mem='free -h'                       # Memory usage
alias cpu='lscpu'                         # CPU info
alias temp='sensors 2>/dev/null || echo "sensors not installed"'  # Temperature

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
alias psmem='ps aux --sort=-%mem | head -20'   # Top memory consumers
alias pscpu='ps aux --sort=-%cpu | head -20'   # Top CPU consumers

# Install tldr hint if missing
if ! command -v tldr &>/dev/null; then
    alias tldr='echo "Install tldr: npm install -g tldr-client && tldr-client completions install" 1>&2'
fi
