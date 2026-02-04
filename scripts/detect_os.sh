#!/bin/bash

OS_NAME="unknown"
PACKAGE_MANAGER="unknown"

case "$(uname -s)" in
    Darwin*)
        OS_NAME="macos"
        if command -v brew &>/dev/null; then
            PACKAGE_MANAGER="brew"
        else
            echo "Homebrew not found. Please install it first:"
            echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
        ;;
    Linux*)
        OS_NAME="linux"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian)
                    if command -v apt &>/dev/null; then
                        PACKAGE_MANAGER="apt"
                    fi
                    ;;
                fedora|rhel|centos)
                    if command -v dnf &>/dev/null; then
                        PACKAGE_MANAGER="dnf"
                    elif command -v yum &>/dev/null; then
                        PACKAGE_MANAGER="yum"
                    fi
                    ;;
                arch|manjaro|endeavouros)
                    if command -v pacman &>/dev/null; then
                        PACKAGE_MANAGER="pacman"
                    fi
                    ;;
                *)
                    echo "Warning: Unknown Linux distribution: $ID"
                    ;;
            esac
        fi

        if [ "$PACKAGE_MANAGER" = "unknown" ]; then
            echo "Error: Could not determine package manager for your Linux distribution"
            exit 1
        fi
        ;;
    MINGW*|MSYS*|CYGWIN*)
        OS_NAME="windows"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian)
                    if command -v apt &>/dev/null; then
                        PACKAGE_MANAGER="apt"
                    fi
                    ;;
            esac
        fi
        ;;
    *)
        echo "Error: Unknown operating system: $(uname -s)"
        exit 1
        ;;
esac

export OS_NAME PACKAGE_MANAGER
