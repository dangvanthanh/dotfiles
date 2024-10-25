return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", ":ZenMode<cr>", desc = "Zen Mode" } },
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
      },
    },
  },
}
