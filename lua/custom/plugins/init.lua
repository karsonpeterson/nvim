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
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
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
    config = function()
      local dap = require 'dap'

      -- Java Debug adapter configuration
      dap.adapters.java = function(callback, config)
        callback {
          type = 'server',
          host = '127.0.0.1',
          port = tonumber(config.port),
        }
      end

      -- Java debug configurations
      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = 'Debug (Attach) - Remote',
          host = '127.0.0.1',
          port = 5005,
        },
        -- {
        --   type = 'java',
        --   request = 'attach',
        --   name = 'Debug (Attach) - Remote',
        --   hostName = 'localhost',
        --   port = function()
        --     local port = vim.fn.input('Debug Port: ', '5005')
        --     return tonumber(port)
        --   end,
        -- },
        {
          type = 'java',
          request = 'launch',
          name = 'Debug Spring Boot Application',
          mainClass = '${file}',
          projectName = '${workspaceFolder}',
        },
      }
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = 'claude',
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-3-5-sonnet-20241022',
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 4096,
        disable_tools = true, -- disable tools!
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
    },
  },
}
