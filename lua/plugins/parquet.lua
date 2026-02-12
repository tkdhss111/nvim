return {
	"parquet.nvim",
	dir = vim.fn.expand("~/parquet.nvim"),
	lazy = false,
	config = function()
		require("parquet").setup()
	end,
}
