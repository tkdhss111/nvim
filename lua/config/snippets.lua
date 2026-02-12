-- lua/config/snippets.lua

-- Only run if mini.snippets is available
local ok, mini_snippets = pcall(require, "mini.snippets")
if not ok then
  return
end

local gen_loader = mini_snippets.gen_loader

-- 言語検出パターン（必要であれば拡張可能）
local lang_patterns = {
  lua = { "%.lua$" },
  python = { "%.py$" },
  fortran = { "%.f90$", "%.f95$", "%.f03$" },
  cpp = { "%.cpp$", "%.hpp$", "%.cc$", "%.cxx$" },
  markdown = { "%.md$" },
}

mini_snippets.setup({
  snippets = {
    -- グローバルスニペットをロード
    gen_loader.from_file(vim.fn.expand("~/.config/nvim/snippets/global.json")),

    -- 言語ごとのスニペット
    gen_loader.from_lang({ lang_patterns = lang_patterns }),
  },

  -- スニペット操作用キーマップ
  mappings = {
    expand = "<C-s>",
    jump_next = "<Tab>",
    jump_prev = "<C-h>",
    stop = "<C-c>",
  },
})
