-- This is the Josean colorscheme
-- return {
-- 	{
-- 		"folke/tokyonight.nvim",
-- 		priority = 1000, -- make sure to load this before all the other start plugins
-- 		config = function()
-- 			local transparent = true
--
-- 			local bg = "#011628"
-- 			local bg_dark = "#011423"
-- 			local bg_highlight = "#143652"
-- 			local bg_search = "#0A64AC"
-- 			local bg_visual = "#275378"
-- 			local fg = "#CBE0F0"
-- 			local fg_dark = "#B4D0E9"
-- 			local fg_gutter = "#627E97"
-- 			local border = "#547998"
--
-- 			require("tokyonight").setup({
-- 				style = "night",
-- 				transparent = transparent,
-- 				styles = {
-- 					sidebars = transparent and "transparent" or "dark",
-- 					floats = transparent and "transparent" or "dark",
-- 				},
-- 				on_colors = function(colors)
-- 					colors.bg = bg
-- 					colors.bg_dark = bg_dark
-- 					colors.bg_float = bg_dark
-- 					colors.bg_highlight = bg_highlight
-- 					colors.bg_popup = bg_dark
-- 					colors.bg_search = bg_search
-- 					colors.bg_sidebar = bg_dark
-- 					colors.bg_statusline = bg_dark
-- 					colors.bg_visual = bg_visual
-- 					colors.border = border
-- 					colors.fg = fg
-- 					colors.fg_dark = fg_dark
-- 					colors.fg_float = fg
-- 					colors.fg_gutter = fg_gutter
-- 					colors.fg_sidebar = fg_dark
-- 				end,
-- 			})
-- 			-- load the colorscheme here
-- 			vim.cmd([[colorscheme tokyonight]])
-- 		end,
-- 	},
-- }

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
