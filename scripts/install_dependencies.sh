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

if [ -z "$OS_NAME" ] || [ -z "$PACKAGE_MANAGER" ]; then
    echo "Error: OS_NAME and PACKAGE_MANAGER must be set"
    echo "Run: source scripts/detect_os.sh"
    exit 1
fi

log_info "Installing core dependencies for $OS_NAME with $PACKAGE_MANAGER..."

case "$OS_NAME" in
    macos)
        if ! command -v brew &>/dev/null; then
            log_error "Homebrew is required for macOS installation"
            echo "Please install it from: https://brew.sh"
            exit 1
        fi

        if ! command -v zsh &>/dev/null; then
            log_info "Installing zsh via Homebrew..."
            brew install zsh
            log_success "zsh installed"
        fi

        if ! command -v git &>/dev/null; then
            log_info "Installing git via Homebrew..."
            brew install git
            log_success "git installed"
        fi

        if ! command -v curl &>/dev/null; then
            log_info "Installing curl via Homebrew..."
            brew install curl
            log_success "curl installed"
        fi

        if ! command -v ruby &>/dev/null; then
            log_info "Installing ruby via Homebrew..."
            brew install ruby
            log_success "ruby installed"
        fi

        brew install coreutils gnu-sed
        ;;

    linux)
        case "$PACKAGE_MANAGER" in
            apt)
                sudo apt update

                if ! command -v zsh &>/dev/null; then
                    log_info "Installing zsh..."
                    sudo apt install -y zsh
                    log_success "zsh installed"
                fi

                if ! command -v git &>/dev/null; then
                    log_info "Installing git..."
                    sudo apt install -y git
                    log_success "git installed"
                fi

                if ! command -v curl &>/dev/null; then
                    log_info "Installing curl..."
                    sudo apt install -y curl
                    log_success "curl installed"
                fi

                if ! command -v ruby &>/dev/null; then
                    log_info "Installing ruby..."
                    sudo apt install -y ruby-full
                    log_success "ruby installed"
                fi

                sudo apt install -y build-essential fzf ripgrep bat
                ;;

            dnf)
                if ! command -v zsh &>/dev/null; then
                    log_info "Installing zsh..."
                    sudo dnf install -y zsh
                    log_success "zsh installed"
                fi

                if ! command -v git &>/dev/null; then
                    log_info "Installing git..."
                    sudo dnf install -y git
                    log_success "git installed"
                fi

                if ! command -v curl &>/dev/null; then
                    log_info "Installing curl..."
                    sudo dnf install -y curl
                    log_success "curl installed"
                fi

                if ! command -v ruby &>/dev/null; then
                    log_info "Installing ruby..."
                    sudo dnf install -y ruby
                    log_success "ruby installed"
                fi

                sudo dnf install -y gcc make fzf ripgrep
                ;;

            yum)
                if ! command -v zsh &>/dev/null; then
                    log_info "Installing zsh..."
                    sudo yum install -y zsh
                    log_success "zsh installed"
                fi

                if ! command -v git &>/dev/null; then
                    log_info "Installing git..."
                    sudo yum install -y git
                    log_success "git installed"
                fi

                if ! command -v curl &>/dev/null; then
                    log_info "Installing curl..."
                    sudo yum install -y curl
                    log_success "curl installed"
                fi

                if ! command -v ruby &>/dev/null; then
                    log_info "Installing ruby..."
                    sudo yum install -y ruby
                    log_success "ruby installed"
                fi

                sudo yum install -y gcc make fzf ripgrep
                ;;

            pacman)
                if ! command -v zsh &>/dev/null; then
                    log_info "Installing zsh..."
                    sudo pacman -S --noconfirm zsh
                    log_success "zsh installed"
                fi

                if ! command -v git &>/dev/null; then
                    log_info "Installing git..."
                    sudo pacman -S --noconfirm git
                    log_success "git installed"
                fi

                if ! command -v curl &>/dev/null; then
                    log_info "Installing curl..."
                    sudo pacman -S --noconfirm curl
                    log_success "curl installed"
                fi

                if ! command -v ruby &>/dev/null; then
                    log_info "Installing ruby..."
                    sudo pacman -S --noconfirm ruby
                    log_success "ruby installed"
                fi

                sudo pacman -S --noconfirm base-devel fzf ripgrep bat
                ;;

            *)
                log_warn "Unsupported package manager: $PACKAGE_MANAGER"
                log_warn "Please install zsh, git, curl, and ruby manually"
                ;;
        esac
        ;;

    windows)
        case "$PACKAGE_MANAGER" in
            apt)
                log_info "Updating apt packages..."
                sudo apt update

                if ! command -v zsh &>/dev/null; then
                    log_info "Installing zsh..."
                    sudo apt install -y zsh
                    log_success "zsh installed"
                fi

                if ! command -v git &>/dev/null; then
                    log_info "Installing git..."
                    sudo apt install -y git
                    log_success "git installed"
                fi

                if ! command -v curl &>/dev/null; then
                    log_info "Installing curl..."
                    sudo apt install -y curl
                    log_success "curl installed"
                fi

                if ! command -v ruby &>/dev/null; then
                    log_info "Installing ruby..."
                    sudo apt install -y ruby-full
                    log_success "ruby installed"
                fi

                sudo apt install -y build-essential fzf ripgrep bat
                ;;

            *)
                log_warn "Unsupported package manager for Windows: $PACKAGE_MANAGER"
                ;;
        esac
        ;;
esac

log_success "Core dependencies installed successfully"
