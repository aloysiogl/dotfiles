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
  { "kevinhwang91/nvim-bqf" },
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  },
  {
    "nvim-tree/nvim-tree.lua"
  },
}
