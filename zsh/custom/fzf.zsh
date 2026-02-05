# FZF (Fuzzy Finder) Configuration

# Use fd if available (faster than find)
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d"
fi

# Use ripgrep if available (faster than grep)
if command -v rg &>/dev/null; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --preview 'rg --pretty --context 2 {q} | head -200'"
fi

# History search with FZF
# Use Ctrl+R to search history
# The widget is loaded by fzf

# File search with FZF
# Use Ctrl+T to search files
# The widget is loaded by fzf

# Directory search with FZF
# Use Alt+C to search directories
# The widget is loaded by fzf

# FZF key bindings and completions
if command -v fzf &>/dev/null; then
  _fzf_version=$(fzf --version 2>/dev/null | awk '{print $1}')
  _fzf_major=$(echo "$_fzf_version" | cut -d. -f1)
  _fzf_minor=$(echo "$_fzf_version" | cut -d. -f2)
  
  if [ "$_fzf_major" -gt 0 ] 2>/dev/null || ([ "$_fzf_major" -eq 0 ] 2>/dev/null && [ "$_fzf_minor" -ge 48 ] 2>/dev/null); then
    # fzf 0.48+ supports --zsh flag
    source <(fzf --zsh 2>/dev/null)
  elif [ -f ~/.fzf.zsh ]; then
    # Older versions use the legacy fzf.zsh file
    source ~/.fzf.zsh 2>/dev/null
  fi
  
  unset _fzf_version _fzf_major _fzf_minor
fi

# Custom FZF functions

# Search and open file
fo() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Search and cd to directory
fcd() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf-tmux +m) && cd "$dir"
}

# Kill process with FZF
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf-tmux -m | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    kill -9 ${pid}
    echo "Killed ${pid}"
  fi
}

# Git branch checkout with FZF
fbr() {
  local branches branch
  branches=$(git --no-pager branch -vv)
  branch=$(echo "$branches" | fzf-tmux +m | awk '{print $1}' || awk '{print $1}')
  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

# Git commit browser with FZF
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% Creset%x09 %Creset" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --bind=ctrl-s:toggle-sort \
      --header "Press ENTER to view, CTRL-D to diff, CTRL-S toggle sort" \
      --preview "echo {} | grep -o '[a-f0-9]\{7,\}' | xargs -I % sh -c 'git show --color=always % | head -200'" \
      --bind "enter:execute:vim -c 'silent execute \"Git show\"' {+} | less -R < /dev/tty" \
      --bind "ctrl-d:execute:(grep -o '[a-f0-9]\{7,\}' | head -5 | xargs -I % sh -c 'git show --color=always % | less -R' < /dev/tty)"
}
