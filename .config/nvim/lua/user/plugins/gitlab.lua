return {
	{
		"harrisoncramer/gitlab.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			-- Recommended but not required
			"stevearc/dressing.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		build = function()
			require("gitlab.server").build(true)
		end,
		config = function()
			require("gitlab").setup()
			-- Shortcut mappings
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }

			map("n", "<leader>gls", function()
				require("gitlab").summary()
			end, vim.tbl_extend("force", opts, { desc = "GitLab MR Summary" }))

			map("n", "<leader>glr", function()
				require("gitlab").review()
			end, vim.tbl_extend("force", opts, { desc = "Start MR Review" }))

			map("n", "<leader>glc", function()
				require("gitlab").create_note()
			end, vim.tbl_extend("force", opts, { desc = "Add Comment/Note" }))

			map("n", "<leader>gla", function()
				require("gitlab").approve()
			end, vim.tbl_extend("force", opts, { desc = "Approve MR" }))

			map("n", "<leader>glA", function()
				require("gitlab").revoke_approval()
			end, vim.tbl_extend("force", opts, { desc = "Revoke MR Approval" }))

			map("n", "<leader>glm", function()
				require("gitlab").merge()
			end, vim.tbl_extend("force", opts, { desc = "Merge MR" }))

			map("n", "<leader>gll", function()
				require("gitlab").pipeline()
			end, vim.tbl_extend("force", opts, { desc = "Show Pipeline" }))
		end,
	},
}
