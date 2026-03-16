-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", ";", ":", { desc = "CMD enter command mode" })

vim.keymap.set({ "n", "v" }, "<leader>uet", require("stay-centered").toggle, { desc = "Toggle stay-centered.nvim" })

-- Command :dd to close current buffer
vim.api.nvim_create_user_command("Dd", function()
  Snacks.bufdelete()
end, { desc = "Close current buffer" })
vim.cmd([[cabbrev dd Dd]])

-- Normal mode
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Switch to left pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Switch to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Switch to top pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Switch to right pane" })

-- terminal mode
-- Bypass Ctrl+{h,j,k,l} in terminal buffer - send them directly to the terminal
-- application.
vim.keymap.set("t", "<C-h>", "<C-h>", { noremap = true, silent = true, desc = "Send C-h to terminal" })
vim.keymap.set("t", "<C-j>", "<C-j>", { noremap = true, silent = true, desc = "Send C-j to terminal" })
vim.keymap.set("t", "<C-k>", "<C-k>", { noremap = true, silent = true, desc = "Send C-k to terminal" })
vim.keymap.set("t", "<C-l>", "<C-l>", { noremap = true, silent = true, desc = "Send C-l to terminal" })
-- Bypass Esc in terminal buffer - send them directly to the terminal
-- application
vim.keymap.set("t", "<Esc>", "<Esc>", { noremap = true, silent = true, desc = "Send Esc to terminal" })

-- Use jk keys to switch to normal mode from terminal mode in terminal
vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
-- Map <Leader>bt to open a terminal in a new tab
vim.api.nvim_set_keymap("n", "<leader>tb", ":term<CR>", { noremap = true, silent = true })
-- Map <leader>th to open a terminal in horizontal orientation
vim.keymap.set("n", "<leader>th", ":split | term<CR>", { noremap = true, silent = true })
-- Map <leader>tv to open a terminal in vertical orientation
vim.keymap.set("n", "<leader>tv", ":vsplit | term<CR>")

function exec(cmd, dir, direction, name, go_back)
  require("toggleterm").exec(cmd .. " ; exit", 1, 12, dir, direction, name, go_back, true)
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>ts",
  "<cmd> lua exec('ts', nil, 'float', 'TMUX Teminals', true) <CR>",
  { desc = "Switch to TMUX terminal", noremap = true, silent = true }
)
