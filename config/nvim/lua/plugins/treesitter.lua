-- Additional configurations from nvim-treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/nvim-ts-rainbow2",
    },
    opts = {
      autopairs = {
        enable = true,
      },
      autotag = {
        enable = true,
        disabled = { "xml" },
      },
      hightlight = {
        enable = true,
        disabled = { "css", "latex", "markdown" },
        additional_vim_regex_highlighting = true,
      },
      indent = {
        enable = true,
        disable = { "yml", "yaml" },
      },
      rainbow = {
        enable = true,
      },
      ensure_installed = {
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
      },
    },
  },
}