MEDIA_MOUNT="${HOME}/media"
mkdir -p "$MEDIA_MOUNT"

_find_external_drive() {
  lsblk -o NAME,TYPE,FSTYPE,MOUNTPOINT,LABEL -n -l 2>/dev/null | \
    awk '$2 == "part" && $3 != "" && $1 !~ /nvme|loop|zram/ {print "/dev/" $1, $5}'
}

mount-media() {
  local device="${1:-}"

  if mount | grep -q "$MEDIA_MOUNT"; then
    echo "Already mounted at $MEDIA_MOUNT"
    return 0
  fi

  if [[ -z "$device" ]]; then
    local line label
    while IFS= read -r line; do
      label=$(echo "$line" | awk '{print $2}')
      if [[ -n "$label" ]]; then
        device=$(echo "$line" | awk '{print $1}')
        echo "Found: $device ($label)"
        break
      fi
    done < <(_find_external_drive)
  fi

  if [[ -z "$device" ]]; then
    echo "No external drive found."
    return 1
  fi

  local existing_mount
  existing_mount=$(findmnt -n -o TARGET "$device" 2>/dev/null)
  if [[ -n "$existing_mount" ]]; then
    sudo mount --bind "$existing_mount" "$MEDIA_MOUNT" \
      && echo "Bound $existing_mount → $MEDIA_MOUNT"
  else
    udisksctl mount -b "$device" --mount-point "$MEDIA_MOUNT"
  fi
}

unmount-media() {
  if mount | grep -q "$MEDIA_MOUNT"; then
    sudo umount "$MEDIA_MOUNT" && echo "Unmounted $MEDIA_MOUNT"
  else
    echo "Not mounted"
  fi
}

media-status() {
  if mount | grep -q "$MEDIA_MOUNT"; then
    echo "mounted at $MEDIA_MOUNT"
    lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT | grep -E "NAME|$MEDIA_MOUNT"
  else
    echo "not mounted"
  fi
}

if [[ -z "$MEDIA_SKIP_AUTOMOUNT" ]] && command -v udisksctl &>/dev/null && ! mount | grep -q "$MEDIA_MOUNT"; then
  mount-media &>/dev/null &
fi
