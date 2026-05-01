return {
	"sudo-tee/opencode.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				anti_conceal = { enabled = false },
				file_types = { "markdown", "opencode_output" },
			},
			ft = { "markdown", "opencode_output" },
		},
		"folke/snacks.nvim",
	},
	config = function()
		require("opencode").setup({
			keymap_prefix = "<leader>a", -- keep the old AI keymap namespace
		})
	end,
}
