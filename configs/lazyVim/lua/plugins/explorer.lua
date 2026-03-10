return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = {
              width = 40,
            },
            win = {
              list = {
                wo = {
                  wrap = true,
                },
                keys = {
                  [","] = "explorer_up",
                },
              },
            },
          },
        },
      },
    },
    init = function()
      -- Always open Snacks explorer on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("OpenExplorerOnStart", { clear = true }),
        callback = function()
          vim.schedule(function()
            Snacks.explorer.open()
          end)
        end,
      })
    end,
  },
}
