# Auto-clone TPM if not present
TPM_DIR="${TOOLS_CONFIG_DATA}tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Cloning TPM…"
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install plugins listed in tmux.conf if tmux server is running
if tmux has-session 2>/dev/null; then
  "$TPM_DIR/bin/install_plugins" || true
fi

# Symlink tmux config into ~/.config so tmux picks it up naturally
TMUX_CONF_SRC="${TOOLS_CONFIG_DIR}/configs/tmux/tmux.conf"
TMUX_CONF_DST="${HOME}/.config/tmux/tmux.conf"
if [[ -f "$TMUX_CONF_SRC" ]] && [[ ! -L "$TMUX_CONF_DST" || "$(readlink "$TMUX_CONF_DST")" != "$TMUX_CONF_SRC" ]]; then
  mkdir -p "${HOME}/.config/tmux"
  ln -sfn "$TMUX_CONF_SRC" "$TMUX_CONF_DST"
fi

alias tmux='tmux -f "${TOOLS_CONFIG_DIR}/configs/tmux/tmux.conf"'
alias t="tmux"
alias jk="tmux copy-mode"
alias ta="tmux attach"

LIST_WINDOWS="tmux list-panes -aF '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}'| grep -v \"${TMUX_PANE}\""
PREVIEW_PANE="tmux capture-pane -p -e -t {1} | tail -40 | bat --color=always"
SWITCH_PANE="enter:become:tmux switch-client -t {1}"

alias ts="${LIST_WINDOWS} |  fzf --delimiter=' ' --preview=\"${PREVIEW_PANE}\" --bind=\"${SWITCH_PANE}\" "
