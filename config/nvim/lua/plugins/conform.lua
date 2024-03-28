return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 1000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      format = {
        timeout_ms = 1000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_fallback = true, -- not recommended to change
      },
      formatters_by_ft = {
        ["javascript"] = { "biome" },
        ["typescript"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["json"] = { "biome" },
        ["jsonc"] = { "biome" },
        ["html"] = { "biome" },
        ["svelte"] = { "biome" },
        ["astro"] = { "biome" },
        ["scss"] = { "biome" },
        ["css"] = { "biome" },
        ["yaml"] = { "biome" },
        ["markdown"] = { "biome" },
        ["markdown.mdx"] = { "biome" },
        ["graphql"] = { "biome" },
        ["lua"] = { "stylua" },
        ["fish"] = { "fish_indent" },
        ["sh"] = { "shfmt" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
