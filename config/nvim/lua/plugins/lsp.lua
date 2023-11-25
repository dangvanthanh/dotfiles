-- lsp
return {
  -- nvim-lspconfig configuration
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- K to 5k
      keys[#keys + 1] = { "K", "5k" }
      -- <leader>k to LSP hover
      keys[#keys + 1] = { "<leader>k", vim.lsp.buf.hover }
    end,
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes_include = {},
        },
      },
    },
  },
  -- mason configuration
  {
    "williamboman/mason.nvim",
    build = ":MasonInstallAll",
    config = function()
      require("mason").setup({})
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonUpdate")
        local ensure_installed = {
          "astro-language-server",
          "bash-language-server",
          "css-lsp",
          "dockerfile-language-server",
          "elixir-ls",
          "html-lsp",
          "json-lsp",
          "lua-language-server",
          "shfmt",
          "stylua",
          "tailwindcss-language-server",
          "typescript-language-server",
          "vue-language-server",
          "yaml-language-server",
        }
        vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
      end, { desc = "install all lsp tools" })
    end,
  },
}