-- lua/config/options.lua

-- ファイルエンコーディング
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 表示設定
vim.opt.number = true          -- 行番号
vim.opt.relativenumber = false -- 相対行番号
vim.opt.cursorline = true      -- カーソル行ハイライト
vim.opt.wrap = false
vim.opt.scrolloff = 5 -- 上下余裕ライン

-- インデント設定
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- 検索設定
vim.opt.ignorecase = true -- 大文字小文字無視
vim.opt.smartcase = true  -- 大文字含む検索なら無視しない
vim.opt.incsearch = true  -- 入力途中でハイライト
vim.opt.hlsearch = true   -- 検索結果のハイライト
vim.opt.autochdir = true  -- カレントディレクトリを自動変更

-- バックアップファイル関連
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- クリップボード
vim.opt.clipboard = "unnamedplus"

-- 表示色 / true color
vim.opt.termguicolors = true

-- Undo 履歴保存
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- サインカラムの常時表示（LSP診断の表示用）
vim.opt.signcolumn = "yes"

-- コマンドラインの高さ
vim.opt.cmdheight = 1
