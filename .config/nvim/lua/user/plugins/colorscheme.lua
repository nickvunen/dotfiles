-- Active theme: onedark (darker style, transparent bg).
-- Previous tokyonight config removed; restore from git history if needed.

return {
	"navarasu/onedark.nvim",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("onedark").setup({
			style = "darker",
			transparent = true,
			highlights = {
				["@comment"] = { fg = "#5c6370", italic = true },
				["Comment"] = { fg = "#5c6370", italic = true },
				["@comment.documentation"] = { fg = "#5c6370", italic = true },
				["@lsp.type.comment"] = { fg = "#5c6370", italic = true },
			},
		})
		require("onedark").load()
		
		vim.api.nvim_set_hl(0, "Comment", { fg = "#5c6370", italic = true })
		vim.api.nvim_set_hl(0, "@comment", { fg = "#5c6370", italic = true })
		vim.api.nvim_set_hl(0, "@comment.documentation", { fg = "#5c6370", italic = true })
		vim.api.nvim_set_hl(0, "@lsp.type.comment", { fg = "#5c6370", italic = true })
		vim.api.nvim_set_hl(0, "@spell", {})
		
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "Comment", { fg = "#5c6370", italic = true })
				vim.api.nvim_set_hl(0, "@comment", { fg = "#5c6370", italic = true })
				vim.api.nvim_set_hl(0, "@comment.documentation", { fg = "#5c6370", italic = true })
				vim.api.nvim_set_hl(0, "@lsp.type.comment", { fg = "#5c6370", italic = true })
				vim.api.nvim_set_hl(0, "@spell", {})
			end,
		})
	end,
}
