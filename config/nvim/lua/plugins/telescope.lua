return {
  {
    {
      "nvim-telescope/telescope.nvim",
      -- install fzf native
      dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
      },
      keys = {
        -- change a keymap
        { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
        -- add a keymap to browse plugin files
        {
          "<leader>fp",
          function()
            require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
          end,
          desc = "Find Plugin File",
        },
        -- This is using b because it used to be fzf's :Buffers
        {
          "<leader>b",
          "<cmd>Telescope oldfiles<cr>",
          desc = "Recent",
        },
      },
      opts = {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = function(...)
                return require("telescope.actions").move_selection_next(...)
              end,
              ["<C-k>"] = function(...)
                return require("telescope.actions").move_selection_previous(...)
              end,
            },
          },
        },
      },
    },
  },
}