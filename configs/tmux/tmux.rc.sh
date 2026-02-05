alias t="tmux"
alias jk="tmux copy-mode"
alias ta="tmux attach"

LIST_WINDOWS="tmux list-panes -aF '#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}'| grep -v \"${TMUX_PANE}\""
PREVIEW_PANE="tmux capture-pane -p -e -t {1} | bat --color=always"
SWITCH_PANE="enter:become:tmux switch-client -t {1}"

alias ts="${LIST_WINDOWS} |  fzf --delimiter=' ' --preview=\"${PREVIEW_PANE}\" --bind=\"${SWITCH_PANE}\" "
