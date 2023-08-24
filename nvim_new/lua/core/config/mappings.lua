-- movementmap
vim.keymap.set("n", "<leader>-", vim.cmd.Ex, { desc = "File explorer" })
vim.keymap.set("n", "-", "<C-o>", { desc = "Previous jump" })
vim.keymap.set("n", "=", "<C-i>", { desc = "Next jump" })

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
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close current buffer" })

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

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon add current file to list" })
vim.keymap.set("n", "<leader>c", ui.toggle_quick_menu, { desc = "Harpoon file list" })
vim.keymap.set("n", "<leader>w", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>q", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })

vim.keymap.set("n", "<C-e>", cmd_ui.toggle_quick_menu, { desc = "Harpoon commad list" })
vim.keymap.set("n", "<leader>e", function() tmux.sendCommand(5, 1) end, { desc = "Harpoon first command to termianal" })
vim.keymap.set("n", "<leader>t", function() tmux.gotoTerminal(5) end, { desc = "Harpoon open terminal" })

-- comments
vim.keymap.set("v", "<C-_>", "gc", { remap = true })

-- tmux navigation
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { silent = true })

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telecope find files" })
vim.keymap.set("n", "<leader><space>", builtin.find_files, { desc = "Telecope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {desc = "Telescope live grep"})
vim.keymap.set("n", "<leader>fm", builtin.keymaps, {desc = "Telescope find mapping/keybinding"})
vim.keymap.set("n", "<leader>,", builtin.buffers, {desc = "Telescope find buffer"})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {desc = "Telescope find help"})

--- easymotion
vim.g.EasyMotion_smartcase = 1
vim.keymap.set("n", "s", "<Plug>(easymotion-s)", { desc = "Easymotion s" })
vim.keymap.set("v", "s", "<Plug>(easymotion-s)", { desc = "Easymotion s" })
