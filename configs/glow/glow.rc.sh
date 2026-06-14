# Symlink glow config into ~/.config so glow picks it up
GLOW_SRC="${TOOLS_CONFIG_DIR}/configs/glow/glow.yml"
GLOW_DST="${HOME}/.config/glow/glow.yml"
if [[ -f "$GLOW_SRC" ]] && [[ ! -L "$GLOW_DST" || "$(readlink "$GLOW_DST")" != "$GLOW_SRC" ]]; then
  mkdir -p "${HOME}/.config/glow"
  ln -sfn "$GLOW_SRC" "$GLOW_DST"
fi