-- lua/plugins/mini.lua
-- Mini.nvim collection of small plugins

return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      -- Text objects
      -- require("mini.ai").setup({ n_lines = 500 })

      -- Move lines/selections
      require("mini.move").setup()

      -- Align text
      require("mini.align").setup()

      -- Split/join arguments
      require("mini.splitjoin").setup()

      -- Auto pairs
      -- require("mini.pairs").setup()

      -- Key hints
      require("mini.clue").setup()

      -- Comment toggling
      require("mini.comment").setup()

      -- Snippets setup is in config/snippets.lua (loaded via VeryLazy)
    end,
  },
}
