-- editor
-- Highlight YAML front matter
vim.api.nvim_set_var("vim_markdown_frontmatter ", 1)

return {
  -- Neo-tree configuration
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
      filesystem = {},
    },
  },
  -- gitsigns configuration
  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

      -- stylua: ignore start
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  -- telescope configuration
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
  -- tmux vim
  { "christoomey/vim-tmux-navigator" },
}
