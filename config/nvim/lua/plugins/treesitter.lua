-- treesitter configuration

return {
  -- Additional configurations from nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
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
      ignore_install = {
        "help",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
}