-- lua/plugins/iron.lua
-- REPL manager for sending code to Python/IPython

return {
  "Vigemus/iron.nvim",
  ft = { "python" },
  keys = {
    { "<leader>sr", "<cmd>IronRepl<CR>", desc = "Open/restart REPL" },
    { "<leader>sq", "<cmd>IronHide<CR>", desc = "Hide REPL" },
  },
  config = function()
    require("iron.core").setup({
      config = {
        repl_definition = {
          python = {
            command = function()
              -- Prefer ipython if available, fallback to python
              if vim.fn.executable("ipython") == 1 then
                return { "ipython", "--no-autoindent" }
              end
              return { "python3" }
            end,
          },
        },
        repl_open_cmd = "vertical botright 80 split",
      },
      keymaps = {
        send_mark = "<leader>sm",
        mark_visual = "<leader>mc",
        remove_mark = "<leader>md",
        cr = "<leader>s<CR>",
        interrupt = "<leader>s<Space>",
        exit = "<leader>sQ",
        clear = "<leader>sl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })

    -- Python buffer-local keymaps matching R-style shortcuts
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "python",
      callback = function()
        local iron = require("iron.core")

        -- Send line / selection with Enter (like R)
        vim.keymap.set("n", "<Enter>", function() iron.send_line() end,
          { buffer = true, desc = "Send line to REPL" })
        vim.keymap.set("v", "<Enter>", function() iron.visual_send() end,
          { buffer = true, desc = "Send selection to REPL" })

        -- Alternative with leader key (like R)
        vim.keymap.set("n", "<Leader>l", function() iron.send_line() end,
          { buffer = true, desc = "Send line to REPL" })
        vim.keymap.set("v", "<Leader>l", function() iron.visual_send() end,
          { buffer = true, desc = "Send selection to REPL" })

        -- Send from line 1 to current line (like R's <Leader>su)
        vim.keymap.set("n", "<Leader>su", function() iron.send_until_cursor() end,
          { buffer = true, desc = "Send lines above to REPL" })

        -- Send from current line to end of file (like R's <Leader>sd)
        vim.keymap.set("n", "<Leader>sd", function()
          local current_line = vim.fn.line(".")
          local last_line = vim.fn.line("$")
          local lines = vim.api.nvim_buf_get_lines(0, current_line - 1, last_line, false)
          iron.send(nil, lines)
        end, { buffer = true, desc = "Send to end of file" })

        -- Send entire file (no R equivalent, but useful for Python)
        vim.keymap.set("n", "<Leader>sf", function() iron.send_file() end,
          { buffer = true, desc = "Send file to REPL" })
      end,
    })
  end,
}
