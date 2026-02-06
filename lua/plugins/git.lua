-- lua/plugins/git.lua
-- Git related plugins

return {
  -- Git commands: :Git, :Gdiff, :Gblame, etc.
  {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff" },
      { "<leader>gl", "<cmd>Git log<CR>", desc = "Git log" },
    },
  },

  -- Note: gitsigns is configured in others.lua
}
