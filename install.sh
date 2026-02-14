#!/usr/bin/env bash
# ============================================================================
# Neovim Configuration Installation Script
# ============================================================================
# Installs all system packages, language runtimes, and tools required by
# this Neovim configuration. Designed for Ubuntu/Debian-based systems.
#
# Usage:
#   chmod +x install.sh
#   ./install.sh
#
# Requirements: Neovim >= 0.11, git
# ============================================================================

set -euo pipefail

# --- Colors for output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# --- Check if running as root (we don't want that) ---
if [[ "$EUID" -eq 0 ]]; then
    error "Do not run this script as root. It will use sudo when needed."
    exit 1
fi

# --- Detect OS ---
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS_ID="${ID:-unknown}"
else
    OS_ID="unknown"
fi

if [[ "$OS_ID" != "ubuntu" && "$OS_ID" != "debian" && "$OS_ID" != "linuxmint" && "$OS_ID" != "pop" ]]; then
    warn "This script is designed for Ubuntu/Debian. Detected: $OS_ID"
    warn "Package install commands may need adjustment for your distro."
    read -rp "Continue anyway? [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]] || exit 1
fi

echo ""
echo "============================================"
echo "  Neovim Configuration Installer"
echo "============================================"
echo ""

# ============================================================================
# 1. System Packages (apt)
# ============================================================================
info "Installing system packages..."

sudo apt-get update -qq

PACKAGES=(
    # Core tools
    git
    curl
    wget
    unzip

    # Build essentials (needed for telescope-fzf-native, treesitter parsers)
    build-essential
    cmake

    # Neovim dependencies
    ripgrep          # ferret, telescope live_grep
    fd-find          # telescope find_files (optional but recommended)
    universal-ctags  # vim-gutentags, vista.vim

    # Clipboard support
    xclip            # system clipboard (unnamedplus)

    # Python
    python3
    python3-pip
    python3-venv

    # R language
    r-base

    # Node.js will be installed via nvm (see below)
)

sudo apt-get install -y "${PACKAGES[@]}"
ok "System packages installed."

# ============================================================================
# 2. Neovim (>= 0.11 required)
# ============================================================================
info "Checking Neovim version..."

install_neovim() {
    info "Installing latest Neovim from GitHub releases..."
    local nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    local tmp_dir
    tmp_dir=$(mktemp -d)

    curl -fsSL "$nvim_url" -o "$tmp_dir/nvim.tar.gz"
    tar -xzf "$tmp_dir/nvim.tar.gz" -C "$tmp_dir"

    sudo rm -rf /opt/nvim
    sudo mv "$tmp_dir/nvim-linux-x86_64" /opt/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim

    rm -rf "$tmp_dir"
    ok "Neovim installed to /opt/nvim"
}

