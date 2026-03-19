return {
  "folke/noice.nvim",
  opts = {
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim", view = "cmdline_popup" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", view = "cmdline_popup" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", view = "cmdline_popup" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash", view = "cmdline_popup" },
        lua = {
          pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
          icon = "",
          lang = "lua",
          view = "cmdline_popup",
        },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "", view = "cmdline_popup" },
        input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
      },
    },
    views = {
      cmdline_popup = {
        position = {
          row = 0,
          col = 0,
        },
        relative = "cursor",
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
        },
      },
    },
  },
}
