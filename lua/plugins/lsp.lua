-- lua/plugins/lsp.lua
-- LSP Configuration for Neovim 0.11+ with nvim-lspconfig v2+

return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },

  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Disable diagnostic signs (gutter marks) and underlines (wave lines)
    vim.diagnostic.config({
      signs = false,
      underline = false,
    })

    -- Global LSP keymaps (applied when LSP attaches)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        -- <leader>f formatting handled by conform.nvim
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
      end,
    })

    -- Configure servers using vim.lsp.config (Neovim 0.11+ native API)
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    vim.lsp.config("pyright", {
      capabilities = capabilities,
    })

    vim.lsp.config("yamlls", {
      capabilities = capabilities,
    })

    vim.lsp.config("r_language_server", {
      capabilities = capabilities,
    })

    -- Enable all servers
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("pyright")
    vim.lsp.enable("yamlls")
    vim.lsp.enable("r_language_server")
  end,
}
