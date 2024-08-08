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
    -- Hoogle search for the type signature of the definition under the cursor
    vim.keymap.set('n', '<leader>lhs', ht.hoogle.hoogle_signature, make_opts('ht.hoogle.hoogle_signature'))
    vim.keymap.set('n', '<leader>lc', vim.lsp.codelens.run, make_opts('vim.lsp.codelens.run'))
    -- Evaluate all code snippets
    vim.keymap.set('n', '<leader>lea', ht.lsp.buf_eval_all, make_opts('ht.lsp.buf_eval_all'))
    -- Repl configs
    -- Toggle a GHCi repl for the current package
    vim.keymap.set('n', '<leader>lm',
      function()
        vim.keymap.del('n', '<leader>lr', { buffer = bufnr })
        local plugin = require("lazy.core.config").plugins["which-key.nvim"]
        require("lazy.core.loader").reload(plugin)
        local wk = require('which-key')
        wk.register({
          ["<leader>l"] = { name = "Language server" },
          -- ["<leader>lr"] = { name = "Repl" },
        })
        vim.keymap.set('n', '<leader>lrr', ht.repl.toggle, make_opts('ht.repl.toggle'))
        vim.keymap.set('n', '<leader>lrp', ht.repl.paste, make_opts('ht.repl.paste'))
        vim.keymap.set('n', '<leader>lrt', ht.repl.paste_type, make_opts('ht.repl.paste_type'))
        -- Toggle a GHCi repl for the current buffer
        vim.keymap.set('n', '<leader>lrf', function()
          ht.repl.toggle(vim.api.nvim_buf_get_name(0))
        end, make_opts('ht.repl.toggle'))
        vim.keymap.set('n', '<leader>lrq', ht.repl.quit, make_opts('ht.repl.quit'))
      end
      , { desc = 'Set hakell keymaps' })
  end
})

vim.api.nvim_create_autocmd('filetype', {
  pattern = 'tex',
  desc = 'Mappings for latex',
  callback = function()
    vim.keymap.set("n", "<leader>vv", "<plug>(vimtex-view)", { desc = "no", noremap = true })
    wk = require("which-key")
    wk.register({
      v = {
        name = "Vimtex",
        v = { "<plug>(vimtex-view)", "Vimtex view" },
        c = { "<plug>(vimtex-compile)", "Vimtex compile" },
      },
    }, {
      prefix = "<leader>",
    })
  end
})
-- vim.api.nvim_create_autocmd("filetype", {
--   pattern = 'NvimTree',
--   callback = function()
--   end
-- })

-- vim.api.nvim_create_autocmd("CursorMoved", {
--   callback = function()
--     local api = require('nvim-tree.api')
--     local node = api.tree.get_node_under_cursor()
--     if node ~= nil and node.nodes == nil then
--       api.node.open.edit(node)
--       api.tree.focus()
--     end
--   end
-- })

-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     -- print the current event
--     vim.cmd('noh')
--     vim.cmd('redraw')
--     print("this is a test")
--   end
--
-- })

-- TODO: do it properly in lua
vim.api.nvim_exec([[
augroup KeepCentered
  autocmd!
  autocmd CursorMoved * normal! zz
  autocmd TextChangedI * call InsertRecenter()
augroup END

function InsertRecenter() abort
  let at_end = getcursorcharpos()[2] > len(getline('.'))
  normal! zz

  " Fix position of cursor at end of line
  if at_end
    let cursor_pos = getcursorcharpos()
    let cursor_pos[2] = cursor_pos[2] + 1
    call setcursorcharpos(cursor_pos[1:])
  endif
endfunction
]], false)

vim.api.nvim_exec([[
autocmd TermOpen * setlocal nonumber norelativenumber
]], false)

local o				= vim.o		-- options
local wo			= vim.wo	-- window options

-- Terminal
vim.api.nvim_create_autocmd({"TermOpen"}, {
	pattern = { "term://*" },
	callback = function()
		wo.relativenumber	= false
		wo.number			= false
		o.signcolumn		= "no"

		vim.cmd([[ startinsert ]])
	end,
})

-- local function InsertRecenter()
--   local at_end = vim.fn.getcurpos()[3] > #vim.fn.getline('.')
--   vim.api.nvim_command('normal! zz')
--
--   -- Fix position of cursor at end of line
--   if at_end then
--     local cursor_pos = vim.fn.getcurpos()
--     cursor_pos[3] = cursor_pos[3] + 1
--     vim.fn.setpos('.', cursor_pos)
--   end
-- end
--
-- vim.api.nvim_command('command! -nargs=0 InsertRecenter lua InsertRecenter()')

