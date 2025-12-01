-- Example 'nvim-scrollbar' config for Neovim, in Lua dotfiles style

return {
	"petertriho/nvim-scrollbar",
	event = "VeryLazy", -- or "BufReadPre" if you want it on startup
	config = function()
		require("scrollbar").setup({
			show = true,
			set_highlights = true,
			handle = {
				color = "#44475a", -- your preferred color for the scrollbar handle
			},
			marks = {
				Cursor = { color = "#8be9fd" }, -- Cyan for cursor
				Search = { color = "#ffb86c" }, -- Orange for search
				Error = { color = "#ff5555" }, -- Red for errors
				Warn = { color = "#f1fa8c" }, -- Yellow for warnings
				Info = { color = "#8be9fd" }, -- Cyan for info
				Hint = { color = "#50fa7b" }, -- Green for hints
				Misc = { color = "#bd93f9" }, -- Purple for misc
			},
			excluded_buftypes = { "terminal", "prompt" },
			excluded_filetypes = { "NvimTree", "neo-tree", "dashboard", "Outline" },
		})
		-- Enable diagnostics marks (errors/warnings/info) in scrollbar
		require("scrollbar.handlers.diagnostic").setup()
	end,
}
