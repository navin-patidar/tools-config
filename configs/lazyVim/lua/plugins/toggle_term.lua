return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {},
  config = function()
    require("toggleterm").setup({
      autochdir = true,
      dir = "git_dir",
      open_mapping = "<leader>tt", --set the normal mode keymap
      on_open = function(term)
        -- Get the current buffer's directory
        local buf_dir = vim.fn.expand("#:p:h")
        -- Send 'cd' command to the terminal
        term:send("cd " .. buf_dir)
      end,
      direction = "float", -- open in floating window
      float_opts = {
        width = function()
          return math.ceil(vim.o.columns * 0.6) -- 60% of total columns
        end,
        height = function()
          return math.ceil(vim.o.lines * 0.8) -- 80% of total lines
        end,
        col = function()
          --Move terminal to right : tolal columns minus terminal width
          local width = math.ceil(vim.o.columns * 0.8)
          return vim.o.columns - width
        end,
        border = "curved",
      },
      -- other settings:
      start_in_insert = true,
      persist_size = true,
      winblend = 25,
    })
  end,
}
