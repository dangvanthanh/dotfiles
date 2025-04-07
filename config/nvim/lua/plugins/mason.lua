return {
	"williamboman/mason.nvim",
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
		ensure_installed = {
			"astro-language-server",
			"bash-language-server",
			"css-lsp",
			"dockerfile-language-server",
			"elixir-ls",
			"html-lsp",
			"json-lsp",
			"lua-language-server",
			"shfmt",
			"stylua",
			"tailwindcss-language-server",
			"typescript-language-server",
			"vue-language-server",
			"yaml-language-server",
			"svelte-language-server",
			"biome",
		},
	}
}