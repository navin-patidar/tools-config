# Wrapper around `brew` that records installed packages in Brewfile.

brew() {
  if [[ "$1" != "install" ]]; then
    command brew "$@"
    return
  fi
  # Run the real isntall first ; only record on success.
  command brew "$@" || return
  local brewfile="${TOOLS_CONFIG_DIR}/configs/brew/Brewfile"
  [[ -f "$brewfile" ]] || touch "$brewfile"

  # Decide whether these are casks or foumulae from the flag given
  local kind="brew"
  local arg
  for arg in "$@"; do
    [[ "$arg" == "--cask" || "$arg" == "--casks" ]] && kind="cask"
  done

  for arg in "$@"; do
    # Skip the subcommands and any option flags; the rest are package names.
    [[ "$arg" == "install" || "$arg" == -* ]] && continue

    local line="${kind} \"${arg}\""
    if ! grep -qxF "$line" "$brewfile"; then
      echo "$line" >>"$brewfile"
      echo "brew: added '${line} to ${brewfile}"
    fi
  done
}
