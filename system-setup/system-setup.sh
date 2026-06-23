#!/bin/bash

# Run from this script's directory so the relative path below resolve
cd "$(dirname "$0")"

set -e

bash ./install-brew.sh             # Install Homebrew
bash ./install-packages.sh         # brew bundle + flatpak apps
bash ./install-gnome-extensions.sh # install gnome extension
bash ./install-nvidia-drivers.sh   # install nvidia drivers
bash ./install-asus-pkg.sh

bash ./configure-ptyxis.sh  # teminal font, paste, palette
bash ./install-kitty.sh     # install kitty terminal
bash ./configure-monitor.sh # configure monitors layout (built-in monitor + external)
bash ./configure-gnome.sh   # restore GNOME settings (dconf)
bash ./configure-zsh.sh     # default shell + ~/.zshrc
bash ./configure-git.sh     # git config + gh auth

echo "System setup complete"
