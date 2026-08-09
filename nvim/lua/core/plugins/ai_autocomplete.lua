local function codecompanion_cli(agent)
  return function()
    require("codecompanion").cli({ agent = agent })
  end
end

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
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCLI",
      "CodeCompanionCmd",
      "CodeCompanionCodeReview",
    },
    keys = {
      {
        "<leader>cc",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "CodeCompanion chat",
      },
      {
        "<leader>ca",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion actions",
      },
      {
        "<leader>ce",
        ":CodeCompanion ",
        mode = "v",
        desc = "CodeCompanion inline edit",
      },
      {
        "<leader>cl",
        codecompanion_cli("claude_code"),
        desc = "Claude Code CLI",
      },
      {
        "<leader>co",
        codecompanion_cli("codex"),
        desc = "Codex CLI",
      },
      {
        "<leader>cu",
        codecompanion_cli("cursor"),
        desc = "Cursor CLI",
      },
      {
        "<leader>cp",
        function()
          require("codecompanion").cli({ prompt = true })
        end,
        mode = { "n", "v" },
        desc = "Prompt active AI CLI",
      },
      {
        "<leader>cr",
        function()
          require("codecompanion").cli("#{this}", { focus = false })
        end,
        mode = { "n", "v" },
        desc = "Reference selection/file in AI CLI",
      },
      {
        "<leader>cd",
        function()
          require("codecompanion").cli("#{diagnostics} Can you fix these?", {
            focus = false,
            submit = true,
          })
        end,
        desc = "Send diagnostics to AI CLI",
      },
      {
        "<leader>ct",
        function()
          require("codecompanion").cli("#{terminal} Can you diagnose and fix this failure?", {
            focus = false,
            submit = true,
          })
        end,
        desc = "Send terminal output to AI CLI",
      },
      {
        "<leader>cC",
        "<cmd>CodeCompanionChat adapter=codex<cr>",
        desc = "New Codex ACP chat",
      },
      {
        "<leader>cL",
        "<cmd>CodeCompanionChat adapter=claude_code<cr>",
        desc = "New Claude ACP chat",
      },
      {
        "<leader>cU",
        "<cmd>CodeCompanionChat adapter=cursor_cli<cr>",
        desc = "New Cursor ACP chat",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      { "stevearc/dressing.nvim", opts = {} },
    },
    opts = {
      interactions = {
        chat = {
          adapter = "codex",
        },
        inline = {
          adapter = "copilot",
        },
        cmd = {
          adapter = "copilot",
        },
        background = {
          adapter = "copilot",
        },
        cli = {
          agent = "claude_code",
          agents = {
            claude_code = {
              cmd = "claude",
              args = {},
              description = "Claude Code CLI",
              provider = "terminal",
            },
            codex = {
              cmd = "codex",
              args = {},
              description = "OpenAI Codex CLI",
              provider = "terminal",
            },
            cursor = {
              cmd = "agent",
              args = {},
              description = "Cursor CLI",
              provider = "terminal",
            },
          },
          opts = {
            auto_insert = true,
          },
        },
      },
      adapters = {
        acp = {
          extend = {
            codex = {
              defaults = {
                auth_method = "chat-gpt",
              },
            },
            claude_code = {
              env = {
                ANTHROPIC_API_KEY = "ANTHROPIC_API_KEY",
              },
            },
          },
        },
        http = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "ANTHROPIC_API_KEY",
              },
            })
          end,
        },
      },
      display = {
        cli = {
          window = {
            layout = "vertical",
            width = 0.4,
            opts = {
              list = false,
            },
          },
        },
      },
    },
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
  },
}
