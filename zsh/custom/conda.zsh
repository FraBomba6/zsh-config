# Conda / Mamba / Miniforge initialization
#
# Portable: searches common install locations rather than hard-coding paths.
# Safe: does nothing if conda is not installed.

# ---------------------------------------------------------------------------
# 1. Locate conda installation
# ---------------------------------------------------------------------------
_conda_prefix=""
for _candidate_dir in \
  "$HOME/miniforge3" \
  "$HOME/mambaforge" \
  "$HOME/miniconda3" \
  "$HOME/anaconda3" \
  "/opt/conda" \
  "/opt/miniforge3"; do
  if [ -f "$_candidate_dir/bin/conda" ]; then
    _conda_prefix="$_candidate_dir"
    break
  fi
done

# ---------------------------------------------------------------------------
# 2. Initialize conda (if found)
# ---------------------------------------------------------------------------
if [ -n "$_conda_prefix" ]; then
  __conda_setup="$("$_conda_prefix/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    # Fallback: source the profile script or just add to PATH
    if [ -f "$_conda_prefix/etc/profile.d/conda.sh" ]; then
      . "$_conda_prefix/etc/profile.d/conda.sh"
    else
      export PATH="$_conda_prefix/bin:$PATH"
    fi
  fi
  unset __conda_setup

  # ── Mamba ──────────────────────────────────────────────────────────
  if [ -x "$_conda_prefix/bin/mamba" ]; then
    export MAMBA_EXE="$_conda_prefix/bin/mamba"
    export MAMBA_ROOT_PREFIX="$_conda_prefix"
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__mamba_setup"
    else
      alias mamba="$MAMBA_EXE"
    fi
    unset __mamba_setup
  fi
fi

unset _conda_prefix _candidate_dir

# ---------------------------------------------------------------------------
# 3. Docker Desktop CLI completions
#    Needs to run before compinit (which happens later in .zshrc).
# ---------------------------------------------------------------------------
if [ -d "$HOME/.docker/completions" ]; then
  fpath=("$HOME/.docker/completions" $fpath)
fi
