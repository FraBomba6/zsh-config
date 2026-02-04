# Custom Aliases

# ls aliases (colorls or fallback)
if command -v colorls &>/dev/null; then
  alias ls='colorls'
  alias la='colorls -la'
  alias ll='colorls -alF'
  alias lt='colorls --tree=level 2'
else
  alias ls='ls --color=auto'
  alias la='ls -la --color=auto'
  alias ll='ls -alF --color=auto'
  alias lt='tree -L 2'
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cd..='cd ..'

# User shortcuts
alias home='cd ~'
alias phd="cd ~/Desktop/phd"

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Git aliases (beyond Oh My Zsh built-ins)
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gca='git commit -amend'
alias gp='git push'
alias gpu='git push -u origin $(git branch --show-current)'
alias gl='git pull'
alias gco='git checkout'
alias gbr='git branch'
alias gst='git stash'
alias gsp='git stash pop'
alias glog='git log --oneline --decorate --graph'
alias gclean='git clean -fd'
alias greset='git reset --hard HEAD~1'

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dstop='docker stop $(docker ps -aq)'
alias drmi='docker rmi -f $(docker images -aq)'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f --tail 100'

# Other useful aliases
alias h='history'
alias hs='history | grep'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias curl='curl -L'

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias brews='brew list -1'
  alias brewup='brew update && brew upgrade'
  alias brewclean='brew cleanup'
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
fi

# Linux specific
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias open='xdg-open'
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
  alias ports='netstat -tulanp'
  alias ports2='ss -tulanp'
fi

# Make sudo work with aliases
alias sudo='sudo '
