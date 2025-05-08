# Set up fzf key binding and fuzzy completion 
eval "$(fzf --zsh)"


export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# Use ? as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='?'

SHOW_FILE_OR_DIR_PREVIEW="if [[ -d {} ]]; then 
                            tree {} | head -200;
                          else 
                            bat -n --color=always --line-range :1000 {};
                          fi"

OPENER="if [[ -d {} ]]; then
           cd {} && zsh; # Open shell in directory 
        else
           nvim {};    # Open file with nvim 
       fi"

export FZF_CTRL_T_OPTS="--preview '${SHOW_FILE_OR_DIR_PREVIEW}' \
                        --bind 'ctrl-e:execute:(${OPENER})'"
#                        --bind 'ctrl-e:become:(${OPENER})' \
#                        --bind 'ctrl-e:become:(${OPENER})' \
#                       "
#                       --tmux 100%,100% \

export FZF_ALT_C_OPTS="--preview 'tree | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree {} | head -200' "$@" ;;
    export|unset) fzf --preview "echo ${}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

source  $(dirname $(realpath "$0"))/fzf-git.sh/fzf-git.sh
