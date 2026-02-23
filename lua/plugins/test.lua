-- lua/plugins/test.lua
-- Test runner via neotest

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Test Summary" },
    { "<leader>tO", function() require("neotest").output.open({ enter_on_open = true }) end, desc = "Show Test Output" },
    { "<leader>tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
        }),
      },
    })
  end,
}