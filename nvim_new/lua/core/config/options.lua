local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true  -- Use spaces instead of tabs
opt.tabstop = 2       -- Number of spaces tabs count for
opt.shiftround = true -- Round indent
opt.shiftwidth = 2    -- Size of an indent

-- netrw do not show ./ or ../
vim.g.netrw_list_hide = "^\\./$,^\\../$"
vim.g.netrw_hide = 1
