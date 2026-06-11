echo "Configure Ptyxis"

# Ptyxis had dconf access from its sandbox, so it reads these keys from the host
# dconf database.

# Font: JetBrainsMono Nerd Font Medium, size 13
dconf write /org/gnome/Ptyxis/use-system-font false
dconf write /org/gnome/Ptyxis/font-name "'JetBrainsMono Nerd Font Medium 13'"

# Bind Ctrl+v to paste
dconf write /org/gnome/Ptyxis/Shortcuts/paste-clipboard "'<ctrl>v'"
