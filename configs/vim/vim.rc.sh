# Symlink vimrc into home so vim picks it up
VIMRC_SRC="${TOOLS_CONFIG_DIR}/configs/vim/vimrc"
VIMRC_DST="${HOME}/.vimrc"
if [[ -f "$VIMRC_SRC" ]] && [[ ! -L "$VIMRC_DST" || "$(readlink "$VIMRC_DST")" != "$VIMRC_SRC" ]]; then
  ln -sfn "$VIMRC_SRC" "$VIMRC_DST"
fi