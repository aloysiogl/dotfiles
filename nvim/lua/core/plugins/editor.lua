return {
  -- theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme catppuccin]])
    end,

  },
  {
    "okuuva/auto-save.nvim",
    version = '^1.0.0', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    -- cmd = "ASToggle", -- optional for lazy loading on command
    -- event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    event = { "InsertLeave" }, -- optional for lazy loading on trigger events
    opts = {
      -- your config goes here
      -- or just leave it empty :)
    },
  },
  -- {
  --    "folke/tokyonight.nvim",
  --    lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --    priority = 1000, -- make sure to load this before all the other start plugins
  --    config = function()
  --      -- load the colorscheme here
  --      vim.cmd([[colorscheme tokyonight]])
  --    end,
  --  },
  {
    "terrortylor/nvim-comment",
    config = function()
      require('nvim_comment').setup(
        { line_mapping = "<C-_>" }
      )
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "VeryLazy",
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        hover = {
          enabled = false, -- disables hover support
        },
        signature = {
          enabled = false, -- disables hover support
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      },
      messages = {
        enabled = false,
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        sections = {
          lualine_x = {
            {
              function()
                if vim.fn.reg_recording() ~= '' then
                  return 'Recording @' .. vim.fn.reg_recording()
                else
                  return ''
                end
              end,
            }
          },
        },
      })
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function custom_on_attach(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)
        -- add 'o' mapping for system_open
        vim.keymap.del('n', 's', { buffer = bufnr })
        vim.keymap.set('n', 'o', api.node.run.system, opts('Open in system application'))
      end

      require("nvim-tree").setup {
        on_attach = custom_on_attach,
      }
    end,
  },
  -- ---@type LazySpec
  -- {
  --   "mikavilpas/yazi.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     -- 👇 in this section, choose your own keymappings!
  --     {
  --       "<leader>-",
  --       "<cmd>Yazi<cr>",
  --       desc = "Open yazi at the current file",
  --     },
  --     {
  --       -- Open in the current working directory
  --       "<leader>cw",
  --       "<cmd>Yazi cwd<cr>",
  --       desc = "Open the file manager in nvim's working directory",
  --     },
  --     {
  --       -- NOTE: this requires a version of yazi that includes
  --       -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
  --       '<c-up>',
  --       "<cmd>Yazi toggle<cr>",
  --       desc = "Resume the last yazi session",
  --     },
  --   },
  --   ---@type YaziConfig
  --   opts = {
  --     -- if you want to open yazi instead of netrw, see below for more info
  --     open_for_directories = false,
  --
  --     -- enable these if you are using the latest version of yazi
  --     -- use_ya_for_events_reading = true,
  --     -- use_yazi_client_id_flag = true,
  --
  --     keymaps = {
  --       show_help = '<f1>',
  --     },
  --   },
  -- },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
  },
  {
    "LunarVim/bigfile.nvim",
    opts = {
      filesize = 2,      -- size of the file in MiB, the plugin round file sizes to the closest MiB
      pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
      features = {       -- features to disable
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    }
  },
}
