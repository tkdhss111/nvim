-- lua/plugins/telescope.lua
-- Fuzzy finder and picker

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")

    telescope.setup({
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 10,
      },
      extensions = {
        ["ui-select"] = {
          themes.get_dropdown({}),
        },
      },
    })

    -- Extensions
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")

    -- Keymaps
    local map = vim.keymap.set
    map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
    map("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
    map("n", "<leader>fo", builtin.oldfiles, { desc = "Recent Files" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
  end,
}
