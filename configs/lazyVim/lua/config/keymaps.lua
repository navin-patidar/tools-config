-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- Use ctrl+ESC to switch to normal mode from terminal mode in terminal
vim.api.nvim_set_keymap("t", "<C-n>", "<C-\\><C-n>", { noremap = true, silent = true })
