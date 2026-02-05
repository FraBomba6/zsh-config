# Conda/Mamba Integration

if [ -d "$HOME/miniforge3" ]; then
    export MAMBA_ROOT_PREFIX="$HOME/miniforge3"

    # Source conda initialization (silently)
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh" 2>/dev/null || true
    fi

    # Initialize mamba (using modern method, silently)
    if [ -x "$HOME/miniforge3/bin/mamba" ]; then
        eval "$("$HOME/miniforge3/bin/mamba" shell hook --shell zsh 2>/dev/null)" || true
    fi
fi
