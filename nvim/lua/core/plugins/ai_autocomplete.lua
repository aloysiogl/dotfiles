return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = {
  --       auto_trigger = true,
  --       enabled = true
  --     },
  --     panel = {
  --       enabled = false,
  --     },
  --     filetypes = {
  --       markdown = true,
  --       help = true
  --     }
  --   },
  --   config = function()
  --     require('copilot').setup()
  --     require('copilot_cmp').setup()
  --   end,
  --   dependencies = {
  --     "zbirenbaum/copilot-cmp",
  --   }
  -- },
  {
    'github/copilot.vim',
    event = "VeryLazy",
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "nomnivore/ollama.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  
    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
  
    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "ollama prompt",
        mode = { "n", "v" },
      },
  
      -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oG",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "ollama Generate Code",
        mode = { "n", "v" },
      },
    },
  
    ---@type Ollama.Config
    opts = {
      -- your configuration overrides
    }
  }
}
