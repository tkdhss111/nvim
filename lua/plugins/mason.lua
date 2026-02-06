-- lua/plugins/mason.lua
-- Mason (LSP, DAP, Tools Installer) - v2.0+ compatible
-- Requires: Neovim >= 0.11, mason.nvim >= 2.0, nvim-lspconfig >= 2.0

return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    priority = 100,
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-LSPConfig (bridge between mason & LSP servers)
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "yamlls",
        "r_language_server",
      },
      -- automatic_enable = true is the default in v2.0+
    },
  },
}
