# Customization Guide

This guide helps you customize your Zsh configuration to fit your needs.

## Configuration Files Structure

```
~/zsh-config/zsh/
├── .zshrc                 # Main configuration (symlinked to ~/.zshrc)
├── .p10k.zsh              # Powerlevel10k theme config (symlinked to ~/.p10k.zsh)
├── .zshenv                # Environment variables (symlinked to ~/.zshenv)
└── custom/                 # Custom configurations
    ├── aliases.zsh           # Command aliases
    ├── paths.zsh            # PATH additions
    ├── functions.zsh        # Custom functions
    ├── fzf.zsh            # FZF configuration
    ├── colorls.zsh         # colorls integration
    └── docker.zsh          # Docker aliases
```

## Aliases

### Adding Custom Aliases

Edit `zsh/custom/aliases.zsh`:

```zsh
# Your custom alias
alias myproject="cd ~/projects/myproject"

# Git workflow alias
alias gpushmain='git checkout main && git pull && git push'

# Development aliases
alias serve="python -m http.server 8000"
alias npmstart="npm run dev"
```

### Removing Default Aliases

Comment out or delete lines in `zsh/custom/aliases.zsh`:

```zsh
# Don't like this alias? Comment it out
# alias ls='colorls'
```

### Git Aliases

Beyond Oh My Zsh's built-in aliases, these are provided:

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit -m` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gco` | `git checkout` |
| `gbr` | `git branch` |
| `glog` | `git log --oneline --decorate --graph` |

## PATH Management

### Adding Custom Paths

Edit `zsh/custom/paths.zsh`:

```zsh
# Add local bin directory
export PATH="$HOME/mybin:$PATH"

# Add specific tool
export PATH="/opt/mytool/bin:$PATH"

# Add Python user packages
export PATH="$HOME/.local/bin:$PATH"

# Add Go modules
export PATH="$HOME/go/bin:$PATH"
```

### Conditional PATH Addition

Only add path if directory exists:

```zsh
# Only add if directory exists
if [ -d "/opt/optional-tool" ]; then
  export PATH="/opt/optional-tool/bin:$PATH"
fi
```

## Custom Functions

### Creating Functions

Edit `zsh/custom/functions.zsh`:

```zsh
# Quick project creation
mkproject() {
  mkdir -p "$HOME/projects/$1"
  cd "$HOME/projects/$1"
  git init
  echo "# $1" > README.md
}

# Search and replace
searchreplace() {
  grep -rl "$1" . | xargs sed -i "s/$1/$2/g"
}

# Quick note
note() {
  echo "$1" >> ~/notes.txt
}
```

### Available Built-in Functions

From `zsh/custom/functions.zsh`:

| Function | Description |
|----------|-------------|
| `mkcd` | Create directory and cd into it |
| `extract` | Extract any archive format |
| `backup` | Quick backup of file with timestamp |
| `dusort` | Show directory sizes sorted |
| `psgrep` | Search for running processes |
| `pskill` | Kill process by name |
| `weather` | Show weather for city |
| `myip` | Show public and local IP |
| `genpass` | Generate random password |
| `diskusage` | Show disk usage |

## Powerlevel10k Theme

### Basic Customization

Run the configuration wizard:
```bash
p10k configure
```

### Manual Configuration

Edit `~/.p10k.zsh` directly:

```zsh
# Change prompt style
typeset -g POWERLEVEL9K_MODE=nerdfont-v3

# Change segment order
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon
  dir
  vcs
  newline
  prompt_char
)

# Enable transient prompt (shows just symbol after commands)
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
```

### Popular Customizations

**Show time on right prompt:**
```zsh
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  time
)
```

**Hide context unless SSH or sudo:**
```zsh
typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
```

**Custom colors:**
```zsh
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
typeset -g POWERLEVEL9K_VCS_FOREGROUND=76
```

## FZF Configuration

### Custom Options

Edit `zsh/custom/fzf.zsh`:

```zsh
# Change preview window height
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse'

# Use different search strategy
export FZF_DEFAULT_COMMAND='fd --type f --hidden'

# Set preview command
export FZF_CTRL_T_OPTS="--preview 'cat {} | head -50'"
```

### FZF Functions

Already provided in `zsh/custom/fzf.zsh`:

- `fo` - Find and open file with fzf
- `fcd` - Find and cd to directory with fzf
- `fkill` - Kill process with fzf
- `fbr` - Git branch checkout with fzf
- `fshow` - Git commit browser with fzf

### Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Search files |
| `Alt+C` | Search directories |
| `Enter` | Accept selection |
| `Tab` | Toggle selection |
| `Ctrl+K` | Move selection up |
| `Ctrl+J` | Move selection down |

## Z (Directory Jumper)

### Basic Usage

```bash
# Jump to frequently used directory
z project

# Jump with partial match
z proj

# List all tracked directories
z -l
```

### Database Management

```bash
# Add current directory manually
z -a ./

# Remove directory
z -e ~/old/project

# Clean database (remove non-existent paths)
z -c
```

