# Run from this script's directory so the relative path below resolve
cd "$(dirname "$0")"

# to source newly installed home brew
source ~/.bashrc

echo "Install brew packages"
brew bundle --file ../configs/brew/Brewfile

echo "Install flatpkg packages"
cat ../configs/flatpak/package_list.txt | xargs flatpak -y install

echo "Refrash font cache"
fc-cache -f -v
