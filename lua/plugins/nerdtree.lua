-- lua/plugins/nerdtree.lua
-- File explorer

return {
  "preservim/nerdtree",
  cmd = { "NERDTreeToggle", "NERDTreeFind" },
  keys = {
    { "<C-n>", "<cmd>NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
    { "<C-c>", "<cmd>NERDTreeFind<CR>", desc = "Find current file in NERDTree" },
    { "<S-r>", "<cmd>NERDTreeRefreshRoot<CR>", desc = "Refresh NERDTree" },
  },
  config = function()
    vim.g.NERDTreeChDirMode = 1
    vim.g.NERDTreeRespectWildcards = 1
    vim.g.NERDTreeIgnore = { "^.git$", "^node_modules$", "^dist$" }
    vim.g.NERDTreeQuitOnOpen = 1
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeShowBookmarks = 1
    vim.g.NERDTreeDirArrows = 1
    vim.g.NERDTreeWinSize = 35

    -- Auto-refresh when entering NERDTree window
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "NERD_tree_*",
      callback = function()
        vim.cmd("silent! NERDTreeRefreshRoot")
      end,
    })
  end,
}
