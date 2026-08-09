return {{
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {"nvim-lua/plenary.nvim"}
}, {"tpope/vim-fugitive"}, {
    "sindrets/diffview.nvim",
    config = function()
        local actions = require("diffview.actions")

        require('diffview').setup({
            keymaps = {
                view = {
                    -- Use Vim's native diff navigation (]c, [c) but remap n and N to them
                    ["n"] = "]c",
                    ["N"] = "[c",
                    ["<leader>x"] = function() vim.cmd('tabclose') end
                },
                file_panel = {
                    -- TODO: working but very ugly and wrong, change this
                    ["n"] = function()
                        actions.focus_entry()
                        vim.cmd("normal! ]c")
                        -- Return to file panel
                        actions.toggle_files()
                        actions.toggle_files()
                    end,
                    ["N"] = function()
                        -- Focus the diff view (right side)
                        actions.focus_entry()
                        -- Jump to previous change
                        vim.cmd("normal! [c")
                        -- Return to file panel
                        actions.toggle_files()
                        actions.toggle_files()
                    end,
                    ["a"] = actions.toggle_stage_entry,
                    ["s"] = false,
                    ["<leader>x"] = function() vim.cmd('tabclose') end
                }
            }
        })
    end
}, {
    "NeogitOrg/neogit",
    dependencies = {"nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
    "echasnovski/mini.pick" -- optional
    },
    config = true
}, {
    "otavioschwanck/github-pr-reviewer.nvim",
    opts = {
        next_hunk_key = "<C-n>",
        prev_hunk_key = "<C-S-n>",
        mark_as_viewed_key = "<Tab>",
        next_file_key = "<Plug>(PRNextFile)",
        prev_file_key = "<Plug>(PRPrevFile)"
    },
    config = function(_, opts)
        local reviewer = require("github-pr-reviewer")
        reviewer.setup(opts)

        local float_mode = "all"
        local original_toggle_floats = reviewer.toggle_floats

        local function close_float(field)
            local win = reviewer[field]
            if win and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            reviewer[field] = nil
        end

        local function close_summary_floats()
            close_float("_float_win_general")
            close_float("_float_win_buffer")
        end

        local function close_keymap_float()
            close_float("_float_win_keymaps")
        end

        reviewer.toggle_floats = function()
            if not vim.g.pr_review_number then
                return
            end

            if float_mode == "all" then
                float_mode = "summary"
                close_keymap_float()
                vim.notify("Showing PR file and change summary", vim.log.levels.INFO)
            elseif float_mode == "summary" then
                float_mode = "none"
                reviewer.config.show_floats = false
                close_summary_floats()
                close_keymap_float()
                vim.notify("PR floating windows hidden", vim.log.levels.INFO)
            else
                float_mode = "all"
                reviewer.config.show_floats = false
                original_toggle_floats()
            end
        end

        vim.api.nvim_create_autocmd({"BufEnter", "CursorMoved"}, {
            group = vim.api.nvim_create_augroup("GithubPrReviewerFloatMode", {
                clear = true
            }),
            callback = function()
                if float_mode == "summary" then
                    close_keymap_float()
                end
            end
        })
    end,
    keys = {
        {
            "<leader>p",
            "<cmd>PRReviewMenu<cr>",
            desc = "PR review menu"
        }, {
            "<leader>p",
            ":<C-u>'<,'>PRSuggestChange<CR>",
            mode = "v",
            desc = "Suggest PR change"
        }
    }
}, {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, {
                    expr = true
                })

                map('n', '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, {
                    expr = true
                })

                -- Actions
                map('n', '<leader>hs', gs.stage_hunk, {
                    desc = "Stage hunk"
                })
                map('n', '<leader>hr', gs.reset_hunk, {
                    desc = "reset_hunk"
                })
                map('v', '<leader>hs', function()
                    gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
                end)
                map('v', '<leader>hr', function()
                    gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
                end)
                map('n', '<leader>hS', gs.stage_buffer, {
                    desc = "stage_buffer"
                })
                map('n', '<leader>hu', gs.undo_stage_hunk, {
                    desc = "undo_stage_hunk"
                })
                map('n', '<leader>hR', gs.reset_buffer, {
                    desc = "reset_buffer"
                })
                map('n', '<leader>hp', gs.preview_hunk, {
                    desc = "preview_hunk"
                })
                map('n', '<leader>hb', function()
                    gs.blame_line {
                        full = true
                    }
                end)
                map('n', '<leader>tb', gs.toggle_current_line_blame, {
                    desc = "toggle_current_line_blame"
                })
                map('n', '<leader>hd', gs.diffthis, {
                    desc = "diffthis"
                })
                map('n', '<leader>hD', function()
                    gs.diffthis('~')
                end)
                map('n', '<leader>td', gs.toggle_deleted, {
                    desc = "Stage hunk"
                })

                -- Text object
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }
    end
}}
