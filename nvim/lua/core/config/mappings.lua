local wk = require("which-key")

-- command mode
vim.keymap.set("n", ";", ":", {
    desc = "Previous jump"
})

-- movement
vim.keymap.set("n", "<leader>-", vim.cmd.Ex, {
    desc = "File explorer"
})
vim.keymap.set("n", "-", "<C-o>", {
    desc = "Previous jump"
})
vim.keymap.set("n", "=", "<C-i>", {
    desc = "Next jump"
})

-- vim.keymap.set("n", "j", "jzz", { noremap = true })
-- vim.keymap.set("n", "k", "kzz", { noremap = true })

vim.keymap.set({"n", "v"}, "J", "<C-d>", {
    silent = true
})
vim.keymap.set({"n", "v"}, "K", "<C-u>", {
    silent = true
})
vim.keymap.set({"n"}, "<leader>w", function()
    require("flash").jump({
        labels = "asdfghjklqwertyuiopzxcvbnm",
        search = {
            mode = "search",
            max_length = 0
        },
        label = {
            after = {0, 0}
        },
        pattern = "^"
    })
end, {
    desc = "Next in quickfix list"
})

-- quit teminal mode to normal mode
vim.keymap.set("t", "jk", "<C-\\><C-n>", {
    desc = "Quit terminal mode"
})

-- quickfix
vim.keymap.set("n", "<leader>aj", "<cmd>cn<cr>", {
    desc = "Next in quickfix list"
})
vim.keymap.set("n", "<leader>ak", "<cmd>cp<cr>", {
    desc = "Previous in quickfix list"
})
vim.keymap.set("n", "<leader>aq", "<cmd>cclose<cr>", {
    desc = "Close quickfix list"
})
vim.keymap.set("n", "<leader>ao", "<cmd>copen<cr>", {
    desc = "Open quickfix list"
})

vim.keymap.set("c", "<C-j>", "<C-g>", {
    desc = "Next in search mode"
})
vim.keymap.set("c", "<C-k>", "<C-t>", {
    desc = "Prevous in search mode"
})

vim.keymap.set("n", "<leader>b", "<cmd>BufstopPreview<cr>", {
    silent = true
})

-- utilities
vim.keymap.set("i", "jk", "<ESC>", {
    silent = true
})

vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", {
    desc = "Lazy"
})
-- Git
vim.keymap.set("n", "<leader>gg", "<cmd>DiffviewOpen<cr>", {
    desc = "Open Diffview"
})
-- vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", {
--     desc = "LazyGit"
-- })
vim.keymap.set("n", "<leader>gd", "<cmd>Git difftool --name-only<cr>", {
    desc = "Previous in quickfix list"
})
vim.keymap.set("n", "<leader>x", "<cmd>bd<cr>", {
    desc = "Close current buffer"
})

vim.keymap.set("v", "q", "<ESC>", {
    desc = "Quite visual mode"
})

-- vim.keymap.set("c", "<CR>", "<cmd>noh<CR>", { desc = "Close highlight after search" })

-- search
vim.keymap.set("n", "z/", "<cmd>FuzzySearch<cr>", {
    desc = "Fuzzy Search within buffer",
    noremap = true
})

-- spectre
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

local harpoon_prefix = "<leader>i"
wk.add({{
    harpoon_prefix,
    group = "Harpoon"
}})

vim.keymap.set("n", harpoon_prefix .. "a", mark.add_file, {
    desc = "Harpoon add current file to list"
})
vim.keymap.set("n", harpoon_prefix .. "f", ui.toggle_quick_menu, {
    desc = "Harpoon file list"
})
vim.keymap.set("n", "<leader>w", function()
    ui.nav_file(1)
end, {
    desc = "Harpoon file 1"
})
vim.keymap.set("n", "<leader>q", function()
    ui.nav_file(2)
end, {
    desc = "Harpoon file 2"
})

vim.keymap.set("n", harpoon_prefix .. "c", cmd_ui.toggle_quick_menu, {
    desc = "Harpoon command list"
})
vim.keymap.set("n", "<BS>e", function()
    term.sendCommand(1, 1)
end, {
    desc = "Harpoon first command to termianal"
})
vim.keymap.set("n", "<BS>c", function()
    term.gotoTerminal(1)
end, {
    desc = "Harpoon open terminal"
})

-- comments
vim.keymap.set("v", "<C-_>", "gc", {
    remap = true
})

-- tmux navigation
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", {
    silent = true
})

-- telescope
local builtin_telescope = require("telescope.builtin")
local wk = require("which-key")
wk.add({{
    "<leader>f",
    group = "Telescope"
}})

