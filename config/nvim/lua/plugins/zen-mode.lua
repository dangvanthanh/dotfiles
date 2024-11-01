return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = { { "<leader>z", ":ZenMode<cr>", desc = "Zen Mode" } },
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = true,
          showcmd = false,
          laststatus = 0,
        },
        gitsigns = false,
        tmux = true,
      },
    },
  },
}
