alias t="tmux"
alias jk="tmux copy-mode"
alias ta="tmux attach"

LIST_WINDOWS="tmux list-panes -aF '#{session_name}:#{window_index} #{window_index} #{window_name}' |  grep -v \"${TMUX_PANE}\""
PREVIEW_PANE="tmux capture-pane -p -e -t {1} | bat --color=always"

alias ts="${LIST_WINDOWS} |  fzf --delimiter=' ' --preview=\"${PREVIEW_PANE}\" "
