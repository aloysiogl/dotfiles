return {
  -- {
  --   "iurimateus/luasnip-latex-snippets.nvim",
  --   dependencies = {
  --     "L3MON4D3/LuaSnip", "lervag/vimtex"
  --   },
  --   config = function ()
  --     require("luasnip-latex-snippets").setup({ use_trisitter = true })
  --   end
  -- },
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
      require("luasnip").config.set_config({
        -- Enable autotriggered snippets
        enable_autosnippets = true,

        -- Use Tab (or some other key if you prefer) to trigger visual selection
        store_selection_keys = "<Tab>",
      })
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/luasnippets/" })
    end
  },
  {
    "evesdropper/luasnip-latex-snippets.nvim"
  }
}
