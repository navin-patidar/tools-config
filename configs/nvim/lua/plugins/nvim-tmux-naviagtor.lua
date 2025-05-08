return {
  "christoomey/vim-tmux-navigator",
  Lazy = false,
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  
 keys = {
   { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
   { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
   { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
   { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
   { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
 },

  -- vim.keymap.set('n', 'C-h', '<cmd><C-U>TmuxNavigateLeft<CR>'),
  -- vim.keymap.set('n', 'C-l', '<cmd><C-U>TmuxNavigateRight<CR>'),
  -- vim.keymap.set('n', 'C-j', '<cmd><C-U>TmuxNavigateDown<CR>'),
  -- vim.keymap.set('n', 'C-k', '<cmd><C-U>TmuxNavigateUp<CR>'),

}
