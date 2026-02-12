-- lua/plugins/r.lua
return {
  {
    "R-nvim/R.nvim",
    ft = { "r", "rmd", "quarto", "rnoweb", "rhelp" },
    config = function()
      local opts = {
        R_args = { "--quiet", "--no-save" },
        hook = {
          on_filetype = function()
            -- Send line/selection
            vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true, desc = "Send line to R" })
            vim.keymap.set("v", "<Enter>", "<Plug>RSendSelection", { buffer = true, desc = "Send selection to R" })

            -- Alternative with leader key
            vim.keymap.set("n", "<Leader>l", "<Plug>RDSendLine", { buffer = true, desc = "Send line to R" })
            vim.keymap.set("v", "<Leader>l", "<Plug>RSendSelection", { buffer = true, desc = "Send selection to R" })

            -- Send from line 1 to current line (above + current)
            vim.keymap.set("n", "<Leader>su", function()
              local current_line = vim.fn.line(".")
              vim.cmd("1," .. current_line .. "RSend")
            end, { buffer = true, desc = "Send lines above to R" })

            -- Send from current line to end of file
            vim.keymap.set("n", "<Leader>sd", function()
              local current_line = vim.fn.line(".")
              local last_line = vim.fn.line("$")
              vim.cmd(current_line .. "," .. last_line .. "RSend")
            end, { buffer = true, desc = "Send to end of file" })

            -- Assignment and pipe
            vim.keymap.set("i", ";;", " <- ", { buffer = true, desc = "Insert assignment" })
            vim.keymap.set("i", ">>", " |> ", { buffer = true, desc = "Insert pipe" })
          end,
        },
        min_editor_width = 80,
        rconsole_width = 0,
        rconsole_height = 15,
      }
      require("r").setup(opts)
    end,
  },
}
