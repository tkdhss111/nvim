-- init.lua

-- Leader キー設定 (must be before lazy.setup)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Nerd Font detection (must be before plugins load)
vim.g.have_nerd_font = true

-- Providers (must be before plugins load)
vim.g.python3_host_prog = vim.fn.expand("~/.config/nvim/venv/bin/python")
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins from lua/plugins/*.lua
-- ✅ lazy.nvim automatically loads ALL files in lua/plugins/
require("lazy").setup("plugins", {
  ui = {
    border = "rounded",
  },
})

-- Load config files (NOT plugins - those are handled by lazy)
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- ❌ REMOVED: These are already loaded by lazy.setup("plugins")
-- require("plugins.lsp")
-- require("plugins.cmp")

-- Snippets config (this is OK - it's in config/, not plugins/)
-- But only load if mini.snippets is available
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(require, "config.snippets")
  end,
})

-- 色テーマは colorscheme.lua で設定済み
