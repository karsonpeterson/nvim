return {
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    init = function()
      vim.keymap.set('n', '<C-n>', '<cmd> NvimTreeToggle <CR>', {})
      vim.keymap.set('n', '<leader>e', '<cmd> NvimTreeFocus <CR>', {})
    end,
    config = function(_, opts)
      require('nvim-tree').setup(opts)
    end,
  },
}
