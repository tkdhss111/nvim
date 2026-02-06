-- Colorscheme configuration (Tokyo Night)
return {
  "folke/tokyonight.nvim",
  lazy = false,            -- 起動時に読み込む
  priority = 1000,         -- 一番最初に適用
  config = function()
    require("tokyonight").setup({
      style = "night",     -- night / storm / moon / day から選択
      transparent = false, -- 透明背景を使うなら true
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = "dark", -- Sidebar の背景 (help, NvimTree など)
        floats = "dark",   -- 浮動ウィンドウの背景
      },
    })

    -- カラースキームを有効化
    vim.cmd([[colorscheme tokyonight]])
  end,
}

