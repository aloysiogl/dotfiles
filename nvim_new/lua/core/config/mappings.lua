-- movement
vim.keymap.set("i", "jk", "<ESC>", { silent = true })
vim.keymap.set("n", "-", vim.cmd.Ex)

vim.keymap.set("n", "J", "9j", { silent = true })
vim.keymap.set("n", "J", "9j", { silent = true })
vim.keymap.set("n", "K", "9k", { silent = true })
vim.keymap.set("n", "K", "9k", { silent = true })

-- utilities
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>g", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- harpoon
local mark = require("harpoon.mark")
local tmux = require("harpoon.tmux")
local ui = require("harpoon.ui")
local cmd_ui = require("harpoon.cmd-ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>c", cmd_ui.toggle_quick_menu)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>q", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>w", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>t", function() tmux.gotoTerminal(5) end)
vim.keymap.set("n", "<leader>e", function() tmux.sendCommand(5,1) end)

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
vim.keymap.set('n', '<leader>,', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--- easymotion
vim.g.EasyMotion_smartcase = 1
vim.keymap.set("n", "s", "<Plug>(easymotion-s)", { desc = "Easymotion s" })
vim.keymap.set("v", "s", "<Plug>(easymotion-s)", { desc = "Easymotion s" })
