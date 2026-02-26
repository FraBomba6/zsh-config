#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

log_info() {
    echo -e "\033[0;36m[INFO]\033[0m $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [ -z "$OS_NAME" ] || [ -z "$PACKAGE_MANAGER" ]; then
    echo "Error: OS_NAME and PACKAGE_MANAGER must be set"
    echo "Run: source scripts/detect_os.sh"
    return 1 2>/dev/null || exit 1
fi

install_via_package_manager() {
    local package_name="$1"
    local alt_name="$2"
    
    case "$PACKAGE_MANAGER" in
        brew)
            brew install "$package_name" && return 0
            ;;
        apt)
            sudo apt update
            sudo apt install -y "${alt_name:-$package_name}" && return 0
            ;;
        dnf)
            sudo dnf install -y "${alt_name:-$package_name}" && return 0
            ;;
        yum)
            sudo yum install -y "${alt_name:-$package_name}" && return 0
            ;;
        pacman)
            sudo pacman -S --noconfirm "${alt_name:-$package_name}" && return 0
            ;;
    esac
    return 1
}

install_from_github() {
    local repo="$1"
    local binary="$2"
    local version="${3:-latest}"
    
    local arch
    case "$(uname -m)" in
        x86_64) arch="x86_64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) log_error "Unsupported architecture: $(uname -m)"; return 1 ;;
    esac
    
    local os
    case "$OS_NAME" in
        macos) os="macos" ;;
        linux) os="linux" ;;
        *) log_error "Unsupported OS: $OS_NAME"; return 1 ;;
    esac
    
    local download_url
    if [ "$version" = "latest" ]; then
        download_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | \
            grep "browser_download_url" | \
            grep -E "${os}.*${arch}|${arch}.*${os}" | \
            head -1 | cut -d'"' -f4)
    else
        download_url="https://github.com/$repo/releases/download/$version"
    fi
    
    if [ -z "$download_url" ]; then
        log_error "Could not find download URL for $repo"
        return 1
    fi
    
    local tmp_dir=$(mktemp -d)
    local filename=$(basename "$download_url")
    
    log_info "Downloading $filename..."
    curl -L "$download_url" -o "$tmp_dir/$filename"
    
    cd "$tmp_dir"
    
    if [[ "$filename" == *.tar.gz ]]; then
        tar -xzf "$filename"
    elif [[ "$filename" == *.zip ]]; then
        unzip -q "$filename"
    fi
    
    local bin_path
    if [ -f "$binary" ]; then
        bin_path="$binary"
    else
        bin_path=$(find . -type f -name "$binary" -o -type f -executable | head -1)
    fi
    
    if [ -z "$bin_path" ]; then
        log_error "Could not find binary $binary in archive"
        cd - > /dev/null
        rm -rf "$tmp_dir"
        return 1
    fi
    
    chmod +x "$bin_path"
    sudo mv "$bin_path" "/usr/local/bin/$binary"
    
    cd - > /dev/null
    rm -rf "$tmp_dir"
    
    log_success "$binary installed from GitHub releases"
    return 0
}

install_bat() {
    log_info "Installing bat..."
    if install_via_package_manager "bat"; then
        log_success "bat installed via $PACKAGE_MANAGER"
        return 0
    fi
    
    log_warn "Package manager install failed, trying GitHub releases..."
    install_from_github "sharkdp/bat" "bat" && return 0
    return 1
}

install_fd() {
    log_info "Installing fd..."
    local apt_name="fd-find"
    if install_via_package_manager "fd" "$apt_name"; then
        if [ "$PACKAGE_MANAGER" = "apt" ]; then
            mkdir -p ~/.local/bin
            ln -sf "$(which fdfind)" ~/.local/bin/fd 2>/dev/null || true
        fi
        log_success "fd installed via $PACKAGE_MANAGER"
        return 0
    fi
    
    log_warn "Package manager install failed, trying GitHub releases..."
    install_from_github "sharkdp/fd" "fd" && return 0
    return 1
}

