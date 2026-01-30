-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.setmap("n", ";", ":", { desc = "CMD enter command mode" })

-- Normal mode
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch to left pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch to top pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch to right pane" })

-- terminal mode
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Switch to left pane" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Switch to bottom pane" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Switch to top pane" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Switch to right pane" })

-- Use jk keys to switch to normal mode from terminal mode in terminal
vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
-- Map <Leader>bt to open a terminal in a new tab
vim.api.nvim_set_keymap("n", "<leader>bt", ":tabnew | :terminal<CR>", { noremap = true, silent = true })
-- Map <leader>th to open a terminal in horizontal orientation
vim.keymap.set("n", "<leader>th", ":split | terminal<cr>", { noremap = true, silent = true })
-- Map <leader>tv to open a terminal in vertical orientation
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>")

