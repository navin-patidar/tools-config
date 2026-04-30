-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Change CursorLine background based on current mode (focused window only)
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

-- Use a per-window namespace so Cursorline color only applies to focused window
local cursorline_ns = vim.api.nvim_create_namespace("mode_cursorline")

local function update_cursorline()
  local mode = vim.fn.mode():sub(1, 1)
  local color = mode_colors[mode] or mode_colors.n
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_hl_ns(win, cursorline_ns)
  vim.api.nvim_set_hl(cursorline_ns, "CursorLine", { bg = color })
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("ModeCursorLine", { clear = true }),
  callback = update_cursorline,
})

-- Highlight focused buffer - dim unfocused windows
vim.api.nvim_set_hl(0, "UnfocusedWindow", { bg = "#1a1a2e" })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("FocusedWindow", { clear = true }),
  callback = function()
    vim.wo.cursorline = true
    vim.wo.winhighlight = "Normal:Normal"
    update_cursorline()
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = vim.api.nvim_create_augroup("UnfocusedWindow", { clear = true }),
  callback = function()
    vim.wo.cursorline = false
    vim.api.nvim_win_set_hl_ns(vim.api.nvim_get_current_win(), 0)
    vim.wo.winhighlight = "Normal:UnfocusedWindow"
  end,
})

-- Sync yank register "0" with system clipboard "+"
-- Yank text go to system clipboard; deletes/changes do not
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("SyncYankToClipboard", { clear = true }),
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setreg("+", vim.fn.getreg("0"))
    end
  end,
})
