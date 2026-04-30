# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a dotfiles/tools configuration repository that centralizes configuration files for various command-line tools and development environments. The repository uses XDG_CONFIG_HOME to organize configs under a single `configs/` directory, making configurations portable and version-controlled.

## Architecture

### Core Loading Mechanism

The `rc.sh` script at the repository root is the entry point that:
1. Sets `TOOLS_CONFIG_DIR` to the repository root
2. Exports `XDG_CONFIG_HOME` to point to `${TOOLS_CONFIG_DIR}/configs`
3. Automatically sources all `*.rc.sh` files found in the configs directory

To activate these configurations, users source `rc.sh` from their shell initialization files (e.g., `.zshrc`).

### Configuration Organization

Each tool has its own subdirectory under `configs/`:
- Configuration files live in `configs/<tool>/`
- Shell initialization scripts follow the naming pattern `<tool>.rc.sh`
- The `.rc.sh` files typically set environment variables and configure tool behavior

### Key Tool Configurations

**Neovim/LazyVim** (`configs/lazyVim/`, `configs/nvim/`):
- Primary editor setup using LazyVim distribution
- `NVIM_APPNAME=lazyVim` environment variable routes nvim to LazyVim configs
- Custom plugins configured in `lua/plugins/` for fzf, git, lazygit, leap, tmux navigation, and workspaces
- LSP and formatting configs in `lua/configs/`

**Tmux** (`configs/tmux/`):
- Configuration file: `tmux.conf`
- Uses TPM (Tmux Plugin Manager) with plugins for fzf integration, floating windows, session management, vim-tmux navigation, and catppuccin theme
- Custom key bindings: prefix+r (reload), prefix+o (sessionx), Ctrl+p (floax), Ctrl+f (fzf menu)
- Shell aliases for tmux operations defined in `tmux.rc.sh`

**Zsh** (`configs/zsh/`):
- Uses Oh My Zsh framework with powerlevel10k theme
- Plugins: git, dnf, fzf, alias-finder, zsh-vi-mode
- Custom aliases for vim→nvim, lazygit, and common commands
- Shell configuration in `zsh.rc.sh`

**FZF** (`configs/fzf/`):
- Custom key bindings: Ctrl+T (find files), Alt+C (find directories), Ctrl+W (ripgrep search)
- Integrates with `fd` for file finding and `bat` for previews
- Includes `fzf-git.sh` integration for git operations
- Custom completion trigger: `?` instead of `**`

**Ripgrep** (`configs/ripgrep/`):
- Custom `r_grep` function that combines ripgrep with fzf for interactive searching
- Opens results in nvim with quickfix list support
- Bound to Ctrl+W in zsh

**Bat** (`configs/bat/`):
- Solarized (dark) theme configured
- Syntax mappings for Arduino and gitignore files

**Git** (`configs/git/`):
- Basic user configuration in `git.config`
- Uses vim as editor

**Lazygit** (`configs/lazygit/`):
- Git TUI configuration in `config.yml`

## Dependencies

The configuration relies on these external tools being installed:
- `nvim` (Neovim)
- `tmux`
- `zsh` with Oh My Zsh
- `fzf` (fuzzy finder)
- `fd` (file finder)
- `bat` (cat clone with syntax highlighting)
- `ripgrep` (rg)
- `lazygit`
- `tree-sitter-cli` (npm package)

## Modifying Configurations

### Adding a New Tool Configuration

1. Create a directory: `configs/<tool-name>/`
2. Add configuration files to that directory
3. Optionally create `<tool-name>.rc.sh` for shell initialization
4. The `.rc.sh` file will be automatically sourced when the main `rc.sh` is loaded

### Editing Existing Configurations

- Tool configs: Edit files directly in `configs/<tool>/`
- Shell behavior: Modify the corresponding `.rc.sh` file
- After changes to `.rc.sh` files, reload by sourcing `rc.sh` again or use the `s` alias (sources `~/.zshrc`)

### Neovim Plugin Changes

- Add/modify plugins in `configs/lazyVim/lua/plugins/` or `configs/nvim/lua/plugins/`
- LazyVim will automatically detect and install new plugins on next launch

### Tmux Plugin Management

- Add plugins to `tmux.conf` using `set -g @plugin 'author/plugin-name'`
- Install plugins: prefix + I (capital i)
- Update plugins: prefix + U
- Uninstall plugins: prefix + alt + u

## Ignored Files

The `.gitignore` excludes:
- `lazy-lock.json` (LazyVim lock file)
- `configs/go` (Go toolchain)
- `configs/tmux/plugins` (Tmux plugins - managed by TPM)
- `node_modules` and npm files
