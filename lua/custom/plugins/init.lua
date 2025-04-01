return {
  { 'mfussenegger/nvim-jdtls' },
  {
    'windwp/nvim-autopairs',
    opts = {
      fast_wrap = {},
      disable_filetype = { 'TelescopePrompt', 'vim' },
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = 'v4.7.0',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true

      vim.keymap.set('n', '<tab>', '<cmd> BufferLineCycleNext <CR>', {})
      vim.keymap.set('n', '<S-tab>', '<cmd> BufferLineCyclePrev <CR>', {})
      require('bufferline').setup {}
    end,
  },
  {
    'mfussenegger/nvim-dap',
    init = function()
      vim.keymap.set('n', '<leader>dbt', '<cmd> DapToggleBreakpoint <CR>', {})
      vim.keymap.set('n', '<leader>dbos', function()
        local widgets = require 'dap.ui.widgets'
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end, {})
      vim.keymap.set('n', '<leader>dbs', function()
        local dap = require 'dap'
        dap.continue()
      end, {})
      vim.keymap.set('n', '<leader>dbe', function()
        local dap = require 'dap'
        dap.terminate()
      end, {})
    end,
  },
}
