-- Task: Inlay Hints | Never modify init.lua
local function setup_inlay_hints()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })

  -- Custom prefixes handler
  local original_handler = vim.lsp.handlers['textDocument/inlayHint']
  vim.lsp.handlers['textDocument/inlayHint'] = function(err, result, ctx, config)
    if not result then
      return original_handler(err, result, ctx, config)
    end

    for _, hint in ipairs(result) do
      local label = hint.label
      local prefix = ''
      if hint.kind == 1 then -- Type
        prefix = 'τ '
      elseif hint.kind == 2 then -- Parameter
        prefix = 'ρ '
      end

      if type(label) == 'string' then
        if not label:match('^' .. prefix) then
          hint.label = prefix .. label
        end
      elseif type(label) == 'table' then
        if label[1] and label[1].value and not label[1].value:match('^' .. prefix) then
          label[1].value = prefix .. label[1].value
        end
      end
    end
    return original_handler(err, result, ctx, config)
  end

  vim.keymap.set('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'Toggle Inlay Hints globally' })
end

setup_inlay_hints()
