-- parquet.nvim: local module (not a lazy.nvim plugin)
-- Source: ~/.config/nvim/lua/parquet/init.lua
return {
  dir = vim.fn.stdpath("config"),
  name = "parquet",
  config = function()
    require("parquet").setup()
  end,
}
