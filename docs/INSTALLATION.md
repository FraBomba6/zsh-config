# Installation Guide

This guide provides detailed information about the installation process.

## Prerequisites

Before installing, ensure you have:

- A package manager installed:
  - **macOS**: Homebrew
  - **Linux**: apt, dnf, yum, or pacman
  - **Windows (WSL)**: apt (Ubuntu/Debian)
- Internet connection for downloading packages
- Sudo/administrator privileges (for system package installation)

## Quick Installation

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/zsh-config.git ~/zsh-config
cd ~/zsh-config

# Run the installer
./install.sh
```

## Installation Steps

### 1. OS Detection

The installer automatically detects:
- Operating system (macOS, Linux, Windows)
- Package manager (brew, apt, dnf, yum, pacman)
- Installed components (zsh, git, curl, etc.)

### 2. Backup Creation

Before making changes, the installer creates a timestamped backup:

```
~/.zsh-config-backup-20250204_123456/
├── .zshrc
├── .p10k.zsh
├── .zshenv
└── .tmux.conf
```

You can restore from this backup anytime:
```bash
cd ~/zsh-config
./uninstall.sh --restore-backup
```

### 3. Interactive Configuration

The installer prompts you to configure optional features:

#### Install tmux?
- Installs tmux terminal multiplexer
- Configures sensible defaults

#### Auto-start tmux on SSH?
- Creates `~/.ssh/rc` script
- Automatically attaches/creates tmux session on SSH
- Prevents nested sessions

#### Install colorls?
- Checks for Ruby/gem
- Installs `colorls` gem
- Creates enhanced `ls` and `la` aliases
- Falls back to system `ls` if unavailable

#### Install Miniforge/Conda?
- Downloads Miniforge installer
- Installs to `~/miniforge3`
- Sets up Python environment management

### 4. Dependency Installation

Core dependencies installed automatically:
- **zsh**: Z shell
- **git**: Version control
- **curl**: HTTP client
- **ruby/gem**: For colorls
- **build tools**: For fzf compilation (on Linux)

### 5. Oh My Zsh Setup

- Downloads latest Oh My Zsh
- Installs to `~/.oh-my-zsh`
- Clones Powerlevel10k theme
- Sets up custom plugins directory

### 6. Plugin Installation

Automatically installs:

- **zsh-autosuggestions**: Fish-like command suggestions
- **zsh-syntax-highlighting**: Command syntax coloring
- **fzf**: Fuzzy finder with key bindings
- **z**: Smart directory jumper

### 7. Configuration Setup

Creates symlinks for easy updates:
```bash
~/.zshrc          -> ~/zsh-config/zsh/.zshrc
~/.p10k.zsh        -> ~/zsh-config/zsh/.p10k.zsh
~/.zshenv         -> ~/zsh-config/zsh/.zshenv
~/.tmux.conf      -> ~/zsh-config/tmux/.tmux.conf
```

### 8. Shell Change

Automatically changes default shell to zsh:
```bash
chsh -s $(which zsh)
```

**Note**: You must logout and login again for the change to take effect.

## Post-Installation

### 1. Reload Your Shell

If you don't want to logout/relogin:
```bash
source ~/.zshrc
```

Or simply open a new terminal window.

### 2. Configure Powerlevel10k Theme

Run the interactive configuration wizard:
```bash
p10k configure
```

This lets you customize:
- Prompt style (classic, rainbow, lean)
- Icons (powerline, unicode, nerd font)
- Colors and segments
- Transient prompt
- And much more!

### 3. Verify Installation

Check that everything is working:
```bash
# Check zsh version
zsh --version

# Check Oh My Zsh
ls ~/.oh-my-zsh

# Check plugins
ls ~/.oh-my-zsh/custom/plugins

# Check fzf
which fzf

# Check theme
ls ~/.oh-my-zsh/custom/themes/powerlevel10k
```

## Manual Installation

If the automated installer fails, you can install components manually:

### Install Oh My Zsh

```bash
# Using curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Using wget
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O-)"
```

### Install Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
```

### Install Plugins

```bash
cd ~/.oh-my-zsh/custom/plugins

# autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git

# syntax highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git

# z (directory jumper)
git clone --depth=1 https://github.com/agkozak/zsh-z.git z
```

### Install FZF

```bash
git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion
```

### Install colorls

```bash
gem install colorls
```

### Install tmux

```bash
# macOS
brew install tmux

# Linux (apt)
sudo apt install -y tmux

# Linux (dnf)
sudo dnf install -y tmux

# Linux (pacman)
sudo pacman -S tmux
```

## Troubleshooting

### Installation Fails

1. Check package manager is installed:
   ```bash
   which brew   # macOS
   which apt    # Debian/Ubuntu
   which dnf    # Fedora
   which pacman  # Arch
   ```

2. Ensure you have internet access
3. Check you have write permissions to your home directory
4. Try running with more verbosity:
   ```bash
   bash -x install.sh
   ```

### Git Clone Fails

1. Check git is installed: `which git`
2. Test internet connection: `ping github.com`
3. Check firewall settings
4. Try using HTTPS instead of SSH

### Shell Not Changed

1. Check if zsh is installed: `which zsh`
2. Verify chsh command: `which chsh`
3. Manually change shell:
   ```bash
   chsh -s $(which zsh)
   ```
4. Log out and log in again

### Plugins Not Loading

1. Check plugin directories:
   ```bash
   ls ~/.oh-my-zsh/custom/plugins
   ```

2. Check .zshrc file:
   ```bash
   cat ~/.zshrc | grep plugins
   ```

3. Try sourcing manually:
   ```bash
   source ~/.zshrc
   ```

## Custom Paths

The installation uses these paths:

```
~/.oh-my-zsh/              # Oh My Zsh directory
~/.oh-my-zsh/custom/     # Custom plugins and themes
~/.fzf/                    # Fuzzy finder
~/.zshrc                   # Main configuration (symlink)
~/.p10k.zsh                 # Powerlevel10k config (symlink)
~/.zshenv                  # Environment variables (symlink)
~/.tmux.conf                # Tmux configuration (symlink)
~/.ssh/rc                   # SSH integration script
~/zsh-config/               # This repository (for updates)
```

## Next Steps

- [Update your configuration](CUSTOMIZATION.md)
- [Troubleshoot issues](TROUBLESHOOTING.md)
- [Explore the README](../README.md)
