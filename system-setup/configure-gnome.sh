#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

BACKUP_FILE="full_gnome_conf_backup.dconf"

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "❌ $BACKUP_FILE not found"
  exit 1
fi

echo "🔄 Loading GNOME settings from $BACKUP_FILE …"
dconf load -f / < "$BACKUP_FILE"
echo "✅ GNOME settings restored"
