#!/bin/bash

# Install GNOME Shell extensions listed in gnome-extensions.txt
# Uses gdbus D-Bus calls to install directly from extensions.gnome.org.

set -euo pipefail

cd "$(dirname "$0")"

EXTENSIONS_FILE="gnome-extensions.txt"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
  echo "❌ $EXTENSIONS_FILE not found"
  exit 1
fi

entries=()
while IFS= read -r line; do
  line="${line%%#*}"
  line="${line//[[:space:]]/}"
  [[ -z "$line" ]] && continue
  entries+=("$line")
done <"$EXTENSIONS_FILE"

if [[ ${#entries[@]} -eq 0 ]]; then
  echo "📭 No extension UUIDs found in $EXTENSIONS_FILE"
  exit 0
fi

echo "📦 Installing GNOME Shell extensions via D-Bus…"
echo ""

installed=0
skipped=0
failed=0

for uuid in "${entries[@]}"; do
  # Check if already installed in the running session
  if gdbus call --session --dest org.gnome.Shell.Extensions \
    --object-path /org/gnome/Shell/Extensions \
    --method org.gnome.Shell.Extensions.GetExtensionInfo \
    "$uuid" &>/dev/null; then
    echo "  ⏭️  $uuid  (already installed)"
    skipped=$((skipped+1))
    continue
  fi

  echo "  Installing  $uuid …"

  result="$(gdbus call --session --dest org.gnome.Shell.Extensions \
    --object-path /org/gnome/Shell/Extensions \
    --method org.gnome.Shell.Extensions.InstallRemoteExtension \
    "$uuid" 2>/dev/null || true)"

  if [[ "$result" == *successful* ]]; then
    echo "      ✅ done"
    installed=$((installed+1))
  else
    echo "      ❌ failed"
    failed=$((failed+1))
  fi
done

echo ""
echo "✅ Done — $installed installed, $skipped skipped, $failed failed"
