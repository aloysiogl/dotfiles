return {
  {
    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v2.x',
      lazy = true,
      config = function()
        -- This is where you modify the settings for lsp-zero
        -- Note: autocompletion settings will not take effect

        require('lsp-zero.settings').preset({})
      end
    },
    -- Autocompletion
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        "L3MON4D3/LuaSnip",
      },
      config = function()
        -- Here is where you configure the autocompletion settings.
        -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
        -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

        require('lsp-zero.cmp').extend()

        -- And you can configure cmp even more, if you want to.
        local cmp = require('cmp')

        local has_words_before = function()
          if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and
              vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") ==
              nil
        end

        local completion =
            cmp.mapping.confirm({
              -- documentation says this is important.
              -- I don't know why.
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })

        cmp.setup({
          sources = {
            -- { name = 'copilot' },
            { name = 'nvim_lsp' },
            { name = 'omni' },
            { name = 'orgmode' },
            { name = 'luasnip', option = { show_autosnippets = true, use_show_condition = false } },
            { name = "buffer" },
            { name = "path" },
          },
          snippet = {
            expand = function(args)
              print(args.body)
              require 'luasnip'.lsp_expand(args.body)
            end
          },
          mapping = {
            -- ['<Tab>'] = completion,
            ['<CR>'] = completion,
            ['<C-Space>'] = cmp.mapping.complete(),
            ["<C-j>"] = vim.schedule_wrap(function(fallback)
              if cmp.visible() and has_words_before() then
                cmp.select_next_item({
                  behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end),
            ["<C-k>"] = vim.schedule_wrap(function(fallback)
              if cmp.visible() and has_words_before() then
                cmp.select_prev_item({
                  behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end)
          },
          experimental = {
            -- ghost_text = true,
          },
        })
      end
    },
    {
      'saadparwaiz1/cmp_luasnip',
      dependencies = {
        { 'lervag/vimtex' },
      }
    },
    { "hrsh7th/cmp-buffer" },
    -- Support for ominifunc
    { "hrsh7th/cmp-omni" },
    { "hrsh7th/cmp-path" },
    -- LSP
    {
      'neovim/nvim-lspconfig',
      cmd = 'LspInfo',
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'williamboman/mason.nvim' },
      },
      config = function()
        -- This is where all the LSP shenanigans will live

        local lsp = require('lsp-zero')

        lsp.on_attach(function(client, bufnr)
          -- Do not provide highlighting for semantic tokens
          client.server_capabilities.semanticTokensProvider = nil

          lsp.default_keymaps({ buffer = bufnr })
          local generate_opts = function(desc)
            return { desc = desc, buffer = bufnr }
          end

          vim.keymap.set({ 'n', 'x' }, '<leader>lf', function()
            vim.lsp.buf.format({ async = true, timeout_ms = 10000 })
          end, generate_opts('LSP format'))

          vim.keymap.set({ 'n' }, '<leader>lwl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, generate_opts('LSP list_workspace_folders'))

          vim.keymap.set({ 'n' }, '<leader>lh', vim.lsp.buf.hover, generate_opts('LSP hover'))
          vim.keymap.set({ 'n' }, '<leader>la', vim.lsp.buf.code_action, generate_opts('LSP action'))
          vim.keymap.set({ 'n' }, '<leader>lr', vim.lsp.buf.rename, generate_opts('LSP rename'))
          vim.keymap.set({ 'n' }, '<leader>ld', vim.lsp.buf.definition, generate_opts('LSP definition'))
          vim.keymap.set({ 'n' }, '<leader>lD', vim.lsp.buf.declaration, generate_opts('LSP declaration'))
          vim.keymap.set({ 'n' }, '<leader>li', vim.lsp.buf.implementation, generate_opts('LSP implementation'))
          vim.keymap.set({ 'n' }, '<leader>ls', vim.lsp.buf.signature_help, generate_opts('LSP signature_help'))
          vim.keymap.set({ 'n' }, '<leader>lwa', vim.lsp.buf.add_workspace_folder,
            generate_opts('LSP add_workspace_folder'))
          vim.keymap.set({ 'n' }, '<leader>lwr', vim.lsp.buf.remove_workspace_folder,
            generate_opts('LSP remove_workspace_folder'))
          -- vim.keymap.set({ 'n' }, '<leader>le', vim.lsp.buf.references, generate_opts('LSP references'))
          vim.keymap.set("n", "<leader>le", function() require("trouble").open("lsp_references") end,
            generate_opts('LSP references'))
          vim.keymap.set({ 'n' }, '<leader>lD', vim.lsp.buf.type_definition, generate_opts('LSP type_definition'))

          -- Disgnostics
          vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Diagnostics open_float' })
          vim.keymap.set('n', '<leader>dk', vim.diagnostic.goto_prev, { desc = 'Diagnostics goto_prev' })
          vim.keymap.set('n', '<leader>dj', vim.diagnostic.goto_next, { desc = 'Diagnostics goto_next' })
          vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Diagnostics setloclist' })
        end)

        -- (Optional) Configure lua language server for neovim
        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

        -- Solve: Multiple different client offset_encodings detected on cpp
        local cmp_nvim_lsp = require "cmp_nvim_lsp"

        require("lspconfig").clangd.setup {
          -- on_attach = on_attach,
          capabilities = cmp_nvim_lsp.default_capabilities(),
          cmd = {
            "clangd",
            "--offset-encoding=utf-16",
          },
        }

        lsp.setup()
      end
    }
  },
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    event = 'VeryLazy',
    config = function()
      -- Load treesitter grammar for org
      require('orgmode').setup_ts_grammar()

      -- Setup treesitter
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'org' },
        },
        ensure_installed = { 'org' },
      })

      -- Setup orgmode
      require('orgmode').setup({
        org_agenda_files = '~/Dropbox/notes/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',
        org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'CANCELLED' },
        org_todo_keyword_faces = {
          WAITING = ':foreground blue :weight bold',
          CANCELLED = ':foreground gray :weight bold',
          TODO = ':foreground yellow :weight bold', -- overrides builtin color for `TODO` keyword
        },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
      local configs = require 'nvim-treesitter.configs'
      configs.setup {
        ensure_installed = {
          'python',
          'haskell',
        },
        highlight = {
          enable = true,
          disable = { 'latex' },
        },
      }
    end,
  },
  { "folke/neodev.nvim", event = "VeryLazy" },
}
