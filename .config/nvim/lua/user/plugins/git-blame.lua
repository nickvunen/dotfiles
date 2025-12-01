return {
	"f-person/git-blame.nvim",
	config = function()
		require("gitblame").setup()
		vim.g.gitblame_enabled = true
	end,
}
