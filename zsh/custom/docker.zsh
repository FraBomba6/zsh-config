# Docker Aliases and Completions

# Main aliases
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dri='docker rmi'
alias dpa='docker ps -aq'

# Container management
alias dex='docker exec -it'
alias dlog='docker logs -f --tail 100'
alias dstop='docker stop'
alias dstart='docker start'
alias drestart='docker restart'
alias drmi='docker rmi -f $(docker images -f dangling=true -q)' 2>/dev/null || echo 'No dangling images'

# Volume management
alias dvls='docker volume ls'
alias dvrm='docker volume rm'

# Network management
alias dnls='docker network ls'
alias dnrm='docker network rm'

# Docker Compose aliases
alias dc='docker compose'
alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dclogs='docker compose logs -f'
alias dcps='docker compose ps'
alias dcexec='docker compose exec'

# Docker stats
alias dstats='docker stats --no-stream'

# Cleanup
alias dclean='docker system prune -f'
alias dvclean='docker volume prune -f'

# Docker build
alias dbuild='docker build -t'
alias dpush='docker push'

# Useful Docker functions

# Show container IP
docker_ip() {
  docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$1"
}

# Enter container shell
dshell() {
  local container=$1
  local shell=${2:-/bin/bash}
  docker exec -it "$container" "$shell"
}

# Show container logs
dlogs() {
  docker logs --tail 100 -f "$1"
}

# Run temporary container
drun() {
  docker run --rm -it "$@"
}

# Docker compose rebuild
dcrebuild() {
  docker compose down
  docker compose build
  docker compose up -d
}

# Remove all stopped containers
drmall() {
  docker rm $(docker ps -aq -f status=exited) 2>/dev/null || echo 'No stopped containers'
}
