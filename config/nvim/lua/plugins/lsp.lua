return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/typescript.nvim",
			init = function()
				require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
					vim.keymap.set("n", "<leader>cM", "typescriptaddmissingimports", { buffer = buffer, desc = "Add Missing Imports" })
					vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
					vim.keymap.set("n", "<leader>cu", "TypescriptRemoveUnused", { buffer = buffer, desc = "Remove Unused" })
					vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
				end)
			end,
		},
		opts = {
			servers = {
				tsserver = {},
			},
			setup = {
				tsserver = function(_, opts)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		},
	},
}
