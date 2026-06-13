#!/bin/bash

# Run from this script's directory so the relative path below resolve
cd "$(dirname "$0")"

set -e

bash ./install-brew.sh     # Install Homebrew
bash ./install-packages.sh # brew bundle + flatpak apps

bash ./configure-zsh.sh            # default shell + ~/.zshrc
bash ./configure-ptyxis.sh         # teminal font, paste, palette
bash ./configure-git.sh            # git config + gh auth
bash ./configure-monitor.sh        # configure monitors layout (built-in monitor + external)
bash ./install-nvidia-drivers.sh   # install nvidia drivers
bash ./install-gnome-extensions.sh # install gnome extension

echo "System setup complete"
