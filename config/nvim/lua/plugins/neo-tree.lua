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
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            ".Ds_Store",
            ".thumbs.db",
            "node_modules",
          },
          always_show = {
            ".env",
            ".env.local",
          },
          follow_current_file = {
            enable = true,
            leave_dirs_open = true,
          },
        },
      },
      use_libux_file_watcher = true,
    },
  },
}
