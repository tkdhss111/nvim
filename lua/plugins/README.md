# Neovim Config Corrections

## Files to Replace

Copy these files to `~/.config/nvim/lua/plugins/`:

| New File | Original | Changes |
|----------|----------|---------|
| `claude.lua` | `claude.lua` | Added keymaps (`<leader>ac`, `<leader>at`) and setup config |
| `mason.lua` | `mason.lua` | Fixed broken `require("lazy").setup()` structure |
| `lsp.lua` | `lsp.lua` | Enabled `setup_handlers`, added keymaps (gd, K, etc.) |
| `init.lua` | `init.lua` | Removed duplicate plugins (now minimal) |
| `copilot.lua` | `copilot.lua` | Fixed UTF-8 encoding (â†" → ↔) |
| `mini.lua` | `mini.lua` | Fixed UTF-8 encoding |
| `others.lua` | `others.lua` | Fixed UTF-8 encoding (â€¾ → ‾) |
| `git.lua` | `git.lua` | Removed duplicate gitsigns, added fugitive keymaps |
| `telescope.lua` | `telescolpe.lua` | Fixed filename typo |
| `nerdtree.lua` | `nardtree.lua` | Fixed filename typo |

## Files NOT Changed (OK as-is)

- `colorscheme.lua`
- `cmp.lua`
- `conform.lua`
- `ctags.lua`
- `ferret.lua`
- `markdown.lua`
- `r.lua`
- `statusline.lua`
- `treesitter.lua`

## Key Bindings Added

### Claude Code
- `<leader>ac` - Open Claude Code
- `<leader>at` - Toggle Claude Code

### LSP (now working)
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<C-k>` - Signature help
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>e` - Show diagnostics
- `[d` / `]d` - Previous/next diagnostic

### Git (fugitive)
- `<leader>gs` - Git status
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff
- `<leader>gl` - Git log

## Installation

```bash
# Backup existing config
cp -r ~/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins.bak

# Copy corrected files
cp nvim-config/*.lua ~/.config/nvim/lua/plugins/

# Delete old files with typos
rm -f ~/.config/nvim/lua/plugins/telescolpe.lua
rm -f ~/.config/nvim/lua/plugins/nardtree.lua

# Restart Neovim and sync plugins
nvim -c "Lazy sync"
```

## Prerequisites for Claude Code

```bash
# Install Claude Code CLI
npm install -g @anthropic-ai/claude-code

# First run - authenticate via browser
claude
```
