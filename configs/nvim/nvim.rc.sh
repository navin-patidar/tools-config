export NVIM_APPNAME=lazyVim
export EDITOR="nvim"
export VISUAL="nvim"
alias vim="nvim"
alias vi="nvim"

# Use neovim-remote to open files in parent nvim inside nvim terminal
if ! command -v nvr &>/dev/null; then
  pipx install neovim-remote
fi

if [ -n "$NVIM" ]; then
  export EDITOR="nvr --remote-wait"
  export VISUAL="nvr --remote-wait"
  alias nvim ="nvr"
  alias vim="nvr"
  alias vi="nvr"
fi
