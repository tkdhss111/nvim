-- Statusline (Mini.statusline)
return {
  "echasnovski/mini.statusline",
  lazy = false,  -- 必ず読み込む
  config = function()
    local statusline = require("mini.statusline")
    statusline.setup({
      use_icons = vim.g.have_nerd_font, -- Nerd Font があればアイコン対応
    })

    -- 表示内容のカスタマイズ（行番号:列番号）
    statusline.section_location = function()
      return "%2l:%-2v"
    end
  end,
}

