# Symlink lazygit config into ~/.config so lazygit picks it up
LG_SRC="${TOOLS_CONFIG_DIR}/configs/lazygit/config.yml"
LG_DST="${HOME}/.config/lazygit/config.yml"
if [[ -f "$LG_SRC" ]] && [[ ! -L "$LG_DST" || "$(readlink "$LG_DST")" != "$LG_SRC" ]]; then
  mkdir -p "${HOME}/.config/lazygit"
  ln -sfn "$LG_SRC" "$LG_DST"
fi

alias gg="lazygit"
