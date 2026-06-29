# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a dotfiles/tools configuration repository that centralizes configuration files for various command-line tools and development environments. Configurations live under a single `configs/` directory, making them portable and version-controlled.

## Architecture

### Core Loading Mechanism

The `rc.sh` script at the repository root is the entry point that:
1. Sets `TOOLS_CONFIG_DIR` to the repository root
2. Sets `TOOLS_CONFIG_DATA` to `${HOME}/.local/share/tools-config/`
3. Sources `zshrc.sh` (core Zsh settings)
4. Finds and sources all `*.rc.sh` files under `configs/` (sorted)

To activate, users source `rc.sh` from their shell initialization files (e.g., `.zshrc`).

### Configuration Organization

Each tool has its own subdirectory under `configs/`:
- Configuration files live in `configs/<tool>/`
- Shell initialization scripts follow the naming pattern `<tool>.rc.sh`
- The `.rc.sh` files set environment variables, define shell functions/aliases, and symlink config files into `~/.config/<tool>/`

### Data Directory

`${HOME}/.local/share/tools-config/` (stored in `$TOOLS_CONFIG_DATA`) is used for cloning external dependencies:
- Oh My Zsh (`$TOOLS_CONFIG_DATA/oh-my-zsh`)
- TPM (`$TOOLS_CONFIG_DATA/tmux/plugins/tpm`)
- fzf-git.sh (`$TOOLS_CONFIG_DATA/fzf/fzf-git.sh`)

## Tool Configurations

### Neovim/LazyVim (`configs/lazyVim/`, `configs/nvim/`)
- Primary editor setup using LazyVim distribution
- `NVIM_APPNAME=lazyVim` routes nvim to LazyVim configs
- Custom plugins in `lua/plugins/`: toggle_term, stay_centered, noice, lualine, explorer, completion
- Custom LSP, options, keymaps, and autocmds in `lua/config/`
- Inside an nvim terminal, switches EDITOR/VISUAL to `nvr --remote-wait`
- Bootstraps lazy.nvim, auto-restores session when opened without a file

### Tmux (`configs/tmux/`)
- `tmux.conf` uses TPM with plugins: tmux-resurrect, tmux-continuum, tmux-autoreload, tmux-fzf, tmux-floax, tmux-sessionx, vim-tmux-navigator, catppuccin theme
- Key bindings: prefix+r (reload), prefix+h (fzf menu), prefix+o (sessionx), Ctrl+q (floax), prefix+h/j/k/l (pane nav)
- Shell aliases: `tmux` (with custom config), `t`, `jk`, `ta`, `ts` (fzf pane switcher)

### Zsh (`configs/0-ohmyzsh/`, root `zshrc.sh`)
- Uses Oh My Zsh framework with powerlevel10k (lean style, nerdfont-v3)
- Plugins: git, dnf, fzf, alias-finder, vi-mode
- History: 5M lines, no duplicates, shared across sessions
- Custom aliases: `q` (exit), `s` (source ~/.zshrc), `which-pkg` (find rpm package for command)
- Auto-clones oh-my-zsh and powerlevel10k on first load

### FZF (`configs/fzf/`)
- Default command: `fd --hidden --strip-cwd-prefix --exclude .git`
- Reverse layout with wrap, bat previews for file preview, tree for directories
- Ctrl+T: find files (Ctrl+E to open in nvim / cd to dir)
- Alt+C: find directories with tree preview
- FZF completion trigger: `?` instead of `**`
- Custom `_fzf_compgen_path`, `_fzf_compgen_dir`, `_fzf_comprun`
- Clones and sources fzf-git.sh for git-aware fzf integration

### Ripgrep (`configs/ripgrep/`)
- `r_grep` function: interactive ripgrep+fzf search widget bound to Ctrl+W
- Real-time RG reload on keystroke, previews with bat
- Ctrl+E opens result in nvim (single) or build quickfix list (multi)
- Ctrl+W opens file directory in shell

### Bat (`configs/bat/`)
- Theme: Solarized (dark)
- Syntax mappings: `*.ino` → C++, `.ignore` → Git Ignore

### Git (`configs/git/`)
- User config: navin patidar, navin.patidar@gmail.com
- Credential helper: store, editor: nvim

### Lazygit (`configs/lazygit/`)
- editPreset: nvim, confirms on force push, no startup popups
- `gg` alias for lazygit

### Restic Backup (`configs/restic/`)
- Encrypted backups to `/run/media/navin/ex-hd-navin/google_backup/gdrive`
- Functions: `restic-init`, `restic-backup-gdrive`, `restic-status`, `restic-restore-gdrive`, `restic-check`
- All support `--help` / `-h`

### RAID Management (`configs/raid/`)
Full RAID1 management suite with `--help` on all functions:
- `raid-init` — Install mdadm, smartmontools, parted, cryptsetup
- `raid-create` — Interactive RAID1 creation with disk selection (sd* only), optional LUKS encryption
- `raid-add-disk` — Add a disk to an existing array
- `raid-status` — Show RAID status from /proc/mdstat
- `raid-detail` — Full mdadm detail
- `raid-encrypt` — LUKS encrypt an existing RAID array
- `raid-stop` — Stop a RAID array
- `raid-fail-disk` — Fail and remove a disk
- `raid-change-key` — Change LUKS passphrase
- `raid-scrub` — Trigger data integrity check
- `raid-backup-config` — Backup mdadm.conf, detail, LUKS header
- `raid-restore-config` — Restore RAID config from backup
- `raid-mount` — Assemble, open LUKS (if encrypted), mount (defaults: /dev/md0, ~/backup, back-up)
- Blacklist support: `_raid_blacklist` array excludes specific disks by by-id

