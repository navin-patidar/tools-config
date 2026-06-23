vm-init() {
  sudo dnf install -y @virtualization virt-manager virt-viewer \
    qemu-kvm qemu-img virt-install virt-top virt-what guestfs-tools
  echo "vm-init complete"
}

vm-create() {
  local version=44
  local netinstall=false
  local vm_name="fedora-vm"
  local ram=8192
  local vcpus=4
  local disk_size=60

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --netinstall|--net) netinstall=true ;;
      --version) version="$2"; shift ;;
      *) echo "Usage: vm-create [--netinstall] [--version N]"; return 1 ;;
    esac
    shift
  done

  if virsh -c qemu:///session list --all --name | grep -qx "$vm_name"; then
    echo "VM '$vm_name' already exists"; return 1
  fi

  local disk_dir="${XDG_DATA_HOME:-$HOME/.local/share}/libvirt/images"
  local disk="${disk_dir}/${vm_name}.qcow2"
  mkdir -p "$disk_dir"
  local os_variant="fedora-unknown"

  if $netinstall; then
    virt-install --connect qemu:///session --name "$vm_name" --ram "$ram" --vcpus "$vcpus" \
      --disk path="$disk",size="$disk_size",format=qcow2 \
      --location "https://download.fedoraproject.org/pub/fedora/linux/releases/${version}/Everything/x86_64/os/" \
      --network user --graphics spice --os-variant "$os_variant"
  else
    local iso_dir="${XDG_DATA_HOME:-$HOME/.local/share}/libvirt/boot"
    mkdir -p "$iso_dir"
    local iso="${iso_dir}/Fedora-Workstation-Live-${version}-1.7.x86_64.iso"
    if [[ ! -f "$iso" ]]; then
      curl -fLo "$iso" \
        "https://download.fedoraproject.org/pub/fedora/linux/releases/${version}/Workstation/x86_64/iso/Fedora-Workstation-Live-${version}-1.7.x86_64.iso"
    fi
    virt-install --connect qemu:///session --name "$vm_name" --ram "$ram" --vcpus "$vcpus" \
      --disk path="$disk",size="$disk_size",format=qcow2 \
      --cdrom "$iso" --network user --graphics spice \
      --os-variant "$os_variant"
  fi
}

vm-status() {
  virsh -c qemu:///session list --all
}

vm-remove() {
  local vm_name="${1:-fedora-vm}"
  virsh -c qemu:///session destroy "$vm_name" 2>/dev/null
  virsh -c qemu:///session undefine --remove-all-storage "$vm_name"
}

vm-snapshot() {
  local vm_name="${1:-fedora-vm}"
  local snap_name="${2:-snap-$(date +%Y%m%d-%H%M%S)}"
  virsh -c qemu:///session snapshot-create-as "$vm_name" "$snap_name"
}

vm-restore() {
  local vm_name="${1:-fedora-vm}"
  local snap_name="$2"
  if [[ -z "$snap_name" ]]; then
    echo "Usage: vm-restore [vm-name] snapshot-name"; return 1
  fi
  virsh -c qemu:///session snapshot-revert "$vm_name" "$snap_name"
}

vm-snapshots() {
  local vm_name="${1:-fedora-vm}"
  echo "Snapshots for: $vm_name"
  virsh -c qemu:///session snapshot-list "$vm_name"
}

vm-stop() {
  virsh -c qemu:///session destroy "${1:-fedora-vm}"
}

vm-connect() {
  virt-viewer --connect qemu:///session "${1:-fedora-vm}"
}
