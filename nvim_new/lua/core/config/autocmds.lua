-- easier to navigate tree
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better mappings for netrw',
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, { remap = true, buffer = true })
    end

    -- edit new file
    bind('c', '%')

    -- rename file
    bind('r', 'R')
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
