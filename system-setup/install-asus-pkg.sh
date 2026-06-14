echo "Add asus repo"
sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

echo "Install asusctl"
sudo dnf install -y asusctl

echo "Enable asus service"
systemctl enable --now asusd.service

echo "Install UI for asusctl"
sudo dnf install -y asusctl-rog-gui
cp -r ./rog/ ~/.config/

sudo dnf swap tuned-ppd power-profiles-daemon --allowerasing
systemctl enable --now power-profiles-daemon.service

echo "Install cardwire"
sudo dnf install -y cardwire

# install tiling extensions
sudo dnf install -y gnome-shell-extension-pop-shell
