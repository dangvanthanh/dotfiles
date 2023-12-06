return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    dependencies = {
      -- Add devicons
      "yamatsum/nvim-nonicons",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      window = {
        position = "left",
        mappings = {
          ["s"] = "open_vsplit",
          ["<C-v>"] = "open_vsplit",
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignore = false,
          hide_by_name = {
            ".git",
          },
          never_show = {},
        },
      },
    },
  },
}