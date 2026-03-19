-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use fzf for picker
vim.g.lazyvim_picker = "fzf"

-- Enable soft wrapping
vim.opt.wrap = true

-- Wrap lines after 80 characters
vim.opt.textwidth = 80

-- Disable relative line numbers
vim.opt.relativenumber = false

vim.o.autoread = true

vim.opt.scrolloff = 999

-- Highlight trailing whitespace with red background
vim.cmd([[match ExtraWhitespace /\s\+$/]])
vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "#4d0905" }) -- dark red
