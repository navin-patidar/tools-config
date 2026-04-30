return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {},
  config = function()
    require("toggleterm").setup({
      autochdir = true,
      hidden = true,
      shell = vim.o.shell,
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

    -- Dedicated terminal for tmux "scratch" session
    local Termianl = require("toggleterm.terminal").Terminal
    local float_term = Termianl:new({
      cmd = "tmux new-session -A -s scratch",
      direction = "float",
      on_open = function(term)
        -- Get the current buffer's directory, skipping terminal buffers
        local alt_buf = vim.fn.bufnr("#")
        if alt_buf ~= -1 and vim.bo[alt_buf].buftype ~= "terminal" then
          local buf_dir = vim.fn.fnamemodify(vim.fn.bufname(alt_buf), ":p:h")
          term:send("cd " .. buf_dir)
        end
      end,
    })

    vim.keymap.set({ "n", "t" }, "<leader>tt", function()
      float_term:toggle()
    end, { desc = "Toggle scratch terminal" })

    -- Dedicated terminal for tmux "ai" session (vertical split)
    local ai_term = Termianl:new({
      cmd = "tmux new-session -A -s ai",
      direction = "vertical",
      on_open = function(term)
        vim.api.nvim_win_set_config(term.window, { split = "right" })
        vim.api.nvim_win_set_width(term.window, 80)
      end,
    })

    vim.keymap.set({ "n", "t" }, "<leader>ta", function()
      ai_term:toggle()
    end, { desc = "Toggle AI terminal" })
  end,
}
