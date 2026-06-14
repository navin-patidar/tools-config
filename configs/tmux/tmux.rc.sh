# Auto-clone TPM if not present
TPM_DIR="${TOOLS_CONFIG_DATA}tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Cloning TPM…"
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install plugins listed in tmux.conf if tmux server is running
if tmux has-session 2>/dev/null; then
  "$TPM_DIR/bin/install_plugins" &>/dev/null || true
fi

alias tmux='tmux -f "${TOOLS_CONFIG_DIR}/configs/tmux/tmux.conf"'
alias t="tmux"
alias jk="tmux copy-mode"
alias ta="tmux attach"

LIST_WINDOWS="tmux list-panes -aF '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}'| grep -v \"${TMUX_PANE}\""
PREVIEW_PANE="tmux capture-pane -p -e -t {1} | tail -40 | bat --color=always"
SWITCH_PANE="enter:become:tmux switch-client -t {1}"

alias ts="${LIST_WINDOWS} |  fzf --delimiter=' ' --preview=\"${PREVIEW_PANE}\" --bind=\"${SWITCH_PANE}\" "
