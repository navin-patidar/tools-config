-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Change CursonLine background based on current mode
local mode_colors = {
  n = "#1a1a2e", -- normal: dark blue
  i = "#2d4a01", -- insert: dark green
  t = "#2d4a01", -- terminal: dark green
  v = "#2e1a2e", -- visual: dark purple
  V = "#2e1a2e", -- visual: dark purple
  ["\22"] = "#2e1a2e", -- visual line
  R = "#2e1a1a", -- replace: dark red
  c = "#9e7505", -- command: dark yellow
}
vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("ModeCursorLine", { clear = true }),
  callback = function()
    local mode = vim.fn.mode():sub(1, 1)
    local color = mode_colors[mode] or mode_colors.n
    vim.api.nvim_set_hl(0, "CursonLine", { bg = color })
  end,
})
-- Automatically enter terminal mode when entering a terminal buffer
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("TerminalInsertMode", { clear = true }),
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})
