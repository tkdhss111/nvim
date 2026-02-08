-- lua/plugins/ctags.lua
return {
  -- Automatic tag generation and management
  {
    "ludovicchabant/vim-gutentags",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- tags file will be generated in the project root (default behavior)

      vim.g.gutentags_generate_on_new = true
      vim.g.gutentags_generate_on_missing = true
      vim.g.gutentags_generate_on_write = true
      vim.g.gutentags_generate_on_empty_buffer = false

      vim.g.gutentags_project_root = { ".gutctags", ".git" }
      vim.g.gutentags_exclude_project_root = { vim.fn.expand("~") }

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

      -- Fortran tagfunc: prefer submodule implementations (_smo) over
      -- interface declarations (_mo) so Ctrl+] jumps to the definition
      local function fortran_tagfunc(pattern, flags, info)
        local tags = vim.fn.taglist("^" .. vim.fn.escape(pattern, "\\") .. "$")
        if #tags == 0 then
          return vim.NIL
        end
        -- Sort: submodule files first
        table.sort(tags, function(a, b)
          local a_smo = a.filename:match("_smo%.") and 1 or 0
          local b_smo = b.filename:match("_smo%.") and 1 or 0
          return a_smo > b_smo
        end)
        local results = {}
        for _, tag in ipairs(tags) do
          table.insert(results, {
            name = tag.name,
            filename = tag.filename,
            cmd = tag.cmd,
            kind = tag.kind or "",
          })
        end
        return results
      end

      _G._fortran_tagfunc = fortran_tagfunc

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "fortran",
        callback = function()
          vim.bo.tagfunc = "v:lua._fortran_tagfunc"
        end,
      })
    end,
  },

  -- Vista: modern tagbar alternative (LSP + ctags)
  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
    keys = {
      { "<Leader>tv", "<cmd>Vista!!<cr>", desc = "Toggle Vista" },
      { "<F8>",       "<cmd>Vista!!<cr>", desc = "Toggle Vista" },
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
