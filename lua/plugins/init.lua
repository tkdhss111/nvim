-- lua/plugins/init.lua
-- Minimal plugin list - other plugins defined in separate files

return {
  -- Lazy self-management
  { "folke/lazy.nvim", lazy = false, priority = 1000 },

  -- Comment toggling
  { "numToStr/Comment.nvim", config = true },

  -- Auto-detect indent
  { "tpope/vim-sleuth" },

  -- Plenary (dependency for many plugins)
  { "nvim-lua/plenary.nvim", lazy = true },
}

-- Note: Other plugins are loaded from separate files:
-- colorscheme.lua, mason.lua, lsp.lua, cmp.lua, telescope.lua,
-- treesitter.lua, git.lua, r.lua, copilot.lua, claude.lua, etc.
