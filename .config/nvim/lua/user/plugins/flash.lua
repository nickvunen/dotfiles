return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		modes = {
			-- disable search-mode integration: it hooks `/` and recomputes labels
			-- on every keystroke which causes visible lag while typing a search.
			search = {
				enabled = false,
			},
			char = {
				jump_labels = true,
			},
		},
	},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  },
}
