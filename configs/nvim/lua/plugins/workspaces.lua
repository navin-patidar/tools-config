return {
  "natecraddock/workspaces.nvim",
  lazy = false,
  config = function()
    require("workspaces").setup {
      -- Optional: Add configuration options here, e.g., hooks
      hooks = {
        open = { "Telescope find_files" },
      },
    }
  end,
}
