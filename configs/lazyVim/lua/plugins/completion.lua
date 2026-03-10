return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<S-Tab>"] = { "accept", "fallback" },
        ["<S-CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Esc>"] = { "hide", "fallback" },
        ["<CR>"] = { "fallback" },
      },
    },
  },
}
