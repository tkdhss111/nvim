return {
  "wincent/ferret",
  config = function()
    vim.g.FerretExecutable = "rg"
    vim.g.FerretArgs =
    "--hidden --smart-case --no-heading --with-filename --line-number --column --glob='!build/'"
    vim.g.FerretQFCommand = "copen"
  end,
}
