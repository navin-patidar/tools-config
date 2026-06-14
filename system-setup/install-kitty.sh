#!/bin/bash

# Install kitty terminal via the system package manager.

set -euo pipefail

cd "$(dirname "$0")"

if command -v kitty &>/dev/null; then
  echo "✅ kitty is already installed: $(kitty --version)"
  exit 0
fi

echo "Installing kitty…"
sudo dnf install -y kitty

echo "✅ kitty installed successfully"
