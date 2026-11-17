return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	lazy = false,
	config = function()
		require("nvim-treesitter-textobjects").setup({
			select = { lookahead = true },
			move = { set_jumps = true },
		})

		local select = require("nvim-treesitter-textobjects.select")
		local swap = require("nvim-treesitter-textobjects.swap")
		local move = require("nvim-treesitter-textobjects.move")

		local function map_select(lhs, query, desc)
			vim.keymap.set({ "x", "o" }, lhs, function()
				select.select_textobject(query, "textobjects")
			end, { desc = desc })
		end

		local function map_swap(lhs, direction, query, desc)
			vim.keymap.set("n", lhs, function()
				swap[direction](query, "textobjects")
			end, { desc = desc })
		end

		local function map_move(lhs, direction, query, desc, query_group)
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move[direction](query, query_group or "textobjects")
			end, { desc = desc })
		end

		map_select("a=", "@assignment.outer", "Select outer assignment")
		map_select("i=", "@assignment.inner", "Select inner assignment")
		map_select("l=", "@assignment.lhs", "Select assignment left-hand side")
		map_select("r=", "@assignment.rhs", "Select assignment right-hand side")
		map_select("a:", "@property.outer", "Select outer object property")
		map_select("i:", "@property.inner", "Select inner object property")
		map_select("l:", "@property.lhs", "Select property left-hand side")
		map_select("r:", "@property.rhs", "Select property right-hand side")
		map_select("aa", "@parameter.outer", "Select outer parameter")
		map_select("ia", "@parameter.inner", "Select inner parameter")
		map_select("ai", "@conditional.outer", "Select outer conditional")
		map_select("ii", "@conditional.inner", "Select inner conditional")
		map_select("al", "@loop.outer", "Select outer loop")
		map_select("il", "@loop.inner", "Select inner loop")
		map_select("af", "@call.outer", "Select outer function call")
		map_select("if", "@call.inner", "Select inner function call")
		map_select("am", "@function.outer", "Select outer function")
		map_select("im", "@function.inner", "Select inner function")
		map_select("ac", "@class.outer", "Select outer class")
		map_select("ic", "@class.inner", "Select inner class")

		map_swap("<leader>na", "swap_next", "@parameter.inner", "Swap parameter with next")
		map_swap("<leader>n:", "swap_next", "@property.outer", "Swap property with next")
		map_swap("<leader>nm", "swap_next", "@function.outer", "Swap function with next")
		map_swap("<leader>pa", "swap_previous", "@parameter.inner", "Swap parameter with previous")
		map_swap("<leader>p:", "swap_previous", "@property.outer", "Swap property with previous")
		map_swap("<leader>pm", "swap_previous", "@function.outer", "Swap function with previous")

		map_move("]f", "goto_next_start", "@call.outer", "Next function call start")
		map_move("]m", "goto_next_start", "@function.outer", "Next function start")
		map_move("]c", "goto_next_start", "@class.outer", "Next class start")
		map_move("]i", "goto_next_start", "@conditional.outer", "Next conditional start")
		map_move("]l", "goto_next_start", "@loop.outer", "Next loop start")
		map_move("]s", "goto_next_start", "@scope", "Next scope start", "locals")
		map_move("]z", "goto_next_start", "@fold", "Next fold start", "folds")
		map_move("]F", "goto_next_end", "@call.outer", "Next function call end")
		map_move("]M", "goto_next_end", "@function.outer", "Next function end")
		map_move("]C", "goto_next_end", "@class.outer", "Next class end")
		map_move("]I", "goto_next_end", "@conditional.outer", "Next conditional end")
		map_move("]L", "goto_next_end", "@loop.outer", "Next loop end")
		map_move("[f", "goto_previous_start", "@call.outer", "Previous function call start")
		map_move("[m", "goto_previous_start", "@function.outer", "Previous function start")
		map_move("[c", "goto_previous_start", "@class.outer", "Previous class start")
		map_move("[i", "goto_previous_start", "@conditional.outer", "Previous conditional start")
		map_move("[l", "goto_previous_start", "@loop.outer", "Previous loop start")
		map_move("[F", "goto_previous_end", "@call.outer", "Previous function call end")
		map_move("[M", "goto_previous_end", "@function.outer", "Previous function end")
		map_move("[C", "goto_previous_end", "@class.outer", "Previous class end")
		map_move("[I", "goto_previous_end", "@conditional.outer", "Previous conditional end")
		map_move("[L", "goto_previous_end", "@loop.outer", "Previous loop end")

		local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
		vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite)
		vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T_expr, { expr = true })
	end,
}
