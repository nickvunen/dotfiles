return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = { "folke/snacks.nvim" },
  config = function()
    local opencode_cmd = "opencode --port"
    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      win = {
        position = "right",
        enter = false,
      },
    }

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
        end,
      },
    }

    vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

    local opencode = function()
      return require("opencode")
    end

    -- Toggle TUI window
    vim.keymap.set({ "n", "t" }, "<leader>ac", function()
      require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
    end, { desc = "Toggle OpenCode window" })

    -- Show TUI when a prompt is submitted
    vim.api.nvim_create_autocmd("User", {
      pattern = "OpencodeEvent:tui.command.execute",
      callback = function(args)
        ---@type opencode.server.Event
        local event = args.data.event
        if event.properties.command == "prompt.submit" then
          local win = require("snacks.terminal").get(opencode_cmd, { create = false })
          if win then
            win:show()
          end
        end
      end,
    })

    -- Core
    vim.keymap.set({ "n", "x" }, "<leader>aa", function() opencode().ask("@this: ") end, { desc = "Ask OpenCode" })
    vim.keymap.set({ "n", "x" }, "<leader>as", function() opencode().select() end, { desc = "Select OpenCode prompt/command" })
    vim.keymap.set("n", "<leader>an", function() opencode().command("session.new") end, { desc = "New OpenCode session" })
    vim.keymap.set("n", "<leader>ai", function() opencode().command("session.interrupt") end, { desc = "Interrupt OpenCode session" })

    -- Quick prompts
    vim.keymap.set({ "n", "x" }, "<leader>ae", function() opencode().prompt("Explain @this and its context") end, { desc = "Explain @this" })
    vim.keymap.set({ "n", "x" }, "<leader>af", function() opencode().prompt("Fix @diagnostics") end, { desc = "Fix @diagnostics" })
    vim.keymap.set({ "n", "x" }, "<leader>ar", function() opencode().prompt("Review @this for correctness and readability") end, { desc = "Review @this" })
    vim.keymap.set({ "n", "x" }, "<leader>at", function() opencode().prompt("Add tests for @this") end, { desc = "Tests for @this" })

    -- Scroll TUI
    vim.keymap.set("n", "<leader>au", function() opencode().command("session.half.page.up") end, { desc = "Scroll OpenCode up" })
    vim.keymap.set("n", "<leader>ad", function() opencode().command("session.half.page.down") end, { desc = "Scroll OpenCode down" })

    -- Operator (range + dot-repeat)
    vim.keymap.set({ "n", "x" }, "go", function() return opencode().operator("@this ") end, { desc = "Append range to OpenCode", expr = true })
    vim.keymap.set("n", "goo", function() return opencode().operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })
  end,
}
