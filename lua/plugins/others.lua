-- lua/plugins/others.lua
-- Miscellaneous useful plugins

return {
  -- TODO/highlights in comments like TODO:, FIX:, NOTE:
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
  },

  -- Git signs (line changes in left column)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  -- Quick terminal toggle
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Autosave
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        enabled = true,
        debounce_delay = 3000,
      })

      -- Detect OS only once
      if vim.fn.exists("g:os") == 0 then
        local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
        local username = os.getenv("USER") or os.getenv("USERNAME")

        if is_windows then
          vim.g.os = "Windows"
          vim.g.python3_host_prog = "C:/Python312/python.exe"
        else
          vim.g.os = (vim.fn.system("uname")):gsub("\n", "")
          vim.opt.backupdir = vim.fn.expand("/home/" .. username .. "/VIM_BACKUP_FILES//")
        end
      end

      -- Enable backup
      vim.opt.backup = true
      vim.opt.writebackup = true

      -- Fallback if user didn't set backupdir
      if vim.opt.backupdir:get()[1] == "" then
        vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup//"
      end

      -- Add HOURLY TIMESTAMP to backup filename
      -- Example: file.txt -> file.txt_2025-11-06_14
      vim.opt.backupext = "_" .. os.date("%Y-%m-%d_%H")

      -- Swap and undo
      vim.opt.swapfile = true
      vim.opt.undofile = true
      vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"

      -- Ensure directories exist
      for _, dir in ipairs({
        vim.opt.backupdir:get()[1],
        vim.opt.directory:get()[1] or (vim.fn.stdpath("data") .. "/swap//"),
        vim.opt.undodir:get()[1],
      }) do
        if dir and vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, "p")
        end
      end
    end,
  },

  -- CSV file support
  {
    "chrisbra/csv.vim",
    event = { "BufReadPre *.csv", "BufNewFile *.csv" },
    init = function()
      -- Must be set BEFORE plugin loads
      vim.g.csv_delim = ","
      vim.g.csv_nomap_space = 1
      vim.g.csv_nomap_l = 1  -- Prevent L override (keep Shift+L for window movement)
      vim.g.csv_nomap_h = 1  -- Prevent H override (keep Shift+H for window movement)
    end,
  },
}
