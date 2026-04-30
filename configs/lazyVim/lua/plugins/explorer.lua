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
  },
}
