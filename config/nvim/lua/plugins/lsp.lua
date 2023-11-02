-- lsp configuration
return {
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
        omnisharp = {
          handlers = {
            ["textDocument/definition"] = function(...)
              return require("omnisharp_extended").handler(...)
            end,
          },
          keys = {
            {
              "gd",
              function()
                require("omnisharp_extended").telescope_lsp_definitions()
              end,
              desc = "Goto Definition",
            },
          },
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
        },
        tailwindcss = {
          filetypes_exclude = { "markdown" },
          filetypes_include = {},
        },
      },
    },
    setup = {
      tailwindcss = function(_, opts)
        local tw = require("lspconfig.server_configurations.tailwindcss")
        opts.filetypes = opts.filetypes or {}
  
        -- Add default filetypes
        vim.list_extend(opts.filetypes, tw.default_config.filetypes)
  
        -- Remove excluded filetypes
        --- @param ft string
        opts.filetypes = vim.tbl_filter(function(ft)
          return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
        end, opts.filetypes)
  
        -- Add additional filetypes
        vim.list_extend(opts.filetypes, opts.filetypes_include or {})
      end,
    },
  },
}