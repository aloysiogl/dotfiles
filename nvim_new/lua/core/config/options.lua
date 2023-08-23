local opt = vim.opt

opt.number = true         -- Line numbers
opt.wrap = true           -- Line wrap
opt.relativenumber = true -- Relative line numbers
opt.hls = true            -- Highlight after search
opt.expandtab = true      -- Use spaces instead of tabs
opt.tabstop = 2           -- Number of spaces tabs count for
opt.shiftround = true     -- Round indent
opt.shiftwidth = 2        -- Size of an indent
opt.incsearch = true      -- Search as characters are entered

-- netrw do not show ./ or ../
vim.g.netrw_list_hide = "^\\./$,^\\../$"
vim.g.netrw_hide = 1

-- bufstop
vim.g.BufstopDismissKey = "q"
vim.g.BufstopAutoSpeedToggle = 1
