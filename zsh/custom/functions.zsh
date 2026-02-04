# Custom Functions

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"     ;;
      *.tbz2)      tar xjf "$1"    ;;
      *.tgz)       tar xzf "$1"    ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find and display size of directories
dusort() {
  du -sh "$1"/* 2>/dev/null | sort -rh | head -20
}

# Search for process
psgrep() {
  ps aux | grep -i "$1" | grep -v grep
}

# Kill process by name
pskill() {
  local pid=$(psgrep "$1" | awk '{print $2}')
  if [ -n "$pid" ]; then
    kill -9 "$pid"
    echo "Killed process $1 (PID: $pid)"
  else
    echo "No process found matching: $1"
  fi
}

# Quick backup of file
backup() {
  cp "$1" "$1.backup-$(date +%Y%m%d_%H%M%S)"
  echo "Backed up: $1 -> $1.backup-$(date +%Y%m%d_%H%M%S)"
}

# Create a quick note
note() {
  local notes_dir="$HOME/notes"
  mkdir -p "$notes_dir"
  local note_file="$notes_dir/$(date +%Y-%m-%d).md"
  echo "# Note: $(date '+%Y-%m-%d %H:%M')" >> "$note_file"
  echo "" >> "$note_file"
  if [ -n "$1" ]; then
    echo "$1" >> "$note_file"
  fi
  vim "+normal Go" "$note_file"
}

# Open GitHub page of current git repo
ghrepo() {
  git remote get-url origin | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//' | xargs open
}

# Show weather for city (wttr.in)
weather() {
  curl "wttr.in/${1:-your_city}"
}

# Quick IP address
myip() {
  echo "Public IP: $(curl -s ifconfig.me)"
  echo "Local IP: $(ipconfig getifaddr $(ipconfig route print 2>/dev/null | grep default | awk '{print $NF}') 2>/dev/null || ip route get 1 | awk '{print $NF}')"
}

# Search command history
hgrep() {
  history | grep -i "$1" | tail -20
}

# Find files by name
ffind() {
  find . -name "*$1*" 2>/dev/null
}

# Find files by content
sfind() {
  grep -r "$1" . 2>/dev/null
}

# Quick HTTP server
serve() {
  local port=${1:-8000}
  echo "Serving current directory on http://localhost:$port"
  python3 -m http.server "$port" 2>/dev/null || python -m SimpleHTTPServer "$port" 2>/dev/null
}

# Timestamp function
timestamp() {
  date "+%Y%m%d_%H%M%S"
}

# Get file info
fileinfo() {
  if [ -f "$1" ]; then
    echo "File: $1"
    echo "Size: $(du -h "$1" | cut -f1)"
    echo "Type: $(file "$1")"
    echo "Lines: $(wc -l < "$1" 2>/dev/null || echo 'N/A')"
    echo "Words: $(wc -w < "$1" 2>/dev/null || echo 'N/A')"
    echo "Chars: $(wc -c < "$1" 2>/dev/null || echo 'N/A')"
  else
    echo "File not found: $1"
  fi
}

# Generate random password
genpass() {
  local length=${1:-16}
  openssl rand -base64 64 | tr -d "=+/" | cut -c1-${length}
}

# Show disk usage of all mounted drives
diskusage() {
  df -h | grep -vE '^Filesystem|tmpfs|cdrom|overlay'
}

# Watch a process
watchproc() {
  watch -n 1 "ps aux | grep -i $1 | grep -v grep"
}

# Create git repo quickstart
gitstart() {
  git init
  echo "# README" > README.md
  echo ".DS_Store" > .gitignore
  git add .
  git commit -m "Initial commit"
  echo "Git repository initialized!"
}
