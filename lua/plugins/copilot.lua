-- lua/plugins/copilot.lua
-- GitHub Copilot integration

return {
  -- Core Copilot plugin
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept    = "<CR>",
            refresh   = "gr",
            open      = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio    = 0.3,
          },
        },
        suggestion = {
          enabled      = true,
          auto_trigger = true,
          debounce     = 75,
          keymap       = {
            accept  = "<TAB>",
            next    = "<M-]>",
            prev    = "<M-[>",
            dismiss = "<C-e>",
          },
        },
        filetypes = {
          markdown  = true,
          help      = false,
          gitcommit = true,
          gitrebase = false,
          ["."]     = false,
        },
      })
    end,
  },

  -- Copilot <-> nvim-cmp integration
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    branch = "main",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      debug = false,
      show_help = true,
      auto_insert_mode = true,
      window = {
        layout = "float",
        width  = 0.5,
        height = 0.7,
        border = "rounded",
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChat<CR>",        desc = "Open Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain selected code" },
      { "<leader>cf", "<cmd>CopilotChatFix<CR>",     desc = "Fix selected code" },
      { "<leader>ct", "<cmd>CopilotChatTests<CR>",   desc = "Generate tests" },
      { "<leader>cq", "<cmd>CopilotChatAsk<CR>",     desc = "Ask quick question" },
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
    end,
  },
}
