# Ensure rclone config dir in ~/.config exists
RCLONE_CONFIG_DIR="${HOME}/.config/rclone"
RCLONE_CONFIG_SRC="${TOOLS_CONFIG_DIR}/configs/rclone/rclone.conf"
RCLONE_CONFIG_DST="${RCLONE_CONFIG_DIR}/rclone.conf"

mkdir -p "$RCLONE_CONFIG_DIR"

# Symlink rclone config so it's tracked in this repo (credentials are gitignored)
if [[ -f "$RCLONE_CONFIG_SRC" ]] && [[ ! -L "$RCLONE_CONFIG_DST" || "$(readlink "$RCLONE_CONFIG_DST")" != "$RCLONE_CONFIG_SRC" ]]; then
  ln -sfn "$RCLONE_CONFIG_SRC" "$RCLONE_CONFIG_DST"
fi

# Create mount point
GDRIVE_MOUNT="${HOME}/gdrive"
mkdir -p "$GDRIVE_MOUNT"

mount-gdrive() {
  if ! command -v rclone &>/dev/null; then
    echo "rclone not installed. Install it first."
    return 1
  fi

  if ! rclone listremotes 2>/dev/null | grep -q "^gdrive:"; then
    echo "No 'gdrive' remote configured. Run: rclone config"
    return 1
  fi

  if mount | grep -q "$GDRIVE_MOUNT"; then
    echo "Already mounted at $GDRIVE_MOUNT"
    return 0
  fi

  rclone mount gdrive: "$GDRIVE_MOUNT" \
    --vfs-cache-mode full \
    --dir-perms 755 \
    --file-perms 644 \
    --daemon
  echo "Mounted gdrive: → $GDRIVE_MOUNT"
}

unmount-gdrive() {
  fusermount -uz "$GDRIVE_MOUNT" && echo "Unmounted $GDRIVE_MOUNT"
}

gdrive-status() {
  if mount | grep -q "$GDRIVE_MOUNT"; then
    echo "gdrive is MOUNTED at $GDRIVE_MOUNT"
    rclone about gdrive: 2>/dev/null || echo "(run 'rclone about gdrive:' for usage details)"
  else
    echo "gdrive is NOT mounted"
  fi
}

# Auto-mount on shell start if not skipped
if [[ -z "$RCLONE_SKIP_AUTOMOUNT" ]] && command -v rclone &>/dev/null; then
  if rclone listremotes 2>/dev/null | grep -q "^gdrive:" && ! mount | grep -q "$GDRIVE_MOUNT"; then
    mount-gdrive &>/dev/null &
  fi
fi
