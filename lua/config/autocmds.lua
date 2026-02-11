-- lua/config/autocmds.lua

-- Neovim の自動コマンド設定
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- グループ作成（整理用）
local general = augroup("GeneralSettings", { clear = true })

-- 保存時に自動でファイルを再読み込み（外部で変更された場合）
autocmd("FocusGained", {
	group = general,
	command = "checktime",
})

---- 行末の余分な空白を保存前に削除
--autocmd("BufWritePre", {
--	group = general,
--	callback = function()
--		vim.cmd([[%s/\s\+$//e]])
--	end,
--})

-- ファイルタイプごとの設定例（YAMLでインデント変更など）
autocmd("FileType", {
	group = general,
	pattern = { "yaml", "yml" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

-- 自動で最後のカーソル位置に戻る
autocmd("BufReadPost", {
	group = general,
	callback = function()
		local last_pos = vim.fn.line([['"]])
		if last_pos > 1 and last_pos <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fortran",
	callback = function(event)
		local bufnr = event.buf
		vim.defer_fn(function()
			-- Enable conceal
			vim.opt_local.conceallevel = 2

			-- Conceal % as ▸
			vim.cmd([[
			  syntax match FortranConceal /%/ conceal cchar=.
			  highlight! link FortranConceal Special
			]])
	end, 10)

		-- ",," → "%" in insert mode
		vim.keymap.set("i", ",,", "%", { buffer = bufnr, noremap = true, silent = true })

		-- F6 key
		vim.keymap.set("n", "<F6>", ":w<CR>:Make relwithdebinfo<CR>", { buffer = bufnr, noremap = true, silent = true })
	end,
})

-- Parquet → CSV 変換コマンド (:ParquetToCsv [output.csv])
vim.api.nvim_create_user_command("ParquetToCsv", function(opts)
	local input = vim.fn.expand("%:p")
	if not input:match("%.parquet$") then
		vim.notify("Current file is not a .parquet file", vim.log.levels.ERROR)
		return
	end
	local output = opts.args ~= "" and opts.args or input:gsub("%.parquet$", ".csv")
	local cmd = string.format('duckdb -c "COPY (SELECT * FROM \'%s\') TO \'%s\' (HEADER, DELIMITER \',\');"', input, output)
	vim.fn.jobstart(cmd, {
		on_exit = function(_, code)
			if code == 0 then
				vim.schedule(function()
					vim.notify("Saved: " .. output)
				end)
			else
				vim.schedule(function()
					vim.notify("Conversion failed (exit code " .. code .. ")", vim.log.levels.ERROR)
				end)
			end
		end,
	})
end, { nargs = "?", desc = "Convert current parquet file to CSV" })

-- CSV → Parquet 変換コマンド (:CsvToParquet [output.parquet])
vim.api.nvim_create_user_command("CsvToParquet", function(opts)
	local input = vim.fn.expand("%:p")
	if not input:match("%.csv$") then
		vim.notify("Current file is not a .csv file", vim.log.levels.ERROR)
		return
	end
	local output = opts.args ~= "" and opts.args or input:gsub("%.csv$", ".parquet")
	local cmd = string.format('duckdb -c "COPY (SELECT * FROM \'%s\') TO \'%s\' (FORMAT PARQUET);"', input, output)
	vim.fn.jobstart(cmd, {
		on_exit = function(_, code)
			if code == 0 then
				vim.schedule(function()
					vim.notify("Saved: " .. output)
				end)
			else
				vim.schedule(function()
					vim.notify("Conversion failed (exit code " .. code .. ")", vim.log.levels.ERROR)
				end)
			end
		end,
	})
end, { nargs = "?", desc = "Convert current CSV file to Parquet" })

-- Parquet ファイルを DuckDB で開く
autocmd("BufReadCmd", {
	group = general,
	pattern = "*.parquet",
	callback = function()
		local file = vim.fn.expand("%:p")
		vim.cmd("tabnew")
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "wipe"
		vim.bo.swapfile = false
		vim.fn.termopen('duckdb -c "SELECT * FROM \'' .. file .. '\';"')
	end,
})
