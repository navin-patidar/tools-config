export NVIM_APPNAME=lazyVim
export EDITOR="nvim"
export VISUAL="nvim"
alias vim="nvim"
alias vi="nvim"

# Symlink lazyVim config into ~/.config so nvim picks it up via NVIM_APPNAME
LAZYVIM_SRC="${TOOLS_CONFIG_DIR}/configs/lazyVim"
LAZYVIM_DST="${HOME}/.config/lazyVim"
if [[ -d "$LAZYVIM_SRC" ]] && [[ ! -L "$LAZYVIM_DST" || "$(readlink "$LAZYVIM_DST")" != "$LAZYVIM_SRC" ]]; then
  mkdir -p "${HOME}/.config"
  ln -sfn "$LAZYVIM_SRC" "$LAZYVIM_DST"
fi

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
