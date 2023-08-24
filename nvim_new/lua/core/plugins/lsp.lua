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
            { name = 'copilot' },
            { name = 'nvim_lsp' },
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
            ['<Tab>'] = completion,
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
          }
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
          lsp.default_keymaps({ buffer = bufnr })
          local opts = { buffer = bufnr }

          vim.keymap.set({ 'n', 'x' }, 'ft', function()
            vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
          end, opts)

          vim.keymap.set({ 'n' }, 'H', function()
            vim.lsp.buf.hover()
          end, opts)

          vim.keymap.set({ 'n' }, 'L', function()
            vim.lsp.buf.code_action()
          end, opts)

          vim.keymap.set({ 'n' }, '<leader>rn', function()
            vim.lsp.buf.rename()
          end, opts)
        end)


        -- (Optional) Configure lua language server for neovim
        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

        lsp.setup()
      end
    }
  }
}
