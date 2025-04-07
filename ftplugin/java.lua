local home = os.getenv 'HOME'
local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end

-- Get the current extendedClientCapabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities

-- Locate JAR files for java-debug-adapter
local path_to_jdtls = home .. '/.local/share/nvim/mason/packages/jdtls'
local path_to_jdebug = home .. '/.local/share/nvim/mason/packages/java-debug-adapter'
local path_to_jtest = home .. '/.local/share/nvim/mason/packages/java-test'

local bundles = {}

-- java-debug-adapter bundles
vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jdebug .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n'))

-- java-test bundles
vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jtest .. '/extension/server/*.jar'), '\n'))

-- Main configuration for JDTLS
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. path_to_jdtls .. '/lombok.jar',
    '-jar',
    vim.fn.glob(path_to_jdtls .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    path_to_jdtls .. '/config_mac_arm',
    '-data',
    workspace_dir,
  },
  root_dir = require('jdtls.setup').find_root { '.git', 'settings.gradle', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },

  -- Here you can configure eclipse.jdt.ls specific settings
  settings = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
      import = {
        gradle = {
          enabled = true,
          wrapper = {
            enabled = true,
          },
        },
        maven = {
          enabled = true,
        },
        exclusions = {
          '**/node_modules/**',
          '**/.metadata/**',
          '**/archetype-resources/**',
          '**/META-INF/maven/**',
          '**/api-specs/**',
          '**/docs/**',
        },
      },
    },
  },

  -- Language server setup
  capabilities = vim.lsp.protocol.make_client_capabilities(),

  -- Debugging setup
  init_options = {
    bundles = bundles,
  },
}

config['on_attach'] = function(client, bufnr)
  require('jdtls').setup_dap { hotcodereplace = 'auto', config_overrides = {} }

  local status_ok, jdtls_dap = pcall(require, 'jdtls.dap')
  if status_ok then
    jdtls_dap.setup_dap_main_class_configs()
  end
end

-- Start the JDTLS server
require('jdtls').start_or_attach(config)

-- Set up LSP keymaps
vim.keymap.set('n', '<leader>co', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = 'Organize Imports' })
vim.keymap.set('n', '<leader>crv', "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = 'Extract Variable' })
vim.keymap.set('v', '<leader>crv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = 'Extract Variable' })
vim.keymap.set('n', '<leader>crc', "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", { desc = 'Extract Constant' })
vim.keymap.set('v', '<leader>crm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = 'Extract Method' })

-- Setup DAP
local dap = require 'dap'

dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = 'Debug (Attach) - Remote',
    hostName = '127.0.0.1',
    port = 5005,
  },
}

-- Debugging keymaps
vim.keymap.set('n', '<leader>dj', function()
  require('jdtls.dap').setup_dap_main_class_configs()
  print 'Java debugger configuration refreshed'
end, { desc = 'Debug: Refresh Java Config' })
