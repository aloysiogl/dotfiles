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
  {
    'prichrd/netrw.nvim',
    -- trigger only when entering in netrw
    event = 'FileType netrw',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    config = function()
      require 'netrw'.setup {
        use_devicons = true,
      }
    end
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
    },
    opts = {
      labels = "asdfjkl",
      search = {
        -- mode = "fuzzy",
        incremental = false,
      },
      label = {
        exclude = "<>-",
        uppercase = false,
      }
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        -- set flash labels to be abc
        require("flash").jump({
          pattern = "^",
          labels = "asdfghjklqwertyuiopzxcvbnm",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          n = { s = flash },
          i = { ["<c-s>"] = flash },
        },
      })
    end,
  },
  {
    "mihaifm/bufstop",
    cmd = "BufstopSpeedToggle",
    event = "VeryLazy",
  },
  {
    "haya14busa/is.vim"
  },
  {
    "ggvgc/vim-fuzzysearch"
  }
}
