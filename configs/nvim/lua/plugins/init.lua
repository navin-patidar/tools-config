return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
    enable = true,
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },

   {
    "nvim-treesitter/nvim-treesitter",
    opts = {
   		ensure_installed = {
   			"vim", "lua", "vimdoc", "cpp", "python", "bash",
        "html", "css"
   		},
   	},
   },
}
