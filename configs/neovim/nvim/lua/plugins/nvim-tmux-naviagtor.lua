return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  vim.keymap.set('n', 'C-h', '<cmd><C-U>TmuxNavigateLeft<CR>'),
  vim.keymap.set('n', 'C-l', '<cmd><C-U>TmuxNavigateRight<CR>'),
  vim.keymap.set('n', 'C-j', '<cmd><C-U>TmuxNavigateDown<CR>'),
  vim.keymap.set('n', 'C-k', '<cmd><C-U>TmuxNavigateUp<CR>'),

}
