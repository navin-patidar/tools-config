alias t="tmux"
alias jk="tmux copy-mode"
alias ta="tmux attach"

alias ts="tmux list-windows -F \#S:#W,#I | \
 fzf \
     --delimiter="," \
     --preview="echo {0} {1}" \
"
# --priview="tmux capture-pane -p -e -t {} | bat " \
#//--bind="enter:become"\
