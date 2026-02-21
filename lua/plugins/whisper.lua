return {
  "Avi-D-coder/whisper.nvim",
  lazy = false,
  config = function()
    require("whisper").setup({
      model = "medium",
      keybind = "<F9>",
      binary_path = vim.fn.expand("~/.local/bin/whisper-stream"),
      step_ms = 5000,
      length_ms = 8000,
      enable_streaming = false,
      language = "en",
    })
  end,
}
