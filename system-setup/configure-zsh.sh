# Run from this script's directory so the relative path blow resolve
cd "$(dirname "$0")"

BREW_ZSH="$(which zsh)"

# Add Homebrew zsh to /etc/shells if needed (chsh requires it to be listed)
if [[ -x "$BREW_ZSH" ]] && ! grep -qxF "$BREW_ZSH" /etc/shells; then
  echo "  Adding $BREW_ZSH to /etc/shells…"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$SHELL" == "$BREW_ZSH" ]]; then
  echo "  ✅ Default shell is already zsh"
else
  echo "Make zsh the default shell"
  chsh -s "$BREW_ZSH"
fi

echo "Ensure  ~/.zshrc exists"
touch ~/.zshrc

echo "Souce tools-config rc.sh from ~/.zshrc"
source_line="source ~/tools-config/rc.sh"
if ! grep -qxF "$source_line" ~/.zshrc; then
  echo "$source_line" >>~/.zshrc
  echo "Added '$source_line' to ~/.zshrc"
else
  echo "Already source in ~/.zshrc"
fi
