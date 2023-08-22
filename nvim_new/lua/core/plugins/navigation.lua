return {
  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    }
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "easymotion/vim-easymotion",
    lazy = false,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup({
        global_settings = {
          enter_on_sendcmd = true,
        }
      })
    end
  },
}
