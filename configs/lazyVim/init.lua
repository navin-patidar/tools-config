-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Detect stdin input so we don't restore session when piping
vim.api.nvim_create_autocmd("StdinReadPre", {
  group = vim.api.nvim_create_augroup("DetectStdin", { clear = true }),
  callback = function()
    vim.g.started_with_stdin = true
  end,
})

-- Auto restore previous session when opening nvim without file argument
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("RestoreSession", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      require("persistence").load({ last = true })
    end
  end,
  nested = true,
})
