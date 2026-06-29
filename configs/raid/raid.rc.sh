_disk_by_id() {
  local dev="$1" name
  name=$(basename "$dev")
  for link in /dev/disk/by-id/*; do
    [[ "$link" == *-part* ]] && continue
    if [[ "$(readlink "$link")" =~ ${name}(/[0-9]+)?$ ]]; then
      basename "$link"
      return
    fi
  done
}

_raid_blacklist=(
  usb-Seagate_Expansion_NA8HDSJ0-0:0
)

_disk_is_blacklisted() {
  local by_id
  by_id=$(_disk_by_id "$1")
  for bl in "${_raid_blacklist[@]}"; do
    [[ "$by_id" == "$bl"* ]] && return 0
  done
  return 1
}

raid-init() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-init"
    echo "Install missing RAID1 packages (mdadm, smartmontools, parted, cryptsetup)."
    return 0
  }
  local packages=(mdadm smartmontools parted cryptsetup)
  local missing=()

  for pkg in "${packages[@]}"; do
    if ! rpm -q "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done

  if [[ ${#missing[@]} -eq 0 ]]; then
    echo "All RAID1 packages already installed."
    return 0
  fi

  echo "Installing missing RAID1 packages: ${missing[*]}"
  sudo dnf install -y "${missing[@]}"
}

raid-create() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-create"
    echo "Interactive RAID1 creation. Lists available /dev/sd* disks,"
    echo "lets you select 1 (with option to add second later) or 2 disks,"
    echo "then creates a RAID1 array at /dev/md0."
    echo "Optionally encrypts with LUKS after creation."
    return 0
  }
  if grep -qs "md.*active raid1" /proc/mdstat 2>/dev/null; then
    echo "RAID1 array already exists:"
    cat /proc/mdstat
    return 0
  fi

  local external_disks=()
  while IFS= read -r disk; do
    local dev_path
    dev_path="/dev/$disk"
    local dev_type
    dev_type=$(lsblk -dn -o TYPE "$dev_path" 2>/dev/null)
    [[ "$dev_type" != "disk" ]] && continue
    [[ "$disk" != sd* ]] && continue
    _disk_is_blacklisted "$dev_path" && continue

    if grep -qs " $disk\[" /proc/mdstat 2>/dev/null; then
      continue
    fi

    external_disks+=("$dev_path")
  done < <(lsblk -dn -o NAME)

  local root_dev
  root_dev=$(findmnt -n -o SOURCE /)
  root_dev=$(lsblk -dn -o PKNAME "$root_dev" 2>/dev/null || echo "")

  local available=()
  for d in "${external_disks[@]}"; do
    local basename_d
    basename_d=$(basename "$d")
    [[ "$basename_d" == "$root_dev" ]] && continue
    available+=("$d")
  done

  if [[ ${#available[@]} -lt 1 ]]; then
    echo "No external disks found."
    lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT
    return 1
  fi

  echo "=== Available external disks ==="
  local i=1
  for d in "${available[@]}"; do
    local size by_id
    size=$(lsblk -dn -o SIZE "$d" 2>/dev/null)
    by_id=$(_disk_by_id "$d")
    printf '  %d) %-8s %6s  %s\n' "$i" "$d" "$size" "$by_id"
    ((i++))
  done

  echo ""
  echo "Select 1 disk to start (you can add a second one later), or 2 disks now."
  read "choice?Disk numbers (space-separated, e.g. \"1\" or \"1 2\"): "
  local selected_disks=()
  for num in $choice; do
    if [[ $num -ge 1 && $num -le ${#available[@]} ]]; then
      selected_disks+=("${available[$num]}")
    fi
  done

  if [[ ${#selected_disks[@]} -lt 1 ]]; then
    echo "Select at least 1 disk."
    return 1
  fi

  echo "Checking selected disks..."
  for d in "${selected_disks[@]}"; do
    if lsblk "$d" -o MOUNTPOINT 2>/dev/null | grep -q '^/'; then
      echo "ERROR: $d has mounted partitions. Unmount first."
      return 1
    fi
    if swapon --show 2>/dev/null | grep -q "$(basename "$d")"; then
      echo "ERROR: $d is in use as swap."
      return 1
    fi
  done

  echo "Selected disks: ${selected_disks[*]}"
  echo "WARNING: All data on these disks will be DESTROYED!"
  read "confirm?Proceed with RAID1 creation? [y/N] "
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    return 1
  fi

  if [[ ${#selected_disks[@]} -eq 1 ]]; then
    sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 "${selected_disks[1]}" missing
  else
    sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 "${selected_disks[@]}"
  fi

  if [[ ! -b /dev/md0 ]]; then
    echo "ERROR: RAID creation failed."
    return 1
  fi

  sudo mdadm --detail --scan | sudo tee -a /etc/mdadm.conf
  sudo dracut --force --mdadmconf --add="mdraid"

  echo ""
  echo "RAID1 created successfully."
  if [[ ${#selected_disks[@]} -eq 1 ]]; then
    echo "To add a second disk later: sudo mdadm --add /dev/md0 /dev/<disk>"
  fi

  echo ""
  read "enc_confirm?Encrypt the RAID array with LUKS? [y/N] "
  if [[ "$enc_confirm" =~ ^[Yy]$ ]]; then
    sudo cryptsetup luksFormat /dev/md0 && \
    read "map_name?Enter a name for the mapped device (default: cryptraid): " && \
    map_name="${map_name:-cryptraid}" && \
    sudo cryptsetup open /dev/md0 "$map_name" || {
      echo "ERROR: Encryption setup failed."
      return 1
    }
    echo ""
    read "fmt_confirm?Format with filesystem? [Y/n] "
    if [[ ! "$fmt_confirm" =~ ^[Nn]$ ]]; then
      read "fs_type?Filesystem type (default: ext4): "
      fs_type="${fs_type:-ext4}"
      sudo mkfs."$fs_type" "/dev/mapper/$map_name" && \
      echo "Encrypted RAID1 ready at /dev/mapper/$map_name"
    fi
  fi
}

raid-add-disk() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-add-disk [array]"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Add an unused disk to an existing RAID array."
    return 0
  }
  local array
  array="${1:-/dev/md0}"

  if ! grep -qs "md.*active raid" /proc/mdstat 2>/dev/null; then
    echo "No RAID array found."
    return 1
  fi

  local used_disks
  used_disks=$(awk '/md.*active raid/ {for(i=4;i<=NF;i++) {gsub(/\[[0-9]+\]/,"",$i); print $i}}' /proc/mdstat)

  local candidates=()
  while IFS= read -r disk; do
    local dev_path
    dev_path="/dev/$disk"
    local dev_type
    dev_type=$(lsblk -dn -o TYPE "$dev_path" 2>/dev/null)
    [[ "$dev_type" != "disk" ]] && continue
    [[ "$disk" != sd* ]] && continue
    _disk_is_blacklisted "$dev_path" && continue

    local in_use
    in_use=0
    for used in $used_disks; do
      [[ "$disk" == "$used" ]] && in_use=1 && break
    done
    [[ $in_use -eq 1 ]] && continue

    candidates+=("$dev_path")
  done < <(lsblk -dn -o NAME)

  if [[ ${#candidates[@]} -eq 0 ]]; then
    echo "No unused disks available to add."
    return 1
  fi

  echo "=== Disks available to add ==="
  local i=1
  for d in "${candidates[@]}"; do
    local size by_id
    size=$(lsblk -dn -o SIZE "$d" 2>/dev/null)
    by_id=$(_disk_by_id "$d")
    printf '  %d) %-8s %6s  %s\n' "$i" "$d" "$size" "$by_id"
    ((i++))
  done

  echo ""
  read "choice?Select disk to add (number): "
  if [[ $choice -lt 1 || $choice -gt ${#candidates[@]} ]]; then
    echo "Invalid selection."
    return 1
  fi

  local selected
  selected="${candidates[$choice]}"

  if lsblk "$selected" -o MOUNTPOINT 2>/dev/null | grep -q '^/'; then
    echo "ERROR: $selected has mounted partitions. Unmount first."
    return 1
  fi
  if swapon --show 2>/dev/null | grep -q "$(basename "$selected")"; then
    echo "ERROR: $selected is in use as swap."
    return 1
  fi

  echo "WARNING: All data on $selected will be DESTROYED!"
  read "confirm?Proceed? [y/N] "
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    return 1
  fi

  sudo mdadm --add "$array" "$selected"
}

raid-status() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-status [array]"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Show RAID array status from /proc/mdstat and mdadm detail."
    return 0
  }
  local array
  array="${1:-/dev/md0}"

  if ! grep -qs "md.*active raid" /proc/mdstat 2>/dev/null; then
    echo "No RAID array found."
    return 1
  fi

  echo "=== /proc/mdstat ==="
  cat /proc/mdstat
  echo ""

  if [[ -b "$array" ]]; then
    echo "=== $array detail ==="
    sudo mdadm --detail "$array" | grep -E "(Raid Level|Array Size|State|Active Devices|Working Devices|Failed Devices|Number|^\s+[0-9])"
  fi
}

raid-detail() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-detail [array]"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Show full mdadm detail for a RAID array."
    return 0
  }
  local array
  array="${1:-/dev/md0}"

  if [[ ! -b "$array" ]]; then
    echo "RAID array $array not found."
    return 1
  fi

  sudo mdadm --detail "$array"
}

raid-encrypt() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-encrypt [array]"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Encrypt an existing RAID array with LUKS."
    echo "Prompts for mapped device name and optional filesystem creation."
    return 0
  }
  local array
  array="${1:-/dev/md0}"

  if [[ ! -b "$array" ]]; then
    echo "RAID array $array not found."
    return 1
  fi

  read "confirm?Encrypt $array with LUKS? [y/N] "
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    return 1
  fi

  sudo cryptsetup luksFormat "$array" || return 1

  read "map_name?Enter mapped device name (default: cryptraid): "
  map_name="${map_name:-cryptraid}"
  sudo cryptsetup open "$array" "$map_name" || return 1

  read "fmt_confirm?Format with filesystem? [Y/n] "
  if [[ ! "$fmt_confirm" =~ ^[Nn]$ ]]; then
    read "fs_type?Filesystem type (default: ext4): "
    fs_type="${fs_type:-ext4}"
    sudo mkfs."$fs_type" "/dev/mapper/$map_name" && \
    echo "Encrypted RAID ready at /dev/mapper/$map_name"
  fi
}

raid-stop() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-stop [array]"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Stop a RAID array."
    return 0
  }
  local array
  array="${1:-/dev/md0}"

  if [[ ! -b "$array" ]]; then
    echo "RAID array $array not found."
    return 1
  fi

  sudo mdadm --stop "$array"
}

raid-fail-disk() {
  [[ "$1" == "--help" || "$1" == "-h" || "$2" == "--help" || "$2" == "-h" ]] && {
    echo "Usage: raid-fail-disk [array] <disk>"
    echo "  array  RAID device (default: /dev/md0)"
    echo "  disk   Device to fail and remove (e.g. /dev/sda)"
    echo ""
    echo "If no disk is given, lists current array devices."
    return 0
  }
  local array
  array="${1:-/dev/md0}"
  local disk
  disk="$2"

  if [[ -z "$disk" ]]; then
    echo "Usage: raid-fail-disk [array] /dev/sdX"
    echo ""
    sudo mdadm --detail "$array" | grep -E "^\s+[0-9]"
    return 1
  fi

  if [[ ! -b "$array" ]]; then
    echo "RAID array $array not found."
    return 1
  fi

  sudo mdadm --fail "$array" "$disk" && sudo mdadm --remove "$array" "$disk"
}

raid-change-key() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-change-key [array]"
    echo "  array  LUKS encrypted device (default: /dev/md0)"
    echo ""
    echo "Change the passphrase on a LUKS-encrypted RAID device."
    return 0
  }
  local array
  array="${1:-/dev/md0}"

  if [[ ! -b "$array" ]]; then
    echo "LUKS device $array not found."
    return 1
  fi

  if ! sudo cryptsetup isLuks "$array" 2>/dev/null; then
    echo "$array is not a LUKS encrypted device."
    return 1
  fi

  sudo cryptsetup luksChangeKey "$array"
}

raid-scrub() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-scrub [name]"
    echo "  name  md device name (default: md0)"
    echo ""
    echo "Trigger a data integrity check (scrub) on a RAID array."
    echo "Opens watch on /proc/mdstat to monitor progress."
    return 0
  }
  local array
  array="${1:-md0}"

  if [[ ! -d "/sys/block/$array/md" ]]; then
    echo "RAID array $array not found."
    return 1
  fi

  echo "Starting data integrity check on $array..."
  echo check | sudo tee "/sys/block/$array/md/sync_action"
  echo ""
  echo "Monitoring scrub progress (watch /proc/mdstat)..."
  watch -n 2 cat /proc/mdstat
}

raid-backup-config() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-backup-config [dest] [array]"
    echo "  dest   Output directory (default: \$PWD/raid-backup)"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Backup mdadm.conf, mdadm detail, and LUKS header (if encrypted)."
    return 0
  }
  local dest="${1:-$PWD/raid-backup}"
  local array="${2:-/dev/md0}"

  mkdir -p "$dest"
  echo "Backing up RAID config to $dest ..."

  sudo cp /etc/mdadm.conf "$dest/mdadm.conf"

  if [[ -b "$array" ]]; then
    sudo mdadm --detail "$array" > "$dest/mdadm-detail.txt"
  fi

  if sudo cryptsetup isLuks "$array" 2>/dev/null; then
    sudo cryptsetup luksHeaderBackup "$array" --header-backup-file "$dest/luks-header.bin"
    echo "LUKS header backed up."
  fi

  echo "Done. To restore on another system:"
  echo "  sudo cp $dest/mdadm.conf /etc/mdadm.conf"
  echo "  sudo mdadm --assemble --scan"
  [[ -f "$dest/luks-header.bin" ]] && echo "  sudo cryptsetup luksHeaderRestore $array --header-backup-file $dest/luks-header.bin"
}

raid-restore-config() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-restore-config [src] [array]"
    echo "  src    Backup directory (default: \$PWD/raid-backup)"
    echo "  array  RAID device (default: /dev/md0)"
    echo ""
    echo "Restore mdadm.conf, reassemble array, and optionally restore LUKS header."
    return 0
  }
  local src="${1:-$PWD/raid-backup}"
  local array="${2:-/dev/md0}"

  if [[ ! -f "$src/mdadm.conf" ]]; then
    echo "No backup found in $src"
    return 1
  fi

  sudo cp "$src/mdadm.conf" /etc/mdadm.conf
  sudo mdadm --assemble --scan

  if [[ -f "$src/luks-header.bin" ]] && sudo cryptsetup isLuks "$array" 2>/dev/null; then
    read "confirm?Restore LUKS header from $src/luks-header.bin? [y/N] "
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sudo cryptsetup luksHeaderRestore "$array" --header-backup-file "$src/luks-header.bin"
    fi
  fi

  echo "Restore complete. Open the encrypted device:"
  echo "  sudo cryptsetup open $array <name>"
}

raid-mount() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: raid-mount [array] [mount-point] [map-name]"
    echo "  array       RAID device (default: /dev/md0)"
    echo "  mount-point Mount directory (default: ~/backup)"
    echo "  map-name    LUKS mapped name (default: back-up)"
    echo ""
    echo "Assemble, open LUKS (if encrypted), and mount a RAID array."
    echo "Sets ownership to the current user."
    return 0
  }
  local array="${1:-/dev/md0}"
  local mount_point="${2:-$HOME/backup}"
  local map_name="${3:-back-up}"

  if [[ ! -b "$array" ]]; then
    echo "RAID array $array not found. Assembling..."
    sudo mdadm --assemble --scan || {
      echo "ERROR: Could not assemble RAID array."
      return 1
    }
  fi

  if sudo cryptsetup isLuks "$array" 2>/dev/null; then
    if [[ ! -b "/dev/mapper/$map_name" ]]; then
      sudo cryptsetup open "$array" "$map_name" || return 1
    fi
    local dev="/dev/mapper/$map_name"
  else
    local dev="$array"
  fi

  sudo mkdir -p "$mount_point"

  local fstype
  fstype=$(lsblk -dn -o FSTYPE "$dev" 2>/dev/null)
  if [[ -z "$fstype" ]]; then
    fstype="ext4"
    echo "No filesystem detected, assuming ext4."
  fi

  if mount | grep -q "$dev"; then
    echo "$dev is already mounted."
  else
    sudo mount -t "$fstype" "$dev" "$mount_point"
  fi

  sudo chown "$USER:$USER" "$mount_point"
  echo "RAID mounted at: $mount_point"
  ls -ld "$mount_point"
}
