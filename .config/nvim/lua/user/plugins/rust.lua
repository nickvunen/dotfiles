return {
	{
		"simrat39/rust-tools.nvim",
		ft = { "rust" },
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			local rt = require("rust-tools")
			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Your custom LSP keybindings here
					end,
				},
			})
		end,
	},
}
