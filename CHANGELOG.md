# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.2.0] - 2026-02-26

### Added
- Modern CLI tools installation (bat, fd, ripgrep, btop, eza, tldr) with per-tool prompts
- `sysutils.zsh` sourced in `.zshrc` — enables aliases for bat, fd, rg
- `~/.local/share/gem/ruby/*/bin` in PATH for modern Ruby 3.x gem locations
- Validation check for existing `tldr` installation (auto-detects and replaces broken installs)
- `tldr` installation via pipx/pip (replaces npm-based approach, no sudo required)

### Fixed
- `sysutils.zsh` was never loaded by `.zshrc` — bat, fd, rg, eza aliases were dead code
- `ffind()` function in `functions.zsh` conflicted with `ffind` alias causing zsh parse error and Powerlevel10k instant prompt warning
- `sfind()`, `psgrep()`, `hgrep()`, `diskusage()` used aliased `grep`/`find` — now use `command grep` to bypass aliases
- colorls not found on PATH on systems where Ruby 3.x installs gems to `~/.local/share/gem/`
- `install_colorls.sh` temporary PATH now covers both `~/.gem` and `~/.local/share/gem` bin locations
- Removed stale duplicate `install_tldr()` function in `install_modern_tools.sh`

### Changed
- Removed eza `ls`/`la`/`ll`/`lt` aliases from `sysutils.zsh` — colorls takes priority, eza available directly as `eza`
- `tldr` installed via pipx/pip instead of npm — no Node.js dependency required
- Removed Node.js/npm from core dependencies

## [1.1.0] - 2026-02-05

### Added
- Initial release
- Oh My Zsh with Powerlevel10k theme
- zsh-autosuggestions and zsh-syntax-highlighting
- fzf integration
- colorls with fallback aliases
- tmux configuration
- Docker aliases
- Cross-platform support (macOS, Linux)
- Custom configuration system (modular custom files)

## [1.0.1] - 2026-02-05

### Added
- Conda/Mamba integration with auto-detection of ~/miniforge3
- New colorls aliases: `lf`, `ldir`, `lgs`, `llgs`, `ltr`, `lS`, `lx`
- System utilities aliases (btop, bat, fd, rg, tldr, ncdu)
- test.sh validation script
- Local overrides support (~/.zshrc.local, zsh/custom/local.zsh)
- `--quiet` flag to install/update/uninstall scripts

### Fixed
- Gem permission error on Linux servers (now uses --user-install)
- Parse error from .fzf.bash sourcing in zsh
- Colorls PATH detection in install script
- Powerlevel10k instant prompt warnings (removed console output)
- Autosuggestions now use both history and completion strategies
- ANSI escape codes in install script output
- update.sh JSON sourcing bug

### Changed
- Redesigned colorls aliases with distinct, useful options
- Replaced tmux start prompt with shell reload prompt
- Removed duplicate ls aliases from aliases.zsh (now handled by colorls.zsh)
- Removed personal phd alias (use local overrides instead)
