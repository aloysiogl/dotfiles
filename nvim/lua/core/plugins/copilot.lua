return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        enabled = true
      },
      panel = {
        enabled = false,
      },
      filetypes = {
        markdown = true,
        help = true
      }
    },
    config = function()
      require('copilot').setup()
      require('copilot_cmp').setup()
    end,
    dependencies = {
      "zbirenbaum/copilot-cmp",
    }
  },
}
