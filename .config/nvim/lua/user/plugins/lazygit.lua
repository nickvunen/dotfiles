return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- setting the keybinding for LazyGit with 'keys' is recommended in
	-- order to load the plugin when the command is run for the first time
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
	},
	config = function()
		local venv_path = vim.fn.getcwd() .. "/.venv"
		local venv_bin = venv_path .. "/bin"
		if vim.fn.isdirectory(venv_path) == 1 then
			vim.env.VIRTUAL_ENV = venv_path
			vim.env.PATH = venv_bin .. ":" .. vim.env.PATH
		end
	end,
}
