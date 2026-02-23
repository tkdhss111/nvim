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
        "dockerfile",
        "fortran",
        "lua",
        "luadoc",
        "python",
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
      callback = function(args)
        -- Skip filetypes where a dedicated syntax plugin is preferred
        local dominated_by_plugin = { csv = true }
        if dominated_by_plugin[vim.bo[args.buf].filetype] then
          return
        end
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
