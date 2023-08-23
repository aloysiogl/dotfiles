-- movementmap
vim.keymap.set("n", "<leader>-", vim.cmd.Ex)
vim.keymap.set("n", "-", "<C-o>")
vim.keymap.set("n", "=", "<C-i>")

vim.keymap.set("n", "J", "9j", { silent = true })
vim.keymap.set("n", "J", "9j", { silent = true })
vim.keymap.set("n", "K", "9k", { silent = true })
vim.keymap.set("n", "K", "9k", { silent = true })

vim.keymap.set("c", "<C-j>", "<C-g>", { desc = "Next in search mode" })
vim.keymap.set("c", "<C-k>", "<C-t>", { desc = "Prevous in search mode" })

vim.keymap.set("n", "<leader>b", "<cmd>BufstopPreview<cr>", { silent = true })

-- utilities
vim.keymap.set("i", "jk", "<ESC>", { silent = true })

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", { desc = "LazyGit" })

vim.keymap.set("v", "q", "<ESC>", { desc = "Quite visual mode" })

vim.keymap.set("c", "jk", "<CR>", { silent = true }) --quit search
-- vim.keymap.set("c", "<CR>", "<cmd>noh<CR>", { desc = "Close highlight after search" })

-- search
vim.keymap.set("n", "z/", "<cmd>FuzzySearch<cr>", { desc = "Fuzzy Search within buffer", noremap = true })

-- harpoon
local mark = require("harpoon.mark")
local tmux = require("harpoon.tmux")
local ui = require("harpoon.ui")
local cmd_ui = require("harpoon.cmd-ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>c", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>w", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>q", function() ui.nav_file(2) end)

vim.keymap.set("n", "<C-e>", cmd_ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>e", function() tmux.sendCommand(5,1) end)
vim.keymap.set("n", "<leader>t", function() tmux.gotoTerminal(5) end)

-- comments
vim.keymap.set("v", "<C-_>", "gc", {remap = true})

-- tmux navigation
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { silent = true })

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader><space>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fm', builtin.keymaps, {})
vim.keymap.set('n', '<leader>,', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--- easymotion
vim.g.EasyMotion_smartcase = 1
vim.keymap.set("n", "s", "<Plug>(easymotion-s)", { desc = "Easymotion s" })
vim.keymap.set("v", "s", "<Plug>(easymotion-s)", { desc = "Easymotion s" })
