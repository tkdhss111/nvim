-- Markdown preview & enhancements
return {
  -- ブラウザでプレビュー
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_start = 0         -- 自動プレビューしない
      vim.g.mkdp_auto_close = 1         -- バッファ閉じたら自動停止
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- Neovim 内に Markdown プレビュー
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("markview").setup({
        preview = {
          auto_start = false,  -- 自動開始しない
          auto_close = true,   -- バッファ閉じたら閉じる
        },
      })
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkviewToggle<CR>",
        { desc = "Toggle Markdown Preview" })
    end,
  },
}

