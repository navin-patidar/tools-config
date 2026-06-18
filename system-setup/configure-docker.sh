cd "$(dirname "$0")"

echo "Checking required brew packages for Docker..."

DOCKER_DEPS=("docker" "docker-engine" "rootlesskit" "slirp4netns")
MISSING=()

for pkg in "${DOCKER_DEPS[@]}"; do
  if brew list "$pkg" &>/dev/null; then
    echo "  ✓ $pkg"
  else
    echo "  ✗ $pkg — not installed"
    MISSING+=("$pkg")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo ""
  echo "Installing missing packages: ${MISSING[*]}"
  brew install "${MISSING[@]}"
fi

echo ""
echo "Setting up rootless Docker..."
dockerd-rootless-setuptool.sh install

echo ""
echo "Verifying Docker works..."
docker run hello-world
