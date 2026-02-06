-- lua/plugins/treesitter.lua
-- Syntax parsing using Tree-sitter (new main branch API)

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",  -- Use new main branch
  build = ":TSUpdate",
  lazy = false,  -- nvim-treesitter does not support lazy-loading

  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "bash",
        "c",
        "fortran",
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "yaml",
        "json",
        "r",
        "rnoweb",
        "latex",
        "query",
        "html",
        "diff",
      },
      auto_install = true,
    })

    -- Enable treesitter-based highlighting for all filetypes
    -- (Neovim 0.11+ uses vim.treesitter.start() instead of plugin options)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
