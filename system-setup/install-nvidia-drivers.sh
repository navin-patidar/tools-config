echo "Upate the system: dnf update -y"
sudo dnf update -y

echo "Add nvidia repo"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Install nvidia driver"
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
