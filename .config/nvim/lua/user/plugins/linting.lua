return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		local function resolve_pylint()
			local venv_pylint = vim.fn.getcwd() .. "/.venv/bin/pylint"
			if vim.fn.executable(venv_pylint) == 1 then
				return venv_pylint
			end
			return "pylint"
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				require("lint").linters.pylint.cmd = resolve_pylint()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			require("lint").linters.pylint.cmd = resolve_pylint()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
