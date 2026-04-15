return {
  {
    'williamboman/mason.nvim',
    build = require('nixCatsUtils').lazyAdd ':MasonUpdate',
    config = require('nixCatsUtils').lazyAdd(true, false),
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = require('nixCatsUtils').lazyAdd {
          'cmake',
          'pyright',
          'html',
          'cssls',
          'emmet_ls',
          'lua_ls',
          'gopls',
          'bashls',
          'vtsls',
          'vue_ls',
          'dockerls',
          'docker_compose_language_service',
          'marksman',
          -- "jsonls",
          -- "intelephense",
          'qmlls',
          'intelephense',
          'rust_analyzer',
          'jdtls',
        },
        automatic_installation = require('nixCatsUtils').lazyAdd(true, false),
      }
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = require('nixCatsUtils').lazyAdd {
        'prettier',
        'stylua',
        'black',
        'shfmt',
        'php-cs-fixer',
      },
      auto_update = false,
      run_on_start = require('nixCatsUtils').lazyAdd(true, false),
    },
  },
}
