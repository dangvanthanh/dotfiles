-- Neo-tree configuration
return {
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
    filesystem = {},
  },
}
