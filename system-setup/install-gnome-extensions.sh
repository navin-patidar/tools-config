#!/bin/bash

# Install GNOME Shell extensions listed in gnome-extensions.txt
# Uses gnome-extensions CLI (built-in GNOME 45+) with direct download.

set -euo pipefail

cd "$(dirname "$0")"

EXTENSIONS_FILE="gnome-extensions.txt"
EXTENSIONS_DIR="${HOME}/.local/share/gnome-shell/extensions"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
  echo "❌ $EXTENSIONS_FILE not found"
  exit 1
fi

if ! command -v gnome-extensions &>/dev/null; then
  echo "❌ gnome-extensions CLI not found (requires GNOME 45+)"
  exit 1
fi

# Detect the running GNOME Shell version (major.minor)
SHELL_VERSION="$(busctl --user get-property org.gnome.Shell /org/gnome/Shell org.gnome.Shell ShellVersion 2>/dev/null || true)"
SHELL_VERSION="${SHELL_VERSION//[\"\']/}"
SHELL_VERSION="${SHELL_VERSION%%,*}"
SHELL_VERSION="$(echo "$SHELL_VERSION" | sed 's/[^0-9.]//g' | awk -F. '{print $1"."$2}')"

# Try the major version only as fallback
SHELL_VERSION_MAJOR="${SHELL_VERSION%%.*}"

echo "ℹ️  Detected GNOME Shell $SHELL_VERSION"

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

echo "📦 Installing GNOME Shell extensions…"
echo ""

installed=0
skipped=0
failed=0

for uuid in "${entries[@]}"; do
  # Check both the running session (gnome-extensions info) and disk
  if gnome-extensions info "$uuid" &>/dev/null || [[ -d "${EXTENSIONS_DIR}/${uuid}" ]]; then
    echo "  ⏭️  $uuid  (already installed)"
    skipped=$((skipped+1))
    continue
  fi

  echo "  Installing  $uuid …"

  # Query the API, trying full version first, then major version
  dl_url=""
  for ver in "$SHELL_VERSION" "$SHELL_VERSION_MAJOR"; do
    [[ -z "$ver" ]] && continue
    metadata="$(curl -sL "https://extensions.gnome.org/extension-info/?uuid=$uuid&shell_version=$ver" || true)"
    dl_url="$(echo "$metadata" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('download_url', '') or '', end='')
except Exception:
    pass
" 2>/dev/null || true)"
    [[ -n "$dl_url" ]] && break
  done

  # Try without version as last resort
  if [[ -z "$dl_url" ]]; then
    metadata="$(curl -sL "https://extensions.gnome.org/extension-info/?uuid=$uuid" || true)"
    dl_url="$(echo "$metadata" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('download_url', '') or '', end='')
except Exception:
    pass
" 2>/dev/null || true)"
  fi

  if [[ -z "$dl_url" ]]; then
    echo "      ❌ could not resolve download URL (is the UUID correct?)"
    failed=$((failed+1))
    continue
  fi

  # Download and install
  tmpdir="$(mktemp -d)"
  if curl -sL "https://extensions.gnome.org$dl_url" -o "$tmpdir/extension.zip" \
    && gnome-extensions install "$tmpdir/extension.zip" &>/dev/null; then
    echo "      ✅ installed"
    installed=$((installed+1))
    gnome-extensions enable "$uuid" &>/dev/null || true
  else
    # gnome-extensions install failed — check if it was installed anyway
    if [[ -d "${EXTENSIONS_DIR}/${uuid}" ]]; then
      echo "      ✅ installed"
      installed=$((installed+1))
      gnome-extensions enable "$uuid" &>/dev/null || true
    else
      echo "      ❌ failed"
      failed=$((failed+1))
    fi
  fi
  rm -rf "$tmpdir"
done

echo ""
echo "✅ Done — $installed installed, $skipped skipped, $failed failed"
