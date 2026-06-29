RESTIC_BACKUP_DEST="/run/media/navin/ex-hd-navin/google_backup/gdrive"
export RESTIC_PASSWORD_FILE="${HOME}/.config/restic/password"
RESTIC_SOURCE="${HOME}/gdrive"

restic-init() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: restic-init"
    echo "Initialize a restic repository at \$RESTIC_BACKUP_DEST."
    echo "Prompts for a password if no password file exists."
    return 0
  }
  if [[ ! -f "$RESTIC_PASSWORD_FILE" ]]; then
    mkdir -p "$(dirname "$RESTIC_PASSWORD_FILE")"
    echo "Enter password for restic repository:"
    read -rs password
    echo
    echo "$password" > "$RESTIC_PASSWORD_FILE"
    chmod 600 "$RESTIC_PASSWORD_FILE"
  fi

  if ! restic -r "$RESTIC_BACKUP_DEST" snapshots &>/dev/null; then
    echo "Initializing restic repository at $RESTIC_BACKUP_DEST ..."
    RESTIC_PASSWORD_FILE="$RESTIC_PASSWORD_FILE" \
      restic init --repo "$RESTIC_BACKUP_DEST"
  else
    echo "Repository already initialized at $RESTIC_BACKUP_DEST"
  fi
}

restic-backup-gdrive() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: restic-backup-gdrive"
    echo "Back up \$RESTIC_SOURCE to restic repository at \$RESTIC_BACKUP_DEST."
    echo "Tags the snapshot with the current date."
    return 0
  }
  if ! command -v restic &>/dev/null; then
    echo "restic not installed."
    return 1
  fi

  if [[ ! -d "$RESTIC_BACKUP_DEST" ]]; then
    echo "Backup destination not found: $RESTIC_BACKUP_DEST"
    echo "Make sure the external drive is mounted."
    return 1
  fi

  if [[ ! -f "$RESTIC_PASSWORD_FILE" ]]; then
    echo "No password file found. Run restic-init first."
    return 1
  fi

  if ! restic -r "$RESTIC_BACKUP_DEST" snapshots &>/dev/null; then
    echo "Repository not initialized. Run restic-init first."
    return 1
  fi

  RESTIC_PASSWORD_FILE="$RESTIC_PASSWORD_FILE" \
    restic backup \
    --repo "$RESTIC_BACKUP_DEST" \
    --tag "gdrive-$(date +%Y-%m-%d)" \
    --verbose \
    "$RESTIC_SOURCE"
}

restic-status() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: restic-status"
    echo "List snapshots in the restic repository."
    return 0
  }
  if [[ ! -f "$RESTIC_PASSWORD_FILE" ]]; then
    echo "No password file found."
    return 1
  fi

  RESTIC_PASSWORD_FILE="$RESTIC_PASSWORD_FILE" \
    restic -r "$RESTIC_BACKUP_DEST" snapshots
}

restic-restore-gdrive() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: restic-restore-gdrive [target]"
    echo "  target  Restore destination (default: \$RESTIC_SOURCE.restore)"
    echo ""
    echo "Restore the latest snapshot from the restic repository."
    return 0
  }
  local target="${1:-${RESTIC_SOURCE}.restore}"

  if [[ ! -f "$RESTIC_PASSWORD_FILE" ]]; then
    echo "No password file found."
    return 1
  fi

  RESTIC_PASSWORD_FILE="$RESTIC_PASSWORD_FILE" \
    restic restore latest \
    --repo "$RESTIC_BACKUP_DEST" \
    --target "$target"

  echo "Restored to: $target"
}

restic-check() {
  [[ "$1" == "--help" || "$1" == "-h" ]] && {
    echo "Usage: restic-check"
    echo "Check the restic repository integrity."
    return 0
  }
  if [[ ! -f "$RESTIC_PASSWORD_FILE" ]]; then
    echo "No password file found."
    return 1
  fi

  RESTIC_PASSWORD_FILE="$RESTIC_PASSWORD_FILE" \
    restic -r "$RESTIC_BACKUP_DEST" check
}
