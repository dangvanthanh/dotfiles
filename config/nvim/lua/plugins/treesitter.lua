-- Additional configurations from nvim-treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/nvim-ts-rainbow2",
    },
    opts = function(_, opts)
      opts.autopairs = {
        enable = true,
      }
      opts.autotag = {
        enable = true,
        disabled = { "xml" },
      }
      opts.hightlight = {
        enable = true,
        disabled = { "css", "latex", "markdown" },
        additional_vim_regex_highlighting = true,
      }
      opts.indent = {
        enable = true,
        disable = { "yml", "yaml" },
      }
      opts.rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1500,
        colors = {
          "Gold",
          "Orchild",
          "DorgerBlue",
          "Cornsilk",
          "Salmon",
          "LawnGreen",
        },
      }
      opts.ensure_installed = {
        "astro",
        "bash",
        "css",
        "dockerfile",
        "fish",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "scss",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
      }
    end,
  },
}