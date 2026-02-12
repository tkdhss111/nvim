-- lua/config/keymaps.lua

--------------------------
-- 基本設定 / ショートカット
--------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- 保存 & 終了
map("n", "<leader>w", "<cmd>w<CR>", opts)
map("n", "<leader>q", "<cmd>q<CR>", opts)
map("n", "<leader>wq", "<cmd>wq<CR>", opts)

-- ESC: ハイライト解除
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

--------------------------
-- 移動系 / 画面操作
--------------------------

-- 行頭・行末 / ページ移動
map("n", "<C-h>", "0", { desc = "Move to line start" })
map("n", "<C-l>", "$", { desc = "Move to line end" })
map("v", "<C-h>", "0", { desc = "Move to line start" })
map("v", "<C-l>", "$", { desc = "Move to line end" })

-- 行移動（5行ずつ）
map("n", "<C-j>", "5j", { desc = "Page down" })
map("n", "<C-k>", "5k", { desc = "Page up" })

-- ウィンドウ分割の移動
map("n", "<S-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<S-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<S-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<S-l>", "<C-w>l", { desc = "Move to right window" })

-- ウィンドウサイズ調整
map("n", "<S-Up>", ":resize -2<CR>", opts)
map("n", "<S-Down>", ":resize +2<CR>", opts)
map("n", "<S-Left>", ":vertical resize -2<CR>", opts)
map("n", "<S-Right>", ":vertical resize +2<CR>", opts)

-- タブ操作
map("n", "<leader>tn", ":tabnew<CR>", opts)
map("n", "<leader>tc", ":tabclose<CR>", opts)
map("n", "<leader>to", ":tabonly<CR>", opts)
map("n", "<Tab>", "gt", opts)
map("n", "<S-Tab>", "gT", opts)

-- Word Wrap Settings
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "

-- Toggle wrap
map("n", "<leader>ww", function()
  vim.wo.wrap = not vim.wo.wrap
  print("Wrap: " .. (vim.wo.wrap and "ON" or "OFF"))
end, { desc = "Toggle Word Wrap" })

-- NERDTree keymaps defined in nerdtree.lua (lazy-load triggers)

-- Telescope keymaps defined in telescope.lua

--------------------------
-- LSP keymaps are defined in lua/plugins/lsp.lua (LspAttach autocmd)
--------------------------

--------------------------
-- ビルド / 実行キー
--------------------------
map("n", "<F2>", ":w<CR> :make debugrun<CR>", { desc = "Make debugrun" })
map("n", "<F3>", ":w<CR> :make test<CR>", { desc = "Make test" })
map("n", "<F4>", ":w<CR> :make run<CR>", { desc = "Make run" })
map("n", "<F5>", ":w<CR> :make release<CR>", { desc = "Make release" })

--------------------------
-- 端末モード
--------------------------
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<F12>", ":sp<CR>:terminal<CR>", { desc = "Open terminal split" })

--------------------------
-- Yank / 置換 系
--------------------------
map("n", "ciy", "ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>", { desc = "Replace word with yank" })
map("n", "<C-p>", "ciw<C-r>0<ESC>", { desc = "Replace word with yank" })
map("n", "cy", "Vp<CR>", { desc = "Replace line with yank" })

--------------------------
-- Insert モード補助
--------------------------
map("i", "<C-h>", "<BS>", opts)
map("i", "<C-l>", "<Del>", opts)
map("i", "<C-j>", "<Down>", opts)
map("i", "<C-k>", "<Up>", opts)
map("n", "<Space>", "i", { desc = "Change to insert mode" })
