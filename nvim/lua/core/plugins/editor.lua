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
    "zoriya/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        -- your config goes here
        -- or just leave it empty :)
        execution_message = {
          message = "",
        },
        triggered_events = { "InsertLeave" },
        callbacks = {
          after_saving = function()
            -- os.execute("make > /tmp/latex_build 2> /tmp/latex_error &")
          end,
        },
      })
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
      }
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  }
}
