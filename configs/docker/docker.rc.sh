docker-start() {
  systemctl --user start docker && echo "Docker started"
}

docker-stop() {
  systemctl --user stop docker && echo "Docker stopped"
}

docker-restart() {
  systemctl --user restart docker && echo "Docker restarted"
}

docker-status() {
  systemctl --user status docker
}
