# Portable Zsh Configuration

A fully portable, cross-platform Zsh configuration with Oh My Zsh, Powerlevel10k, useful plugins, and tmux integration.

## Features

- 🚀 **Cross-platform**: Works on macOS, Linux (Debian/Ubuntu, Fedora/CentOS, Arch), and Windows (WSL)
- 🎨 **Beautiful**: Powerlevel10k theme with instant prompt
- ⚡ **Productivity**: Includes fzf, z (directory jumper), autosuggestions, syntax highlighting
- 📦 **One-command install**: Everything configured automatically
- 🔧 **Idempotent**: Safe to run multiple times
- 💾 **Backups**: Automatic backups before overwriting
- 🔄 **Easy updates**: Simple update mechanism
- 🖥️ **Optional tmux**: Terminal multiplexer with auto-start support
- 🎨 **logo-ls**: Enhanced `ls`/`la` aliases with icons and git status (requires Nerd Fonts)

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/zsh-config.git ~/zsh-config
cd ~/zsh-config

# Run the installer
./install.sh
```

Follow the interactive prompts to customize your setup.

## Screenshots

![Powerlevel10k Theme](docs/screenshots/p10k.png)
*(Coming soon)*

## What Gets Installed

### Core Components
- **zsh**: Z shell (if not already installed)
- **Oh My Zsh**: Zsh configuration framework
- **Powerlevel10k**: Fast, feature-rich prompt theme
- **Git**: Version control (if not present)

### Plugins
- **zsh-autosuggestions**: Fish-like autosuggestions
- **zsh-syntax-highlighting**: Command syntax highlighting
- **fzf**: Fuzzy finder for files and history
- **z**: Smart directory jumper
- **Oh My Zsh plugins**: git, wd, tmux, ssh, docker, gh, colored-man-pages, history-substring-search

### Optional Components (interactive prompts)
- **tmux**: Terminal multiplexer
- **logo-ls**: Colored `ls` with file-type icons and git status (requires Nerd Fonts)
- **Miniforge/Conda**: Python environment manager

### Configurations
- `.zshrc`: Modular main configuration
- `.p10k.zsh`: Powerlevel10k theme config
- `.zshenv`: Environment variables
- `.tmux.conf`: Tmux configuration

## Installation Details

The installer will:
1. Detect your OS and package manager
2. Check for existing installations
3. Create backups of existing configs
4. Prompt you for optional components
5. Install all dependencies
6. Configure everything
7. Change your default shell to zsh
8. Prompt you to restart your shell

### OS Support

- **macOS**: Uses Homebrew
- **Debian/Ubuntu**: Uses apt
- **Fedora/CentOS**: Uses dnf/yum
- **Arch Linux**: Uses pacman
- **Windows (WSL)**: Supports WSL with apt

## Usage

### Key Aliases

```bash
# Directory navigation
ls              # Basic listing (logo-ls or system ls)
la              # Long listing with hidden files
ll              # Long listing with hidden files
lt              # Tree view (2 levels, via system `tree`)
ld              # List directory entry itself, not contents
lgs             # Long listing with git status

# System monitoring
btop            # Modern resource monitor (if installed)
htop            # Fallback system monitor

# Modern utilities
bat             # Enhanced cat with syntax highlighting (if installed)
rg              # Fast grep alternative (if installed)
fd              # Fast find alternative (if installed)
tldr            # Simplified man pages (hint if missing)
ncdu            # Fast disk usage analyzer (if installed)

# Quick system info
sysinfo         # Show CPU, memory, disk info
psmem           # Top memory consumers
pscpu           # Top CPU consumers
ports           # Show listening ports

..              # Go up one directory
...             # Go up two directories

# Git
gs              # git status
ga              # git add
gc              # git commit
gp              # git push
gl              # git pull

# Docker
d                # docker
dc               # docker-compose
dps              # docker ps
di               # docker images

# Quick access
phd              # cd ~/Desktop/phd (customize as needed)
```

### Plugin Features

**fzf (Fuzzy Finder)**
- `Ctrl+R`: Search command history
- `Ctrl+T`: Search files
- `Alt+C`: Search directories

**z (Directory Jumper)**
- `z <pattern>`: Jump to frequently used directory matching pattern
- Maintains database of visited directories automatically

**autosuggestions**
- Gray suggestions appear as you type
- Press `→` to accept suggestion
- Based on your command history

**syntax-highlighting**
- Commands are colored as you type
- Invalid commands shown in red
- Valid commands shown in green

**tmux Integration**
- Auto-starts tmux session when opening terminal (if enabled)
- Attaches to existing session or creates new one
- Prevents nested tmux sessions automatically
- Closes terminal when tmux exits (configurable)

## Customization

### Adding Custom Aliases

Edit `zsh/custom/aliases.zsh`:

```zsh
alias myproject="cd ~/projects/myproject"
alias serve="python -m http.server"
```

### Adding Custom Paths

Edit `zsh/custom/paths.zsh`:

```zsh
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
```

### Adding Custom Functions

Edit `zsh/custom/functions.zsh`:

```zsh
function mkcd() {
  mkdir -p "$1" && cd "$1"
}
```

### Changing Plugins

Edit the `plugins` array in `zsh/.zshrc`:

```zsh
plugins=(
  git
  docker
  fzf
  z
  # Add or remove plugins here
)
```

Run `./update.sh` after making changes.

## Updating

```bash
cd ~/zsh-config
git pull
./update.sh
```

This updates:
- Oh My Zsh
- All plugins
- Configurations

## Uninstalling

```bash
cd ~/zsh-config
./uninstall.sh
```

Options include:
- Remove only configurations
- Restore backups
- Remove installed packages
- Complete uninstall

## Troubleshooting

### logo-ls not working

If `ls` isn't colorized or icons appear as tofu:
```bash
# Check if logo-ls is installed and on PATH
command -v logo-ls

# Reinstall if needed (same command as update)
curl -fsSL https://raw.githubusercontent.com/canta2899/logo-ls/refs/heads/main/get.sh | sh
```

If icons appear as boxes/tofu, your terminal is not using a Nerd Font.
Install one from https://www.nerdfonts.com/font-downloads and configure
your terminal emulator to use it.

### fzf not working

```bash
# Reinstall fzf
cd ~/zsh-config
./scripts/install_fzf.sh
```

### Powerlevel10k prompt not showing

Run the configuration wizard:
```bash
p10k configure
```

### tmux not auto-starting

Check tmux plugin configuration in `~/.zshrc`:
```bash
grep ZSH_TMUX ~/.zshrc
# Should show ZSH_TMUX_AUTOSTART=true
```

### Slow shell startup

Run diagnostics:
```bash
# Check loaded plugins
zmodload zprof
zprof
```

Disable plugins you don't use in `zsh/.zshrc`.

## Configuration File

Your installation settings are stored in `~/zsh-config/config.json`:

```json
{
  "version": "1.0.0",
  "install_date": "2025-02-04",
  "os": "macos",
  "features": {
    "tmux": {
      "installed": true
    },
    "logo_ls": {
      "installed": true
    },
    "plugins": {
      "fzf": true,
      "z": true,
      "docker": true,
      "gh": true
    }
  }
}
```

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Credits

- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [fzf](https://github.com/junegunn/fzf)
- [z](https://github.com/agkozak/zsh-z)
- [logo-ls](https://github.com/canta2899/logo-ls) (maintained fork of [Yash-Handa/logo-ls](https://github.com/Yash-Handa/logo-ls))

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check the [troubleshooting guide](docs/TROUBLESHOOTING.md)
- Read the [customization guide](docs/CUSTOMIZATION.md)