## Tmux Configuration

### Editing Tmux Config

Edit `~/zsh-config/tmux/.tmux.conf` (symlinked to `~/.tmux.conf`):

```conf
# Change prefix from Ctrl+Space to Ctrl+a
unbind C-Space
set -g prefix C-a

# Disable mouse
set -g mouse off

# Change status bar colors
set -g status-style 'bg=#000000 fg=#ffffff'

# Change window numbering to start at 1
set -g base-index 1
```

### Useful Tmux Commands

| Command | Description |
|---------|-------------|
| `Ctrl+Space c` | Create new window |
| `Ctrl+Space n` | Switch to next window |
| `Ctrl+Space p` | Switch to previous window |
| `Ctrl+Space |` | Split window vertically |
| `Ctrl+Space -` | Split window horizontally |
| `Ctrl+Space h/j/k/l` | Navigate panes vim-style |
| `Ctrl+Space m` | Maximize pane |
| `Ctrl+Space z` | Toggle pane zoom |
| `Prefix :` | Command mode |

## Docker Configuration

### Custom Docker Aliases

Edit `zsh/custom/docker.zsh`:

```zsh
# Add your own docker workflows
alias ddev='docker compose -f docker-compose.dev.yml up -d'
alias dprod='docker compose -f docker-compose.prod.yml up -d'
```

### Docker Functions Provided

From `zsh/custom/docker.zsh`:

| Function | Description |
|----------|-------------|
| `docker_ip` | Get container IP address |
| `dshell <container>` | Enter container shell |
| `dlogs <container>` | View container logs |
| `drun` | Run temporary container |
| `dcrebuild` | Rebuild and restart compose |
| `drmall` | Remove all stopped containers |

## Conditional Loading

### Load Configs Only When Needed

Create conditional blocks in `.zshrc`:

```zsh
# Only load Docker config if Docker is installed
if command -v docker &>/dev/null; then
  source "$ZSH_CUSTOM_DIR/docker.zsh"
fi

# Only load Node.js tools if Node.js is installed
if command -v node &>/dev/null; then
  # Load Node-specific configurations
fi
```

### Platform-Specific Configs

```zsh
# macOS-specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS-specific aliases and functions
  alias brewup='brew update && brew upgrade'
fi

# Linux-specific
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  # Linux-specific aliases and functions
  alias pbcopy='xclip -selection clipboard'
fi
```

## Oh My Zsh Plugins

### Managing Plugins

Edit `plugins` array in `zsh/.zshrc`:

```zsh
plugins=(
  git              # Built-in
  docker           # Built-in
  gh               # Built-in
  wd               # Warp directory
  tmux             # Tmux integration
  ssh              # SSH integration
  # Add or remove here
)
```

### Adding Custom Oh My Zsh Plugins

```bash
# Clone plugin to custom directory
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/user/plugin-name.git

# Add to plugins array in .zshrc
# plugins=(... plugin-name)

# Reload shell
source ~/.zshrc
```

### Popular Oh My Zsh Plugins

Built-in plugins already included:
- `git` - Git aliases and completion
- `docker` - Docker completion
- `gh` - GitHub CLI completion
- `colored-man-pages` - Colors in man pages
- `history-substring-search` - Search history by substring

Other useful built-in plugins:
- `npm` - npm completion
- `yarn` - Yarn completion
- `pip` - pip completion
- `python` - Python completion
- `rust` - Rust toolchain
- `golang` - Go language
- `kubectl` - Kubernetes
- `aws` - AWS CLI

## Testing Changes

### Safe Testing

Before making changes permanent:

```bash
# Test in subshell
(zsh)
# Make changes
# Exit when done
```

### Reload Configuration

After editing configuration files:

```bash
source ~/.zshrc
```

Or restart your terminal.

### Debug Mode

Enable debug mode to see loading order:

```bash
zsh -x
```

This shows every line as it's executed.

## Updating Customizations

After making changes:

```bash
cd ~/zsh-config
git add .
git commit -m "Customize configuration"
git push
```

Your changes will be preserved when running `./update.sh`.

## Advanced Topics

### Zsh Completion

Customize completion behavior:

```zsh
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Group completions by type
zstyle ':completion:*' group-name ''

# Colorize completions
zstyle ':completion:*:default' list-colors ''
```

### History Management

Adjust history settings in `zsh/.zshenv`:

```zsh
# Increase history size
export HISTSIZE=50000
export SAVEHIST=50000

# Ignore duplicates
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

# Share history across sessions
setopt SHARE_HISTORY
```

### Prompt Engineering

Create a completely custom prompt:

```zsh
# Simple prompt in .zshrc
PROMPT='%F{cyan}%n%f@%F{green}%m%f:%F{blue}%1~%f %# '

# Git-aware prompt
PROMPT='%F{cyan}%~%f $(git_prompt_string) %# '
```

## Next Steps

- [Troubleshoot issues](TROUBLESHOOTING.md)
- [Update configurations](../update.sh)
- [Read installation guide](INSTALLATION.md)