### Media Mounting (`configs/media/`)
- Auto-detects external drives via lsblk, mounts to `~/media`
- Functions: `mount-media`, `unmount-media`, `media-status`

### Rclone / Google Drive (`configs/rclone/`)
- Mounts Google Drive to `~/gdrive` with VFS cache
- Functions: `mount-gdrive`, `unmount-gdrive`, `gdrive-status`

### Docker (`configs/docker/`)
- Functions: `docker-start`, `docker-stop`, `docker-restart`, `docker-status`

### Virtual Machines (`configs/vm/`)
- Libvirt/QEMU management functions: `vm-init`, `vm-create`, `vm-status`, `vm-remove`, `vm-snapshot`, `vm-restore`, `vm-snapshots`, `vm-stop`, `vm-connect`

### Vim (`configs/vim/`)
- Legacy vimrc with syntax highlighting, line numbers, folding, mouse support, persistent undo, F2 save, F5 spellcheck

### Kitty Terminal (`configs/kitty/`)
- JetBrainsMono Nerd Font 13pt, auto-copy on select
- Alt+Tab / Ctrl+V / Ctrl+Tab pass-through for Neovim

### Homebrew (`configs/brew/`)
- `brew` wrapper: auto-records installed packages in Brewfile

### Flatpak (`configs/flatpak/`)
- `flatpak` wrapper: auto-records installed packages in package_list.txt

### Glow (`configs/glow/`)
- Markdown renderer config: no mouse, no pager, width 100

### OpenCode (`configs/opencode/`)
- Configures OpenCode to use local llama.cpp at localhost:8080

## System Setup Scripts

All in `system-setup/`. Orchestrated by `system-setup.sh`:
- `install-brew.sh` — Homebrew installation
- `install-packages.sh` — brew bundle + flatpak apps
- `install-gnome-extensions.sh` — GNOME Shell extensions
- `install-nvidia-drivers.sh` — RPM Fusion + akmod-nvidia
- `install-asus-pkg.sh` — ASUS ROG packages (asusctl, power-profiles-daemon)
- `install-kitty.sh` — Kitty terminal
- `configure-ptyxis.sh` — Ptyxis terminal settings
- `configure-monitor.sh` — Display layout (laptop + 4K external)
- `configure-gnome.sh` — GNOME settings via dconf
- `configure-zsh.sh` — Default shell + ~/.zshrc
- `configure-git.sh` — Git config + gh auth
- `configure-restic.sh` — Restic install + cron job
- `configure-docker.sh` — Rootless Docker setup

## Dependencies

External tools required:
- **System (RPM)**: nvim, tmux, zsh, fzf, fd, ripgrep, bat, lazygit, kitty, tree-sitter-cli, restic, rclone, mdadm, cryptsetup, smartmontools, parted, asusctl, power-profiles-daemon
- **Homebrew**: vim, gh, glow, pipx, neovim-remote
- **Flatpak**: Google Chrome, Ptyxis, various GNOME utilities, Surfshark
- **Font**: JetBrainsMono Nerd Font

## Environment Variables

| Variable | Value |
|---|---|
| `TOOLS_CONFIG_DIR` | `/home/navin/tools-config` |
| `TOOLS_CONFIG_DATA` | `${HOME}/.local/share/tools-config/` |
| `NVIM_APPNAME` | `lazyVim` |
| `EDITOR` / `VISUAL` | `nvim` |
| `BAT_CONFIG_PATH` | `${TOOLS_CONFIG_DIR}/configs/bat/config` |
| `FZF_DEFAULT_COMMAND` | `fd --hidden --strip-cwd-prefix --exclude .git` |
| `FZF_COMPLETION_TRIGGER` | `?` |
| `RESTIC_BACKUP_DEST` | `/run/media/navin/ex-hd-navin/google_backup/gdrive` |
| `RESTIC_PASSWORD_FILE` | `${HOME}/.config/restic/password` |
| `RESTIC_SOURCE` | `${HOME}/gdrive` |
| `MEDIA_MOUNT` | `${HOME}/media` |
| `ZSH` | `${TOOLS_CONFIG_DATA}oh-my-zsh` |

## Modifying Configurations

### Adding a New Tool Configuration
1. Create a directory: `configs/<tool-name>/`
2. Add configuration files
3. Create `<tool-name>.rc.sh` for shell initialization (auto-sourced by rc.sh)

### Editing Existing Configurations
- Edit files directly in `configs/<tool>/`
- After changes to `.rc.sh` files, reload by sourcing `rc.sh` or use the `s` alias

### Neovim Plugin Changes
- Add/modify plugins in `configs/lazyVim/lua/plugins/`
- LazyVim auto-detects and installs new plugins on next launch

### Tmux Plugin Management
- Add plugins to `tmux.conf`: `set -g @plugin 'author/name'`
- Install: prefix+I, Update: prefix+U, Uninstall: prefix+alt+u

## Ignored Files

`.gitignore` excludes:
- `lazy-lock.json` (LazyVim lock file)
- `configs/go` (Go toolchain)
- `configs/tmux/plugins` (managed by TPM)
- `node_modules`
- `.gitconfig` (contains user credentials)