vim.keymap.set("n", "<leader>fd", builtin_telescope.git_bcommits, {
    desc = "Telescope commits for current buffer"
})
vim.keymap.set("n", "<leader>fs", builtin_telescope.git_status, {
    desc = "Telescope git status"
})
local find_buffer_description = "Telescope find buffer"
-- vim.keymap.set("n", "<leader>ff", builtin_telescope.find_files, { desc = find_buffer_description })
vim.keymap.set("n", "<leader><space>", builtin_telescope.find_files, {
    desc = find_buffer_description
})
vim.keymap.set("n", "<leader>ff", builtin_telescope.live_grep, {
    desc = "Telescope live grep"
})
vim.keymap.set("n", "<leader>fm", builtin_telescope.keymaps, {
    desc = "Telescope find mapping/keybinding"
})
vim.keymap.set("n", "<leader>fu", builtin_telescope.current_buffer_fuzzy_find, {
    desc = "Fuzzy find in the current buffer"
})
vim.keymap.set("n", "<leader>ft", builtin_telescope.treesitter, {
    desc = "Treesitter"
})
-- vim.keymap.set("n", "<leader>fp", function()
--   local maps = vim.api.nvim_get_keymap("n")
--   for _, v in pairs(maps) do
--     if v.lhs == "  " then
--       if v.desc == find_buffer_description then
--         vim.keymap.set("n", "<leader><space>", builtin_telescope.find_files, { desc = "Telescope find files" })
--       else
--         vim.keymap.set("n", "<leader><space>", builtin_telescope.buffers { desc = find_buffer_description })
--       end
--     end
--   end
-- end, { desc = "Telescope switch to buffer mode" })
vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {
    noremap = true,
    desc = "Telescope file browser"
})
vim.keymap.set("n", "<leader>fh", builtin_telescope.help_tags, {
    desc = "Telescope find help"
})

--- easymotion
vim.g.EasyMotion_smartcase = 1
vim.keymap.set("n", "s", "<Plug>(easymotion-s)", {
    desc = "Easymotion s"
})
vim.keymap.set("v", "s", "<Plug>(easymotion-s)", {
    desc = "Easymotion s"
})

vim.keymap.set("v", "<leader>la", ":CodeCompanion ", {
    noremap = true,
    silent = false
})
vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", {
    noremap = true,
    silent = true
})
vim.keymap.set("n", "<leader>ca", "<cmd>CodeCompanionActions<cr>", {
    noremap = true,
    silent = true
})

-- chat gpt
-- wk.add({{
--     "<leader>c",
--     group = "ChatGPT"
-- }, {
--     "<leader>cc",
--     "<cmd>ChatGPT<CR>",
--     desc = "ChatGPT"
-- }, {
--     "<leader>cp",
--     "<cmd>ChatGPTActAs<CR>",
--     desc = "ChatGPTActAs"
-- }, {
--     mode = {"n", "v"},
--     {
--         "<leader>ca",
--         "<cmd>ChatGPTRun add_tests<CR>",
--         desc = "Add Tests"
--     },
--     {
--         "<leader>cd",
--         "<cmd>ChatGPTRun docstring<CR>",
--         desc = "Docstring"
--     },
--     {
--         "<leader>ce",
--         "<cmd>ChatGPTEditWithInstruction<CR>",
--         desc = "Edit with instruction"
--     },
--     {
--         "<leader>cf",
--         "<cmd>ChatGPTRun fix_bugs<CR>",
--         desc = "Fix Bugs"
--     },
--     {
--         "<leader>cg",
--         "<cmd>ChatGPTRun grammar_correction<CR>",
--         desc = "Grammar Correction"
--     },
--     {
--         "<leader>ck",
--         "<cmd>ChatGPTRun keywords<CR>",
--         desc = "Keywords"
--     },
--     {
--         "<leader>cl",
--         "<cmd>ChatGPTRun code_readability_analysis<CR>",
--         desc = "Code Readability Analysis"
--     },
--     {
--         "<leader>co",
--         "<cmd>ChatGPTRun optimize_code<CR>",
--         desc = "Optimize Code"
--     },
--     {
--         "<leader>cr",
--         "<cmd>ChatGPTRun roxygen_edit<CR>",
--         desc = "Roxygen Edit"
--     },
--     {
--         "<leader>cs",
--         "<cmd>ChatGPTRun summarize<CR>",
--         desc = "Summarize"
--     },
--     {
--         "<leader>ct",
--         "<cmd>ChatGPTRun translate<CR>",
--         desc = "Translate"
--     },
--     {
--         "<leader>cx",
--         "<cmd>ChatGPTRun explain_code<CR>",
--         desc = "Explain Code"
--     }
-- }})

-- File explorer
vim.keymap.set("n", "<leader>-", function()
    local api = require("nvim-tree.api")
    local filename = vim.api.nvim_buf_get_name(0)
    local getPath = function(str, sep)
        sep = sep or '/'
        return str:match("(.*" .. sep .. ")")
    end
    -- api.tree.toggle({ path = getPath(filename, "/") })
    api.tree.toggle({
        find_file = true
    })
    -- print(getPath(filename, "/"))
end, {
    desc = "File explorer"
})
