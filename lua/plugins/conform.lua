-- Format (Conform.nvim)
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- 保存時に自動フォーマット
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- C / C++ は LSP フォーマットしない
      local disable = { c = true, cpp = true }
      if disable[vim.bo[bufnr].filetype] then
        return { lsp_format = "never" }
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    formatters = {
      black = {
        command = vim.fn.expand("~/.config/nvim/venv/bin/black"),
      },
      isort = {
        command = vim.fn.expand("~/.config/nvim/venv/bin/isort"),
      },
    },
  },
}
