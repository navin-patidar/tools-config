# Run from this script's directory so the relative path blow resolve
cd "$(dirname "$0")"

echo "Make  zsh the default shell"
chsh -s "$(which zsh)"

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
