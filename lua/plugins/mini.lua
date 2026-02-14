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

      -- Snippets
      local mini_snips = require("mini.snippets")
      local gen_loader = mini_snips.gen_loader

      mini_snips.setup({
        -- Load only YOUR snippet file(s)
        snippets = {
          gen_loader.from_file(vim.fn.expand("~/.config/nvim/snippets/global.json")),
        },

        -- Prevent mini.nvim from searching default runtime snippets
        custom_dirs = {},
        silent = true,

        mappings = {
          expand = "<C-s>",
          jump_next = "<M-l>",
          jump_prev = "<M-h>",
          stop = "<C-c>",
        },
      })
    end,
  },
}
