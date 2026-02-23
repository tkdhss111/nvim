-- lua/plugins/venv.lua
-- Virtual environment selector for Python

return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap-python",
  },
  ft = "python",
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<CR>", desc = "Select Virtualenv" },
  },
  opts = {},
}