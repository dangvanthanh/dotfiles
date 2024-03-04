return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")

      opts.sources = {
        nls.builtins.code_actions.gitsigns,
        nls.builtins.formatting.biome.with({
          args = {
            "check",
            "--apply",
            "--formatter-enabled=true",
            "--organize-imports-enabled=true",
            "--skip-errors",
            "$FILENAME",
          },
        }),
        nls.builtins.formatting.fish_indent,
        nls.builtins.diagnostics.fish,
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.shfmt.with({
          filetypes = { "sh", "zsh" },
        }),
      }
    end,
  },
}
