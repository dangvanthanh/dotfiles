-- coding
return {
  -- copilot configuration
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = true },
      panel = { enabled = true },
    },
  },
  -- markdown support
  { "godlygeek/tabular" }, -- required by vim-markdown
  { "plasticboy/vim-markdown" },

  -- zen mode
  { "folke/zen-mode.nvim" },
}