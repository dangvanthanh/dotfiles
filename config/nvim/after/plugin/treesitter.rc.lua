local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disabled = {}
  },
  indent = {
    enable = true,
    disabled = {}
  },
  ensure_installed = {
    "tsx",
    "lua",
    "json",
    "fish",
    "css",
    "html"
  },
  autotag = {
    enabled = true
  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
