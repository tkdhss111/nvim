-- lua/plugins/ctags.lua
return {
  -- Automatic tag generation and management
  {
    "ludovicchabant/vim-gutentags",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/tags"
      vim.fn.mkdir(vim.g.gutentags_cache_dir, "p")

      vim.g.gutentags_generate_on_new = true
      vim.g.gutentags_generate_on_missing = true
      vim.g.gutentags_generate_on_write = true
      vim.g.gutentags_generate_on_empty_buffer = false

      vim.g.gutentags_project_root = { ".git", ".hg", ".svn", "package.json", "Makefile", "DESCRIPTION" }

      vim.g.gutentags_ctags_exclude = {
        "*.git", "*.svg", "*.hg", "*/tests/*", "build", "dist",
        "node_modules", "bower_components", "cache", "vendor",
        "*.md", "*-lock.json", "*.lock", "*.min.*", "*.map",
        "*.pyc", "*.class", "*.swp", "*.swo",
        "*.jpg", "*.png", "*.gif", "*.pdf", "*.zip", "*.tar.gz",
        "*/data/*", "*/log/*",
      }

      vim.g.gutentags_ctags_executable = "ctags"
      vim.g.gutentags_ctags_extra_args = {
        "--tag-relative=yes",
        "--fields=+ailmnS",
      }
    end,
  },

  -- Vista: modern tagbar alternative (LSP + ctags)
  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
    keys = {
      { "<Leader>tv", "<cmd>Vista!!<cr>", desc = "Toggle Vista" },
      { "<F8>", "<cmd>Vista!!<cr>", desc = "Toggle Vista" },
    },
    config = function()
      vim.g.vista_default_executive = "ctags"
      vim.g.vista_sidebar_width = 35
      vim.g.vista_echo_cursor = 1
      vim.g.vista_cursor_delay = 100
      vim.g.vista_close_on_jump = 0
      vim.g.vista_stay_on_open = 1
      vim.g.vista_blink = { 2, 100 }

      vim.g.vista_executive_for = {
        r = "ctags",
        lua = "nvim_lsp",
        python = "nvim_lsp",
      }

      vim.g["vista#renderer#enable_icon"] = 1
    end,
  },
}
