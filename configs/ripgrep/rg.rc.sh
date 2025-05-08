# ripgrep->fzf->vim [QUERY]
r_grep() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
           nvim {1} +{2}     # No selection. Open the current line in Vim.
          else
           nvim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi \
    --bind "start:$RELOAD" --bind "change:$RELOAD" \
    --bind "ctrl-e:execute:$OPENER" \
    --bind 'ctrl-w:execute:(cd $(dirname {1}) && zsh)' \
    --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
    --delimiter : \
    --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
    --preview-window '~4,+{2}+4/3,<80(up)' \
    --query "$*"
)

zle -N r_grep
bindkey '^w' r_grep
