require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

vim.keymap.set('n', 'C-h', '<cmd><C-U>TmuxNavigateLeft<CR>')
vim.keymap.set('n', 'C-l', '<cmd><C-U>TmuxNavigateRight<CR>')
vim.keymap.set('n', 'C-j', '<cmd><C-U>TmuxNavigateDown<CR>')
vim.keymap.set('n', 'C-k', '<cmd><C-U>TmuxNavigateUp<CR>')

-- Window navigation key maps
--map('n', '<c-k>', ':wincmd k<CR>')
--map('n', '<c-j>', ':wincmd j<CR>')
--map('n', '<c-h>', ':wincmd h<CR>')
--map('n', '<c-l>', ':wincmd l<CR>')
