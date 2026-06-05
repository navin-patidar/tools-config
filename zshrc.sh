typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

#compinit
autoload -U compinit
autoload -U colors

#colors
setopt nocorrectall
setopt correct

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

#keep background process at full speed
setopt NOBGNICE

#restart running process on exit
#setopt HUP

# HISTORY
export HISTFILE=~/.zsh_history
export HISTSIZE=5000000
SAVEHIST=${HISTSIZE}

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

setopt NO_BEEP

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Use GNU time instead of zsh builtin so $TIME format is respected
disable -r time

# GNU time format: show elapsed time, CPU and I/O usage
export TIME="\n %e real | %U user | %S sys | %P CPU\n /
%I input | %O output | %F major faults | %R minor faults\n /
%M KB max RSS | %W swaps \n /
%c involuntary ctx | %w voluntary ctx\n /
%r sock recv | %s sock send"

which-pkg() {
  rpm -qf "$(which "$1" 2>/dev/null)" 2>/dev/null || dnf provides "$1"
}

alias gti="git"
alias q="exit"
alias gg="lazygit"
alias s="source ~/.zshrc"
