# Symlink kitty config into ~/.config so kitty picks it up
KITTY_SRC="${TOOLS_CONFIG_DIR}/configs/kitty/"
KITTY_DST="${HOME}/.config/"
if [[ -d "$KITTY_SRC" ]] && [[ ! -L "$KITTY_DST" || "$(readlink "$KITTY_DST")" != "$KITTY_SRC" ]]; then
  mkdir -p "${HOME}/.config"
  ln -sfn "$KITTY_SRC" "$KITTY_DST"
fi

