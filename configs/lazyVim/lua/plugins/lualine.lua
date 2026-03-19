return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 1, {
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if #clients == 0 then
            return ""
          end
          local names = {}
          for _, client in ipairs(clients) do
            table.insert(names, client.name)
          end
          return table.concat(names, ", ")
        end,
        icon = "",
        color = { fg = "#98be65" },
      })

      opts.winbar = {
        lualine_a = {},
        lualine_b = { { "filename", path = 1 } },
        lualine_c = {
          {
            function()
              local navic = require("nvim-navic")
              if navic.is_available() then
                return navic.get_location()
              end
              return ""
            end,
            cond = function()
              return require("nvim-navic").is_available()
            end,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
      opts.inactive_winbar = {
        lualine_a = {},
        lualine_b = { { "filename", path = 1 } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
    end,
  },
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    opts = {
      lsp = { auto_attach = true },
      highlight = true,
      separator = " > ",
      depth_limit = 5,
    },
  },
}
