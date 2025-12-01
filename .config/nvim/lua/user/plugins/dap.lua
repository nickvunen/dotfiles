return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup DAP UI (keeping your existing setup)
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 0.25,
						position = "bottom",
					},
				},
			})

			require("nvim-dap-virtual-text").setup()

			-- Python path detection
			local python_path = function()
				local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
				if vim.fn.filereadable(venv_path) == 1 then
					return venv_path
				end

				local handle = io.popen("poetry env info -p 2>/dev/null")
				if handle then
					local result = handle:read("*a")
					handle:close()
					result = result:gsub("%s+", "")
					if result ~= "" and vim.fn.isdirectory(result) == 1 then
						return result .. "/bin/python"
					end
				end

				return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
			end

			require("dap-python").setup(python_path())

			-- Load custom DAP configurations if they exist
			local has_custom_config, custom_config = pcall(require, "user.plugins.dap-config")
			if has_custom_config and custom_config then
				if custom_config.python and type(custom_config.python) == "table" then
					dap.configurations.python = custom_config.python
				end
			end

			-- Auto open/close UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Key mappings
			local keymap = vim.keymap
			keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue/Start Debug" })
			keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
			keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
			keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
			keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
			keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
			keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })
			keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
			keymap.set("n", "<leader>dR", function()
				dap.repl.open()
			end, { desc = "Open DAP REPL/Console" })

			-- Enable debug logging
			dap.set_log_level("DEBUG")
		end,
	},
}
