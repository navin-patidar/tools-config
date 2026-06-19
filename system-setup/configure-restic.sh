cd "$(dirname "$0")"
TOOLS_CONFIG_DIR="$(pwd)/.."

echo "Installing restic..."
brew install restic

echo "Initializing restic repository..."
source "../configs/restic/restic.rc.sh"
restic-init

BACKUP_SCRIPT="${HOME}/.local/bin/restic-backup-gdrive"
mkdir -p "${HOME}/.local/bin"

cat > "$BACKUP_SCRIPT" << EOF
#!/bin/bash
export TOOLS_CONFIG_DIR="$TOOLS_CONFIG_DIR"
export PATH="/usr/local/bin:/home/linuxbrew/.linuxbrew/bin:/usr/bin:/bin"
source "\$TOOLS_CONFIG_DIR/configs/restic/restic.rc.sh"
restic-backup-gdrive >> "\${HOME}/.local/share/restic-backup.log" 2>&1
EOF
chmod +x "$BACKUP_SCRIPT"

echo "Scheduling daily backup at midnight..."
CRON_JOB="0 0 * * * ${BACKUP_SCRIPT}"
(
  crontab -l 2>/dev/null | grep -v "$BACKUP_SCRIPT"
  echo "$CRON_JOB"
) | crontab -

echo "Restic backup configured. Daily backup at midnight logs to ~/.local/share/restic-backup.log"