if command -v nvim &>/dev/null; then
    NVIM_VER=$(nvim --version | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+')
    NVIM_MAJOR=$(echo "$NVIM_VER" | cut -d. -f1)
    NVIM_MINOR=$(echo "$NVIM_VER" | cut -d. -f2)

    if [[ "$NVIM_MAJOR" -lt 1 && "$NVIM_MINOR" -lt 11 ]]; then
        warn "Neovim $NVIM_VER found but >= 0.11 is required."
        read -rp "Install latest Neovim? [Y/n] " answer
        [[ "$answer" =~ ^[Nn]$ ]] || install_neovim
    else
        ok "Neovim v${NVIM_VER} found (>= 0.11 required)."
    fi
else
    warn "Neovim not found."
    read -rp "Install latest Neovim? [Y/n] " answer
    [[ "$answer" =~ ^[Nn]$ ]] || install_neovim
fi

# ============================================================================
# 3. Node.js via nvm (needed for Claude Code CLI, prettier, pyright, etc.)
# ============================================================================
info "Setting up Node.js via nvm..."

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [[ ! -d "$NVM_DIR" ]]; then
    info "Installing nvm..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Source nvm
# shellcheck source=/dev/null
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"

if command -v nvm &>/dev/null; then
    nvm install 22
    nvm use 22
    ok "Node.js $(node --version) installed via nvm."
else
    warn "nvm not available in this shell. Install Node.js 22 manually:"
    warn "  nvm install 22"
fi

# ============================================================================
# 4. Python Tools (pip, pipx)
# ============================================================================
info "Installing Python tools..."

python3 -m pip install --user --upgrade pip 2>/dev/null || true

# Install pipx (required for Mason to install Python-based LSP servers like fortls)
if command -v pipx &>/dev/null; then
    ok "pipx already installed."
else
    info "Installing pipx..."
    sudo apt-get install -y pipx
    pipx ensurepath
    ok "pipx installed."
fi

# Install Python formatters
python3 -m pip install --user \
    black \
    isort \
    2>/dev/null || warn "pip install failed - install black and isort manually"

ok "Python formatters installed (black, isort)."

# ============================================================================
# 5. Node.js Tools (npm)
# ============================================================================
info "Installing Node.js tools..."

if command -v npm &>/dev/null; then
    npm install -g prettier
    ok "prettier installed."
else
    warn "npm not found. Install prettier manually: npm install -g prettier"
fi

# ============================================================================
# 6. Lua Formatter (stylua)
# ============================================================================
info "Installing StyLua..."

if command -v stylua &>/dev/null; then
    ok "stylua already installed."
else
    STYLUA_VERSION="v2.0.2"
    STYLUA_URL="https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_VERSION}/stylua-linux-x86_64.zip"
    TMP_DIR=$(mktemp -d)

    curl -fsSL "$STYLUA_URL" -o "$TMP_DIR/stylua.zip"
    unzip -q "$TMP_DIR/stylua.zip" -d "$TMP_DIR"
    chmod +x "$TMP_DIR/stylua"

    # Install to ~/.local/bin (user-local)
    mkdir -p "$HOME/.local/bin"
    mv "$TMP_DIR/stylua" "$HOME/.local/bin/stylua"
    rm -rf "$TMP_DIR"

    ok "stylua installed to ~/.local/bin/stylua"
fi

# ============================================================================
# 7. R Language Server
# ============================================================================
info "Installing R language server..."

if command -v R &>/dev/null; then
    R --quiet --no-save -e 'if (!requireNamespace("languageserver", quietly=TRUE)) install.packages("languageserver", repos="https://cloud.r-project.org")' \
        2>/dev/null || warn "R languageserver install failed - install manually in R: install.packages('languageserver')"
    ok "R languageserver package installed."
else
    warn "R not found. Skip R language server installation."
fi

# ============================================================================
# 8. DuckDB (optional - for parquet file preview)
# ============================================================================
info "Installing DuckDB (optional, for parquet preview)..."

if command -v duckdb &>/dev/null; then
    ok "duckdb already installed."
else
    read -rp "Install DuckDB? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        DUCKDB_URL="https://github.com/duckdb/duckdb/releases/latest/download/duckdb_cli-linux-amd64.zip"
        TMP_DIR=$(mktemp -d)
        curl -fsSL "$DUCKDB_URL" -o "$TMP_DIR/duckdb.zip"
        unzip -q "$TMP_DIR/duckdb.zip" -d "$TMP_DIR"
        chmod +x "$TMP_DIR/duckdb"
        mkdir -p "$HOME/.local/bin"
        mv "$TMP_DIR/duckdb" "$HOME/.local/bin/duckdb"
        rm -rf "$TMP_DIR"
        ok "duckdb installed to ~/.local/bin/duckdb"
    else
        info "Skipping DuckDB."
    fi
fi

# ============================================================================
# 9. Claude Code CLI (optional)
# ============================================================================
info "Checking Claude Code CLI..."

if command -v claude &>/dev/null || [[ -f "$HOME/.nvm/versions/node/v22.20.0/bin/claude" ]]; then
    ok "Claude Code CLI found."
else
    read -rp "Install Claude Code CLI? (requires npm) [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]] && command -v npm &>/dev/null; then
        npm install -g @anthropic-ai/claude-code
        ok "Claude Code CLI installed."
    else
        info "Skipping Claude Code CLI. Install later: npm install -g @anthropic-ai/claude-code"
    fi
fi

# ============================================================================
# 10. Deploy Neovim Configuration
# ============================================================================
info "Deploying Neovim configuration..."

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$NVIM_CONFIG_DIR" ]]; then
    if [[ "$(readlink -f "$NVIM_CONFIG_DIR" 2>/dev/null)" == "$SCRIPT_DIR" ]]; then
        ok "Config already symlinked to $NVIM_CONFIG_DIR"
    else
        warn "$NVIM_CONFIG_DIR already exists."
        read -rp "Back up existing config and replace? [Y/n] " answer
        if [[ ! "$answer" =~ ^[Nn]$ ]]; then
            BACKUP="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$NVIM_CONFIG_DIR" "$BACKUP"
            ok "Existing config backed up to $BACKUP"
            ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
            ok "Config symlinked: $NVIM_CONFIG_DIR -> $SCRIPT_DIR"
        fi
    fi
else
    mkdir -p "$(dirname "$NVIM_CONFIG_DIR")"
    ln -sf "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
    ok "Config symlinked: $NVIM_CONFIG_DIR -> $SCRIPT_DIR"
fi

# ============================================================================
# 11. Create Required Directories
# ============================================================================
info "Creating required directories..."

mkdir -p "$HOME/VIM_BACKUP_FILES"
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/nvim/undo"
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/nvim/backup"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/nvim/tags"

ok "Directories created."

# ============================================================================
# 12. Configure ctags for Modern Fortran
# ============================================================================
info "Configuring ctags for modern Fortran (module function/subroutine)..."

mkdir -p "$HOME/.ctags.d"
cat > "$HOME/.ctags.d/fortran.ctags" << 'CTAGS_EOF'
--regex-Fortran=/^[ \t]*module[ \t]+function[ \t]+([a-zA-Z_][a-zA-Z0-9_]*)/\1/f,function/
--regex-Fortran=/^[ \t]*module[ \t]+subroutine[ \t]+([a-zA-Z_][a-zA-Z0-9_]*)/\1/s,subroutine/
CTAGS_EOF

ok "ctags Fortran config written to ~/.ctags.d/fortran.ctags"

# ============================================================================
# 13. Ensure ~/.local/bin is in PATH
# ============================================================================
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    warn "~/.local/bin is not in PATH. Add this to your shell profile:"
    warn '  export PATH="$HOME/.local/bin:$PATH"'
    echo ""

    # Add to .bashrc if it exists and line isn't already there
    SHELL_RC="$HOME/.bashrc"
    [[ -n "${ZSH_VERSION:-}" ]] && SHELL_RC="$HOME/.zshrc"

    if ! grep -q 'HOME/.local/bin' "$SHELL_RC" 2>/dev/null; then
        read -rp "Add to $SHELL_RC now? [Y/n] " answer
        if [[ ! "$answer" =~ ^[Nn]$ ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
            ok "Added to $SHELL_RC. Run: source $SHELL_RC"
        fi
    fi
fi

# ============================================================================
# 14. First Launch - Install Plugins
# ============================================================================
echo ""
info "Bootstrap complete! On first launch, Neovim will:"
echo "  1. Clone lazy.nvim (plugin manager)"
echo "  2. Install all plugins automatically"
echo "  3. Install LSP servers via Mason (lua_ls, pyright, yamlls, r_language_server, fortls, texlab)"
echo "  4. Install Tree-sitter parsers"
echo ""
info "Run 'nvim' to start. First launch may take a minute."
echo ""

# --- Run headless plugin install (optional) ---
read -rp "Run headless plugin install now? [Y/n] " answer
if [[ ! "$answer" =~ ^[Nn]$ ]]; then
    info "Installing plugins (this may take a minute)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    ok "Plugins installed."

    info "Installing Tree-sitter parsers..."
    nvim --headless "+TSUpdateSync" +qa 2>/dev/null || true
    ok "Tree-sitter parsers installed."

    info "Installing Mason tools..."
    nvim --headless -c "MasonInstall lua-language-server pyright yaml-language-server r-languageserver fortls texlab" -c "sleep 30" -c "qa" 2>/dev/null || true
    ok "Mason tools installed."
fi

# ============================================================================
# Summary
# ============================================================================
echo ""
echo "============================================"
echo "  Installation Summary"
echo "============================================"
echo ""

check_cmd() {
    local name="$1" cmd="${2:-$1}"
    if command -v "$cmd" &>/dev/null; then
        echo -e "  ${GREEN}✓${NC} $name"
    else
        echo -e "  ${RED}✗${NC} $name (not found: $cmd)"
    fi
}

echo "System tools:"
check_cmd "git"
check_cmd "neovim" "nvim"
check_cmd "ripgrep" "rg"
check_cmd "ctags"
check_cmd "node"
check_cmd "npm"
check_cmd "python3"
check_cmd "pipx"
check_cmd "R"

echo ""
echo "Formatters & linters:"
check_cmd "stylua"
check_cmd "black"
check_cmd "isort"
check_cmd "prettier"

echo ""
echo "Optional tools:"
check_cmd "duckdb"
check_cmd "claude"

echo ""
ok "Done! Launch Neovim with: nvim"
echo ""