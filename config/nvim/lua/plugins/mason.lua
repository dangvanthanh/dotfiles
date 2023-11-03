-- mason configuration
return {
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
}