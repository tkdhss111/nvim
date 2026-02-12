-- lua/plugins/claude.lua
-- Claude Code integration for Neovim
return {
  "coder/claudecode.nvim",
  lazy = false,
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                 desc = "Send to Claude" },
  },
  opts = {
    terminal_cmd = vim.fn.expand("~/.local/bin/claude"),

    terminal = {
      split_side = "right",
      split_width_percentage = 0.30,
      provider = "native",
    },
  },
  config = function(_, opts)
    require("claudecode").setup(opts)

    -- Auto-open Claude Code when opening R source files
--    vim.api.nvim_create_autocmd("FileType", {
--      pattern = { "r", "rmd", "rnoweb", "rhelp", "rdoc", "quarto", "fortran", "markdown", "lua" },
--      callback = function()
--        -- Small delay to ensure the buffer is fully loaded
--        vim.defer_fn(function()
--          -- Only open if Claude is not already visible
--          local claude_open = false
--          for _, win in ipairs(vim.api.nvim_list_wins()) do
--            local buf = vim.api.nvim_win_get_buf(win)
--            local bufname = vim.api.nvim_buf_get_name(buf)
--            if bufname:match("claude") or vim.bo[buf].filetype == "ClaudeCode" then
--              claude_open = true
--              break
--            end
--          end
--          if not claude_open then
--            vim.cmd("ClaudeCode")
--          end
--        end, 100)
--      end,
--      desc = "Auto-open Claude Code for R/Fortran/Markdown files",
--    })
  end,
}
