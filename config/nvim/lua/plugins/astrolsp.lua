return {
  {
    "AstroNvim/astrolsp",
    opts = {
      formatting = {
        format_on_save = {
          enabled = true,
          ignore_filetypes = {
            "lua",
            "python",
          },
          allow_filetypes = {
            "astro",
          },
        },
      },
    },
  },
}
