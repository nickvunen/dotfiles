return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	init = function()
		-- nvim-treesitter (master branch) registers its query predicates/directives with
		-- `all = false`, which Neovim 0.12 removed: handlers now always receive a list of
		-- nodes per capture id. Unwrap that list back to the last node so the handlers keep
		-- working (otherwise e.g. `#set-lang-from-info-string!` in the markdown injections
		-- query blows up with "attempt to call method 'range' (a nil value)").
		local tsquery = require("vim.treesitter.query")
		for _, name in ipairs({ "add_predicate", "add_directive" }) do
			local add = tsquery[name]
			tsquery[name] = function(qname, handler, opts)
				if type(opts) == "table" and opts.all == false then
					local inner = handler
					handler = function(match, ...)
						local unwrapped = {}
						for id, nodes in pairs(match) do
							unwrapped[id] = type(nodes) == "table" and nodes[#nodes] or nodes
						end
						return inner(unwrapped, ...)
					end
				end
				return add(qname, handler, opts)
			end
		end
	end,
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"markdown",
				"json",
				"javascript",
				"typescript",
				"python",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"rust",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
