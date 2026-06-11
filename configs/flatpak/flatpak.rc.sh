# Wrapper around `flatpak` that records installed packages in package_list.txt.

flatpak() {
  if [[ "$1" != "install" ]]; then
    command flatpak "$@"
    return
  fi
  # Run the real isntall first ; only record on success.
  command flatpak "$@" || return

  local pkg_list="${TOOLS_CONFIG_DIR}/configs/flatpak/package_list.txt"
  [[ -f "$pkg_list" ]] || touch "$pkg_list"

  local arg
  for arg in "$@"; do
    # Skip the subcommands,any option flags and the remote name (e.g. flathub).
    [[ "$arg" == "install" || "$arg" == -* || "$arg" != *.* ]] && continue

    if ! grep -qxF "$arg" "$pkg_list"; then
      echo "$arg" >>"$pkg_list"
      echo "flatpak: added '${arg} to ${pkg_list}"
    fi
  done
}
