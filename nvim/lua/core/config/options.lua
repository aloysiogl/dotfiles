local opt = vim.opt

opt.number = true             -- Line numbers
opt.wrap = true               -- Line wrap
opt.relativenumber = true     -- Relative line numbers
opt.hls = true                -- Highlight after search
opt.expandtab = true          -- Use spaces instead of tabs
opt.tabstop = 2               -- Number of spaces tabs count for
opt.shiftround = true         -- Round indent
opt.shiftwidth = 2            -- Size of an indent
opt.incsearch = true          -- Search as characters are entered
opt.grepprg = "rg --vimgrep"
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.smartcase = true          -- Search case sensitive if there is a capital letter only

-- netrw do not show ./ or ../
vim.g.netrw_list_hide = "^\\./$,^\\../$"
vim.g.netrw_hide = 1

-- bufstop
vim.g.BufstopDismissKey = "q"
vim.g.BufstopAutoSpeedToggle = 1
vim.g.BufstopLeader = "<BS>"
vim.g.BufstopSpeedKeys = { "a", "s", "d", "f", "g", "h" }

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vimtex
vim.g.vimtex_compiler_latexmk = {
  aux_dir = '',
  out_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = {
    '-verbose',
    '-file-line-error',
    '-pdflatex=lualatex',
    '-synctex=1',
    '-r ' .. vim.fn.getcwd() .. '/latexmkrc',
    '-interaction=nonstopmode',
  },
}

vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_view_method = 'zathura'

vim.g.vimtex_complete_bib = {
  ['custom_patterns'] = { 'ncite' }
}

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
