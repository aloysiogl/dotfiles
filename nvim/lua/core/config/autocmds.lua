-- easier to navigate tree
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better mappings for netrw',
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, { remap = true, buffer = true })
    end

    vim.keymap.set('v', "mf", ":normal mf<cr>", { remap = true, buffer = true })

    -- edit new file
    bind('c', '%')

    -- rename file
    bind('r', 'R')
  end
})

vim.api.nvim_create_autocmd('filetype', {
  pattern = 'haskell',
  desc = 'Mappings for haskell',
  callback = function()
    local ht = require('haskell-tools')
    local bufnr = vim.api.nvim_get_current_buf()
    local make_opts = function(desc)
      return { noremap = true, silent = true, buffer = bufnr, desc = desc }
    end
    -- haskell-language-server relies heavily on codeLenses,
    -- so auto-refresh (see advanced configuration) is enabled by default
    vim.keymap.set('n', '<leader>lc', vim.lsp.codelens.run, make_opts('vim.lsp.codelens.run'))
    -- Hoogle search for the type signature of the definition under the cursor
    vim.keymap.set('n', '<leader>lhs', ht.hoogle.hoogle_signature, make_opts('ht.hoogle.hoogle_signature'))
    -- Evaluate all code snippets
    vim.keymap.set('n', '<leader>lea', ht.lsp.buf_eval_all, make_opts('ht.lsp.buf_eval_all'))
    -- Toggle a GHCi repl for the current package
    vim.keymap.set('n', '<leader>lrr', ht.repl.toggle, make_opts('ht.repl.toggle'))
    -- Toggle a GHCi repl for the current buffer
    vim.keymap.set('n', '<leader>lrf', function()
      ht.repl.toggle(vim.api.nvim_buf_get_name(0))
    end, make_opts('ht.repl.toggle'))
    vim.keymap.set('n', '<leader>lrq', ht.repl.quit, make_opts('ht.repl.quit'))
  end
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     -- print the current event
--     vim.cmd('noh')
--     vim.cmd('redraw')
--     print("this is a test")
--   end
-- })
