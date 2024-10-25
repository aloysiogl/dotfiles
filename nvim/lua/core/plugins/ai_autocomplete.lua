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
  -- {
  --   "pasky/claude.vim",
  --   lazy = false,
  --   config = function()
  --     -- Load API key from environment variable
  --     local api_key = os.getenv("ANTHROPIC_API_KEY")
  --     if api_key then
  --       vim.g.claude_api_key = api_key
  --     else
  --       vim.notify("ANTHROPIC_API_KEY environment variable is not set", vim.log.levels.WARN)
  --     end
  --
  --     vim.keymap.set("v", "<leader>la", ":'<,'>ClaudeImplement ", { noremap = true, desc = "Claude Implement" })
  --     vim.keymap.set("n", "<leader>lc", ":ClaudeChat<CR>", { noremap = true, silent = true, desc = "Claude Chat" })
  --   end,
  -- },
{
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function()
    require("codecompanion").setup(
    {
 strategies = {
    chat = {
      -- adapter = "anthropic",
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      -- adapter = "anthropic",
      adapter = "copilot",
    },
  },
   adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "ANTHROPIC_API_KEY"
        },
      })
    end,
  },
    }
    )
  end,
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
