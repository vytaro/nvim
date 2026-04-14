---@diagnostic disable: deprecated, return-type-mismatch
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'

      conform.setup {
        format_on_save = {
          timeout_ms = 3000,
          lsp_fallback = true,
        },

        formatters = {
          pint_local = {
            command = 'pint',
            stdin = false,
            cwd = function(self, ctx)
              local util = require('lspconfig').util
              return util.search_ancestors(ctx.filename, function(path)
                if util.path.exists(util.path.join(path, 'artisan')) then
                  return path
                end
              end)
            end,
            args = function(self, ctx)
              return { ctx.filename }
            end,
          },
        },

        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          json = { 'prettier' },
          html = { 'prettier' },
          css = { 'prettier' },
          vue = { 'prettier' },
          sh = { 'shfmt' },
          nix = { 'nixfmt' },
          ejs = { 'prettier' },
          go = { 'go fmt' },
          php = function()
            local util = require('lspconfig').util
            local fname = vim.api.nvim_buf_get_name(0)
            local laravel_root = util.search_ancestors(fname, function(path)
              return util.path.exists(util.path.join(path, 'artisan'))
            end)
            if laravel_root then
              return { 'pint_local' }
            end
            return { 'php-cs-fixer' }
          end,
          qml = { 'qmlfmt' },
          rust = { 'rustfmt' },
        },
      }

      -- vim.api.nvim_create_autocmd('BufWritePre', {
      --   callback = function(args)
      --     local name = vim.api.nvim_buf_get_name(args.buf)
      --     if name:match 'Makefile$' then
      --       return
      --     end
      --
      --     require('conform').format { bufnr = args.buf }
      --
      --     local view = vim.fn.winsaveview()
      --     vim.cmd [[%s/\t/    /ge]]
      --     vim.fn.winrestview(view)
      --   end,
      -- })
    end,
  },
}
