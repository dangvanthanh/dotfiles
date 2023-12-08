return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls").builtins
      opts.sources = {
        nls.code_actions.gitsigns,
        nls.formatting.biome.with({
          args = {
            "check",
            "--apply",
            "--formatter-enabled=true",
            "--organize-imports-enabled=true",
            "--skip-errors",
            "$FILENAME",
          },
        }),
      }
    end,
  },
}
