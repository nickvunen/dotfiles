return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python", -- Make sure python adapter is included!
	},
	-- Deferred until a test mapping is used.
	keys = {
		{ "<leader>tt", desc = "Run nearest test" },
		{ "<leader>tf", desc = "Run file tests" },
		{ "<leader>ts", desc = "Toggle test summary" },
		{ "<leader>tc", desc = "Run current test" },
		{ "<leader>tl", desc = "Run last test" },
		{ "<leader>td", desc = "Debug nearest test" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false },
					args = { "--maxfail=1", "--disable-warnings" },
					runner = "pytest",
					python = "python3",
				}),
			},
		})

		local neotest = require("neotest")
		vim.keymap.set("n", "<leader>tt", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })
		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run test file" })
		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Toggle test summary" })
		vim.keymap.set("n", "<leader>tc", function()
			neotest.output.open({ enter = true })
		end, { desc = "Open test output" })
		vim.keymap.set("n", "<leader>tl", function()
			neotest.run.run_last()
		end, { desc = "Run last test" })
		vim.keymap.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test with DAP" })
	end,
}
