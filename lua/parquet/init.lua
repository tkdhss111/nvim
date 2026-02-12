local M = {}

local csv_map = {}

local function duckdb_cmd(sql)
	local cmd = string.format('duckdb -c "%s"', sql)
	local result = vim.fn.system(cmd)
	return vim.v.shell_error, result
end

local function resolve_input_file(ext)
	if vim.b.parquet_source then
		return vim.b.parquet_source
	end
	if vim.bo.filetype == "nerdtree" then
		local node = vim.fn.eval("g:NERDTreeFileNode.GetSelected()")
		if node == vim.NIL or node == nil then
			return nil, "No file selected in NERDTree"
		end
		return vim.fn.eval("g:NERDTreeFileNode.GetSelected().path.str()")
	end
	return vim.fn.expand("%:p")
end

-- :ParquetToCsv [output.csv]
-- :ParquetToCsv input.parquet output.csv
local function cmd_parquet_to_csv(opts)
	local args = vim.split(opts.args, "%s+", { trimempty = true })
	local input, output
	if #args >= 2 then
		input = vim.fn.fnamemodify(args[1], ":p")
		output = vim.fn.fnamemodify(args[2], ":p")
	elseif #args == 1 then
		output = vim.fn.fnamemodify(args[1], ":p")
	end
	if not input then
		local err
		input, err = resolve_input_file("parquet")
		if not input then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
	end
	if not input:match("%.parquet$") then
		vim.notify("Not a .parquet file: " .. input, vim.log.levels.ERROR)
		return
	end
	output = output or input:gsub("%.parquet$", ".csv")
	local sql = string.format("COPY (SELECT * FROM '%s') TO '%s' (HEADER, DELIMITER ',');", input, output)
	local stderr_chunks = {}
	vim.fn.jobstart(string.format('duckdb -c "%s"', sql), {
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				if line ~= "" then table.insert(stderr_chunks, line) end
			end
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				if code == 0 then
					vim.notify("Saved: " .. output)
				else
					vim.notify("Conversion failed: " .. table.concat(stderr_chunks, "\n"), vim.log.levels.ERROR)
				end
			end)
		end,
	})
end

-- :CsvToParquet [output.parquet]
-- :CsvToParquet input.csv output.parquet
local function cmd_csv_to_parquet(opts)
	local args = vim.split(opts.args, "%s+", { trimempty = true })
	local input, output
	if #args >= 2 then
		input = vim.fn.fnamemodify(args[1], ":p")
		output = vim.fn.fnamemodify(args[2], ":p")
	elseif #args == 1 then
		output = vim.fn.fnamemodify(args[1], ":p")
	end
	if not input then
		local err
		input, err = resolve_input_file("csv")
		if not input then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end
	end
	if not input:match("%.csv$") then
		vim.notify("Not a .csv file: " .. input, vim.log.levels.ERROR)
		return
	end
	output = output or input:gsub("%.csv$", ".parquet")
	local sql = string.format("COPY (SELECT * FROM '%s') TO '%s' (FORMAT PARQUET);", input, output)
	local stderr_chunks = {}
	vim.fn.jobstart(string.format('duckdb -c "%s"', sql), {
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				if line ~= "" then table.insert(stderr_chunks, line) end
			end
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				if code == 0 then
					vim.notify("Saved: " .. output)
				else
					vim.notify("Conversion failed: " .. table.concat(stderr_chunks, "\n"), vim.log.levels.ERROR)
				end
			end)
		end,
	})
end

function M.setup()
	local group = vim.api.nvim_create_augroup("Parquet", { clear = true })

	-- Commands
	vim.api.nvim_create_user_command("ParquetToCsv", cmd_parquet_to_csv, {
		nargs = "*", complete = "file",
		desc = "Convert parquet to CSV: [output.csv] or [input.parquet output.csv]",
	})
	vim.api.nvim_create_user_command("CsvToParquet", cmd_csv_to_parquet, {
		nargs = "*", complete = "file",
		desc = "Convert CSV to parquet: [output.parquet] or [input.csv output.parquet]",
	})

	-- Open parquet as CSV
	vim.api.nvim_create_autocmd("BufReadCmd", {
		group = group,
		pattern = "*.parquet",
		callback = function()
			local parquet_file = vim.fn.expand("%:p")
			local buf = vim.api.nvim_get_current_buf()
			vim.bo[buf].swapfile = false
			local dir = vim.fn.fnamemodify(parquet_file, ":h")
			local basename = vim.fn.fnamemodify(parquet_file, ":t:r")
			local tmp_csv = string.format("%s/.tmp_parquet_%s.csv", dir, basename)

			local exit_code, result = duckdb_cmd(
				string.format("COPY (SELECT * FROM '%s') TO '%s' (HEADER, DELIMITER ',');", parquet_file, tmp_csv)
			)
			if exit_code ~= 0 or vim.fn.filereadable(tmp_csv) == 0 then
				vim.notify("ParquetToCsv failed (exit=" .. exit_code .. "): " .. result, vim.log.levels.ERROR)
				return
			end

			local lines = vim.fn.readfile(tmp_csv)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].modified = false
			vim.api.nvim_buf_set_name(buf, tmp_csv)
			vim.cmd("filetype detect")

			csv_map[buf] = { parquet = parquet_file, csv = tmp_csv, saved = false }
			vim.b.parquet_source = parquet_file
			vim.notify("Opened: " .. parquet_file .. " -> " .. tmp_csv)
		end,
	})

	-- On save: convert CSV back to parquet
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		pattern = "*",
		callback = function()
			local buf = vim.api.nvim_get_current_buf()
			local info = csv_map[buf]
			if not info then return end
			info.saved = true
			local exit_code, result = duckdb_cmd(
				string.format("COPY (SELECT * FROM '%s') TO '%s' (FORMAT PARQUET);", info.csv, info.parquet)
			)
			if exit_code == 0 then
				vim.notify("Saved: " .. info.parquet)
			else
				vim.notify("CsvToParquet failed: " .. result, vim.log.levels.ERROR)
			end
		end,
	})

	-- On buffer close: clean up temp CSV
	vim.api.nvim_create_autocmd("BufUnload", {
		group = group,
		pattern = "*",
		callback = function(ev)
			local info = csv_map[ev.buf]
			if not info then return end
			csv_map[ev.buf] = nil
			vim.fn.delete(info.csv)
		end,
	})

	-- On Neovim exit: clean up all remaining temp CSVs
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			for buf, info in pairs(csv_map) do
				vim.fn.delete(info.csv)
				csv_map[buf] = nil
			end
		end,
	})
end

return M
