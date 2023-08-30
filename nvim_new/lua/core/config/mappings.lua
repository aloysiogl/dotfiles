-- movement
vim.keymap.set("n", "<leader>-", vim.cmd.Ex, { desc = "File explorer" })
vim.keymap.set("n", "-", "<C-o>", { desc = "Previous jump" })
vim.keymap.set("n", "=", "<C-i>", { desc = "Next jump" })

vim.keymap.set("n", "J", "9j", { silent = true })
vim.keymap.set("n", "J", "9j", { silent = true })
vim.keymap.set("n", "K", "9k", { silent = true })
vim.keymap.set("n", "K", "9k", { silent = true })
-- quit teminal mode to normal mode
vim.keymap.set("t", "<leader><space>", "<C-\\><C-n>", { desc = "Quit terminal mode" })

--quickfix
vim.keymap.set("n", "<leader>aj", "<cmd>cn<cr>", { desc = "Next in quickfix list" })
vim.keymap.set("n", "<leader>ak", "<cmd>cp<cr>", { desc = "Previous in quickfix list" })
vim.keymap.set("n", "<leader>aq", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
vim.keymap.set("n", "<leader>ao", "<cmd>copen<cr>", { desc = "Open quickfix list" })

vim.keymap.set("c", "<C-j>", "<C-g>", { desc = "Next in search mode" })
vim.keymap.set("c", "<C-k>", "<C-t>", { desc = "Prevous in search mode" })


vim.keymap.set("n", "<leader>b", "<cmd>BufstopPreview<cr>", { silent = true })

-- utilities
vim.keymap.set("i", "jk", "<ESC>", { silent = true })

vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gd", "<cmd>Git difftool --name-only<cr>", { desc = "Previous in quickfix list" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close current buffer" })

vim.keymap.set("v", "q", "<ESC>", { desc = "Quite visual mode" })

vim.keymap.set("c", "jk", "<CR>", { silent = true }) --quit search
-- vim.keymap.set("c", "<CR>", "<cmd>noh<CR>", { desc = "Close highlight after search" })

-- search
vim.keymap.set("n", "z/", "<cmd>FuzzySearch<cr>", { desc = "Fuzzy Search within buffer", noremap = true })

--spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})

-- harpoon
local mark = require("harpoon.mark")
local term = require("harpoon.term")
local ui = require("harpoon.ui")
local cmd_ui = require("harpoon.cmd-ui")

vim.keymap.set("n", "<leader>ca", mark.add_file, { desc = "Harpoon add current file to list" })
vim.keymap.set("n", "<leader>cf", ui.toggle_quick_menu, { desc = "Harpoon file list" })
vim.keymap.set("n", "<leader>w", function() ui.nav_file(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>q", function() ui.nav_file(2) end, { desc = "Harpoon file 2" })

vim.keymap.set("n", "<leader>cc", cmd_ui.toggle_quick_menu, { desc = "Harpoon command list" })
vim.keymap.set("n", "<leader>e", function() term.sendCommand(1, 1) end, { desc = "Harpoon first command to termianal" })
vim.keymap.set("n", "<leader>ct", function() term.gotoTerminal(1) end, { desc = "Harpoon open terminal" })

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
