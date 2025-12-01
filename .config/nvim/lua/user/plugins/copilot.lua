return {
	"github/copilot.vim",
	config = function()
		-- Enable copilot for specific filetypes
		vim.g.copilot_filetypes = {
			["*"] = false,
			["javascript"] = true,
			["typescript"] = true,
			["javascriptreact"] = true,
			["typescriptreact"] = true,
			["lua"] = true,
			["rust"] = true,
			["c"] = true,
			["c#"] = true,
			["c++"] = true,
			["go"] = true,
			["python"] = true,
		}

		-- Key mappings
		vim.keymap.set("i", "<C-L>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
		vim.g.copilot_no_tab_map = true
	end,
}
