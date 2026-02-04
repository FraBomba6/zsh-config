# Troubleshooting Guide

This guide helps you resolve common issues with the Zsh configuration.

## Table of Contents

- [General Issues](#general-issues)
- [Theme Issues](#theme-issues)
- [Plugin Issues](#plugin-issues)
- [Performance Issues](#performance-issues)
- [Integration Issues](#integration-issues)
- [OS-Specific Issues](#os-specific-issues)

## General Issues

### Zsh Not Starting

**Symptoms:**
- Shell hangs on startup
- Error messages on startup
- Falls back to bash

**Solutions:**

1. Check syntax errors:
   ```bash
   zsh -n ~/.zshrc
   ```

2. Source manually with debug output:
   ```bash
   zsh -x
   ```

3. Check file permissions:
   ```bash
   ls -la ~/.zshrc ~/.p10k.zsh
   ```

4. Temporarily disable plugins:
   ```bash
   plugins=()
   source ~/.zshrc
   ```

### Config Not Applied

**Symptoms:**
- Changes to .zshrc not visible
- New aliases don't work
- Theme doesn't update

**Solutions:**

1. Reload configuration:
   ```bash
   source ~/.zshrc
   ```

2. Check if files are symlinks:
   ```bash
   ls -la ~/.zshrc ~/.p10k.zsh ~/.zshenv
   ```

3. Verify correct files are linked:
   ```bash
   readlink ~/.zshrc
   ```

### Backups Lost

**Symptoms:**
- Need to restore from backup but backup directory is gone

**Solutions:**

1. Check all backups:
   ```bash
   ls -lt ~/zsh-config-backup-*
   ```

2. Use Git to revert changes:
   ```bash
   cd ~/zsh-config
   git log --oneline
   git checkout <commit-hash>
   ./install.sh
   ```

## Theme Issues

### Powerlevel10k Not Showing

**Symptoms:**
- Default Oh My Zsh theme instead of Powerlevel10k
- Icons not displaying
- Prompt looks wrong

**Solutions:**

1. Run configuration wizard:
   ```bash
   p10k configure
   ```

2. Check Powerlevel10k is installed:
   ```bash
   ls ~/.oh-my-zsh/custom/themes/powerlevel10k
   ```

3. Verify .p10k.zsh is loaded:
   ```bash
   cat ~/.zshrc | grep p10k
   ```

4. Check terminal supports unicode:
   ```bash
   echo $LANG
   # Should be UTF-8, e.g., en_US.UTF-8
   ```

### Icons Not Displaying

**Symptoms:**
- Question marks or boxes instead of icons
- Missing graphical elements

**Solutions:**

1. Install Nerd Font:
   - Download from: https://www.nerdfonts.com/
   - Install on macOS: Font Book → Add Font
   - Install on Linux: Copy to `~/.local/share/fonts/` and run `fc-cache -fv`

2. Check terminal font setting:
   - Set font to Nerd Font in terminal preferences
   - Common choice: "MesloLGL Nerd Font Mono"

3. Force powerline mode:
   ```bash
   p10k configure
   # Choose "Powerline" instead of "Unicode"
   ```

### Prompt Too Slow

**Symptoms:**
- Noticeable delay before prompt appears
- Typing feels sluggish

**Solutions:**

1. Disable instant prompt:
   ```bash
   # Remove these lines from .zshrc
   if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
   fi
   ```

2. Disable heavy segments:
   Edit `~/.p10k.zsh`:
   ```zsh
   # Remove or comment out segments
   typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
     os_icon
     dir
     # vcs  # Comment out to speed up
   )
   ```

3. Reduce segments:
   ```bash
   p10k configure
   # Choose "Lean" instead of "Classic"
   ```

## Plugin Issues

### Autosuggestions Not Working

**Symptoms:**
- No gray suggestions appear
- Suggestions don't match history

**Solutions:**

1. Check plugin is installed:
   ```bash
   ls ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   ```

2. Verify history is enabled:
   ```bash
   echo $HISTFILE
   # Should show a path
   ```

3. Test suggestions manually:
   ```bash
   cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   source zsh-autosuggestions.zsh
   ```

4. Adjust highlighting color:
   Add to `~/.zshrc`:
   ```zsh
   export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
   ```

### Syntax Highlighting Not Working

**Symptoms:**
- Commands not colored
- No indication of invalid commands

**Solutions:**

1. Check plugin is installed:
   ```bash
   ls ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
   ```

2. Load after zsh-autosuggestions:
   Edit `~/.zshrc`:
   ```zsh
   source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
   source $ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
   ```

3. Test highlighting:
   ```bash
   echo 'invalid_command'
   # Should appear in red
   ```

### FZF Not Working

**Symptoms:**
- Ctrl+R doesn't open fuzzy search
- fzf command not found

**Solutions:**

1. Check FZF is installed:
   ```bash
   which fzf
   ```

2. Reinstall FZF:
   ```bash
   cd ~/zsh-config
   ./scripts/install_fzf.sh
   ```

3. Check key bindings are loaded:
   ```bash
   source ~/.fzf.zsh
   ```

4. Test manually:
   ```bash
   fzf
   ```

### z (Directory Jumper) Not Working

**Symptoms:**
- `z` command not found
- Cannot jump to directories

**Solutions:**

1. Check plugin is installed:
   ```bash
   ls ~/.oh-my-zsh/custom/plugins/z
   ```

2. Initialize properly:
   ```bash
   cd ~/.oh-my-zsh/custom/plugins/z
   source z.zsh
   autoload -Uz _z && eval "$(z --init zsh)"
   ```

3. Check database exists:
   ```bash
   ls -la ~/.z
   ```

4. Rebuild database:
   ```bash
   z -c .
   ```

## Performance Issues

### Shell Starts Slowly

**Symptoms:**
- Noticeable delay before prompt appears
- Takes >2 seconds to load

**Solutions:**

1. Profile shell startup:
   ```bash
   time zsh -i -c exit
   ```

2. Use zprof for detailed profiling:
   ```bash
   # Add to top of .zshrc
   zmodload zprof

   # Add to bottom of .zshrc
   zprof
   ```

3. Disable slow plugins:
   Edit `~/.zshrc`:
   ```zsh
   plugins=(
     git
     # Comment out suspect plugins
   )
   ```

4. Remove duplicate completions:
   ```zsh
   autoload -Uz compinit
   compinit -i  # -i flag improves performance
   ```

5. Disable powerlevel10k instant prompt:
   See [Theme Issues](#prompt-too-slow)

### Command History Slow

**Symptoms:**
- Searching history is slow
- Large history file

**Solutions:**

1. Check history size:
   ```bash
   ls -lh ~/.zsh_history
   ```

2. Truncate history if too large:
   ```bash
   tail -10000 ~/.zsh_history > ~/.zsh_history.new
   mv ~/.zsh_history.new ~/.zsh_history
   ```

3. Adjust history settings in `~/.zshenv`:
   ```zsh
   export HISTSIZE=10000
   export SAVEHIST=10000
   setopt HIST_IGNORE_DUPS
   setopt HIST_EXPIRE_DUPS_FIRST
   ```

## Integration Issues

### colorls Not Working

**Symptoms:**
- `ls` shows system output, not colored
- `la` alias doesn't exist

**Solutions:**

1. Check colorls is installed:
   ```bash
   gem which colorls
   ```

2. Reinstall colorls:
   ```bash
   gem uninstall colorls
   gem install colorls
   ```

3. Check Ruby in PATH:
   ```bash
   gem env | grep EXECUTABLE
   ```

4. Manually add to PATH in `~/zsh-config/zsh/custom/paths.zsh`:
   ```zsh
   export PATH="$(gem env | grep 'EXECUTABLE DIRECTORY' | cut -d ':' -f 2 | tr -d ' '):$PATH"
   ```

5. Use fallback:
   The config automatically falls back to `ls --color=auto`

### tmux Not Auto-Starting on SSH

**Symptoms:**
- SSH doesn't automatically start tmux
- No tmux session on remote login

**Solutions:**

1. Check SSH rc file:
   ```bash
   ls -la ~/.ssh/rc
   ```

2. Verify rc is executable:
   ```bash
   chmod +x ~/.ssh/rc
   ```

3. Check rc contents:
   ```bash
   cat ~/.ssh/rc
   ```

4. Test locally:
   ```bash
   bash ~/.ssh/rc
   ```

5. Check SSH configuration:
   ```bash
   cat ~/.ssh/config
   # Ensure PermitLocalCommand is not blocking
   ```

### tmux Nested Sessions

**Symptoms:**
- tmux inside tmux
- Confusing navigation

**Solutions:**

The SSH rc script should check for existing tmux:

```bash
# ~/.ssh/rc should contain this check:
if [ -z "$TMUX" ] && [ -z "$SSH_TTY" ]; then
    tmux attach-session -t main || tmux new-session -s main
fi
```

Attach from inside tmux instead:
```bash
tmux attach-session -t main
```

### Docker Aliases Not Working

**Symptoms:**
- `d` command not found
- Docker completions missing

**Solutions:**

1. Check Docker is installed:
   ```bash
   which docker
   ```

2. Check plugin is enabled:
   ```bash
   grep plugins ~/.zshrc
   # Should include "docker"
   ```

3. Reload Oh My Zsh:
   ```bash
   source $ZSH/oh-my-zsh.sh
   ```

4. Completions:
   ```bash
   mkdir -p ~/.zsh/completions
   curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker -o ~/.zsh/completions/_docker
   ```

## OS-Specific Issues

### macOS Issues

#### Homebrew Not Found

**Symptoms:**
- `brew: command not found`
- Installation fails

**Solutions:**

1. Install Homebrew:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Check Homebrew in PATH:
   ```bash
   echo $PATH | grep homebrew
   ```

3. Add to PATH manually:
   ```zsh
   # In ~/zsh-config/zsh/custom/paths.zsh
   export PATH="/opt/homebrew/bin:$PATH"
   ```

#### Zsh Shell Change Fails

**Symptoms:**
- `chsh: /usr/local/bin/zsh: non-standard shell`
- Shell doesn't change

**Solutions:**

1. Add zsh to `/etc/shells`:
   ```bash
   echo $(which zsh) | sudo tee -a /etc/shells
   ```

2. Try again:
   ```bash
   chsh -s $(which zsh)
   ```

3. Verify:
   ```bash
   dscl . -read /Users/$USER UserShell
   ```

### Linux Issues

#### Permission Denied

**Symptoms:**
- `sudo: command not found`
- Cannot install packages

**Solutions:**

1. Check sudo is installed:
   ```bash
   which sudo
   ```

2. Use root directly (not recommended):
   ```bash
   su -
   ```

3. Check you're in sudoers group:
   ```bash
   groups
   ```

#### Package Manager Not Found

**Solutions:**

**For Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install -y zsh git curl
```

**For Fedora/CentOS:**
```bash
sudo dnf install -y zsh git curl
# or
sudo yum install -y zsh git curl
```

**For Arch:**
```bash
sudo pacman -S zsh git curl
```

### Windows (WSL) Issues

#### Path Issues

**Symptoms:**
- Tools not found despite being installed
- PATH includes Windows paths

**Solutions:**

1. Edit WSL PATH:
   ```bash
   # In ~/zsh-config/zsh/custom/paths.zsh
   # Remove Windows paths if needed
   export PATH="/usr/local/bin:/usr/bin:$PATH"
   ```

2. Check .bashrc interference:
   ```bash
   # WSL might source .bashrc
   # Ensure .zshrc isn't overridden
   ```

#### Docker in WSL

**Symptoms:**
- Docker command fails
- Cannot connect to Docker daemon

**Solutions:**

1. Use Docker Desktop integration:
   - Enable in Docker Desktop settings
   - Expose daemon on TCP without TLS

2. Use Docker inside WSL:
   ```bash
   # Install Docker inside WSL
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

## Getting Help

### Debug Mode

Enable verbose output to identify issues:

```bash
# Start zsh with verbose output
zsh -x

# Start zsh with single step
zsh -Z
```

### Safe Mode

Start zsh with minimal configuration:

```bash
# Start zsh without any config
zsh --no-rcs

# Source configs one at a time
zsh
source ~/.zshenv
source ~/.zshrc
```

### Report Issues

When reporting issues, include:

1. Zsh version:
   ```bash
   zsh --version
   ```

2. Operating system:
   ```bash
   uname -a
   ```

3. Error messages
4. Steps to reproduce
5. Configuration snippets

### Reset to Defaults

If all else fails, start fresh:

```bash
# Remove symlinks
rm ~/.zshrc ~/.p10k.zsh ~/.zshenv ~/.tmux.conf

# Run installer again
cd ~/zsh-config
./install.sh
```

## Next Steps

- [Installation Guide](INSTALLATION.md)
- [Customization Guide](CUSTOMIZATION.md)
- [Main README](../README.md)