install_ripgrep() {
    log_info "Installing ripgrep..."
    if install_via_package_manager "ripgrep"; then
        log_success "ripgrep installed via $PACKAGE_MANAGER"
        return 0
    fi
    
    log_warn "Package manager install failed, trying GitHub releases..."
    install_from_github "BurntSushi/ripgrep" "rg" && return 0
    return 1
}

install_btop() {
    log_info "Installing btop..."
    if install_via_package_manager "btop"; then
        log_success "btop installed via $PACKAGE_MANAGER"
        return 0
    fi
    
    log_warn "Package manager install failed, trying GitHub releases..."
    install_from_github "aristocratos/btop" "btop" && return 0
    return 1
}

install_eza() {
    log_info "Installing eza..."
    if install_via_package_manager "eza"; then
        log_success "eza installed via $PACKAGE_MANAGER"
        return 0
    fi
    
    log_warn "Package manager install failed, trying GitHub releases..."
    install_from_github "eza-community/eza" "eza" && return 0
    return 1
}

install_tldr() {
    log_info "Installing tldr..."

    if command -v tldr &>/dev/null; then
        log_success "tldr is already installed"
        return 0
    fi

    case "$PACKAGE_MANAGER" in
        brew)
            brew install tldr && log_success "tldr installed via brew" && return 0
            ;;
        pacman)
            sudo pacman -S --noconfirm tldr && log_success "tldr installed via pacman" && return 0
            ;;
    esac

    # Preferred: pipx (installs to ~/.local/bin, no sudo needed)
    if command -v pipx &>/dev/null; then
        pipx install tldr && log_success "tldr installed via pipx" && return 0
    fi

    # Fallback: pip --user (also installs to ~/.local/bin, no sudo needed)
    if command -v pip3 &>/dev/null; then
        pip3 install --user tldr && log_success "tldr installed via pip3" && return 0
    elif command -v pip &>/dev/null; then
        pip install --user tldr && log_success "tldr installed via pip" && return 0
    fi

    log_warn "Could not install tldr. Install manually: pipx install tldr"
    return 1
}

install_tldr() {
    log_info "Installing tldr..."

    if command -v tldr &>/dev/null; then
        log_success "tldr is already installed"
        return 0
    fi

    case "$PACKAGE_MANAGER" in
        brew)
            brew install tldr && log_success "tldr installed via brew" && return 0
            ;;
        pacman)
            sudo pacman -S --noconfirm tldr && log_success "tldr installed via pacman" && return 0
            ;;
    esac

    # For all other package managers: ensure npm is available, then install via npm
    if ! command -v npm &>/dev/null; then
        install_node || { log_warn "Could not install tldr. Install manually: npm install -g tldr-client"; return 1; }
    fi

    NPM_CONFIG_PREFIX="$HOME/.local" npm install -g tldr && log_success "tldr installed via npm" && return 0

    log_warn "Could not install tldr. Install manually: NPM_CONFIG_PREFIX=\"\$HOME/.local\" npm install -g tldr"
    return 1
}

FAILED_TOOLS=""

[ "$INSTALL_BAT" = "true" ] && { install_bat || FAILED_TOOLS="$FAILED_TOOLS bat"; }
[ "$INSTALL_FD" = "true" ] && { install_fd || FAILED_TOOLS="$FAILED_TOOLS fd"; }
[ "$INSTALL_RIPGREP" = "true" ] && { install_ripgrep || FAILED_TOOLS="$FAILED_TOOLS ripgrep"; }
[ "$INSTALL_BTOP" = "true" ] && { install_btop || FAILED_TOOLS="$FAILED_TOOLS btop"; }
[ "$INSTALL_EZA" = "true" ] && { install_eza || FAILED_TOOLS="$FAILED_TOOLS eza"; }
[ "$INSTALL_TLDR" = "true" ] && { install_tldr || FAILED_TOOLS="$FAILED_TOOLS tldr"; }

if [ -n "$FAILED_TOOLS" ]; then
    log_warn "Failed to install:$FAILED_TOOLS"
    log_warn "You may need to install these manually"
fi

log_success "Modern tools installation complete"
