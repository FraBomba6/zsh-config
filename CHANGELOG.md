# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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
