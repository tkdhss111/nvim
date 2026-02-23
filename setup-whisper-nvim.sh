#!/usr/bin/env bash
# =============================================================================
# whisper.nvim All-in-One Setup Script
# Builds whisper.cpp (whisper-stream) and installs the Neovim plugin config
# Targets: Ubuntu / Debian-based Linux
# =============================================================================
set -euo pipefail

INSTALL_DIR="$HOME/.local/share/whisper.cpp"
BIN_DIR="$HOME/.local/bin"
MODEL_DIR="$HOME/.local/share/nvim/whisper/models"
MODEL_NAME="ggml-base.en.bin"
MODEL_URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/${MODEL_NAME}"
NVIM_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/plugins"
PLUGIN_FILE="$NVIM_PLUGIN_DIR/whisper.lua"

echo "========================================="
echo " whisper.nvim All-in-One Setup"
echo "========================================="
echo

# -----------------------------------------------------------
# 1. Check / install dependencies
# -----------------------------------------------------------
echo "[1/6] Checking dependencies..."

missing_pkgs=()

for cmd in git cmake make; do
    if ! command -v "$cmd" &>/dev/null; then
        missing_pkgs+=("$cmd")
    fi
done

# Check for C++ compiler
if ! command -v g++ &>/dev/null && ! command -v c++ &>/dev/null; then
    missing_pkgs+=("g++")
fi

# Check for SDL2 dev headers (needed for whisper-stream)
if ! pkg-config --exists sdl2 2>/dev/null; then
    missing_pkgs+=("libsdl2-dev")
fi

# wget for model download
if ! command -v wget &>/dev/null; then
    missing_pkgs+=("wget")
fi

if [ ${#missing_pkgs[@]} -gt 0 ]; then
    echo "  Missing: ${missing_pkgs[*]}"
    echo "  Installing..."
    sudo apt-get update -qq
    sudo apt-get install -y "${missing_pkgs[@]}"
fi

echo "  All dependencies OK."
echo

# -----------------------------------------------------------
# 2. Clone / update whisper.cpp
# -----------------------------------------------------------
echo "[2/6] Setting up whisper.cpp..."

if [ -d "$INSTALL_DIR" ]; then
    echo "  whisper.cpp already cloned. Pulling latest..."
    git -C "$INSTALL_DIR" pull --quiet
else
    git clone https://github.com/ggerganov/whisper.cpp.git "$INSTALL_DIR"
fi

echo "  Done."
echo

# -----------------------------------------------------------
# 3. Build whisper-stream
# -----------------------------------------------------------
echo "[3/6] Building whisper-stream (this may take a few minutes)..."

cmake -S "$INSTALL_DIR" -B "$INSTALL_DIR/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DWHISPER_SDL2=ON

cmake --build "$INSTALL_DIR/build" -j"$(nproc)" --config Release

echo "  Build complete."
echo

# -----------------------------------------------------------
# 4. Install binary
# -----------------------------------------------------------
echo "[4/6] Installing whisper-stream to $BIN_DIR..."

mkdir -p "$BIN_DIR"

if [ -f "$INSTALL_DIR/build/bin/whisper-stream" ]; then
    cp "$INSTALL_DIR/build/bin/whisper-stream" "$BIN_DIR/whisper-stream"
elif [ -f "$INSTALL_DIR/build/whisper-stream" ]; then
    cp "$INSTALL_DIR/build/whisper-stream" "$BIN_DIR/whisper-stream"
else
    echo "  ERROR: whisper-stream binary not found in build output."
    echo "  Searching build directory..."
    find "$INSTALL_DIR/build" -name "whisper-stream" -type f 2>/dev/null
    exit 1
fi

chmod +x "$BIN_DIR/whisper-stream"
echo "  Installed: $BIN_DIR/whisper-stream"
echo

# -----------------------------------------------------------
# 5. Download model
# -----------------------------------------------------------
echo "[5/6] Downloading model ($MODEL_NAME)..."

mkdir -p "$MODEL_DIR"

if [ -f "$MODEL_DIR/$MODEL_NAME" ]; then
    echo "  Model already exists. Skipping."
else
    echo "  Downloading (~148 MB)..."
    wget -q --show-progress -O "$MODEL_DIR/$MODEL_NAME" "$MODEL_URL"
fi

echo "  Model ready: $MODEL_DIR/$MODEL_NAME"
echo

# -----------------------------------------------------------
# 6. Install Neovim plugin config
# -----------------------------------------------------------
echo "[6/6] Installing Neovim plugin config..."

mkdir -p "$NVIM_PLUGIN_DIR"

if [ -f "$PLUGIN_FILE" ]; then
    echo "  $PLUGIN_FILE already exists. Backing up to whisper.lua.bak"
    cp "$PLUGIN_FILE" "$PLUGIN_FILE.bak"
fi

cat > "$PLUGIN_FILE" << 'LUAEOF'
return {
  "Avi-D-coder/whisper.nvim",
  lazy = false,
  config = function()
    require("whisper").setup({
      model = "base.en",
      keybind = "<F9>",
      binary_path = vim.fn.expand("~/.local/bin/whisper-stream"),
      step_ms = 5000,
      length_ms = 8000,
      enable_streaming = false,
    })
  end,
}
LUAEOF

echo "  Wrote $PLUGIN_FILE"
echo

# -----------------------------------------------------------
# Verify PATH
# -----------------------------------------------------------
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "NOTE: $BIN_DIR is not in your PATH."
    echo "  Add it with: export PATH=\"$BIN_DIR:\$PATH\""
    echo "  Or add that line to your ~/.bashrc"
    echo
fi

# -----------------------------------------------------------
# Done
# -----------------------------------------------------------
echo "========================================="
echo " Setup complete!"
echo "========================================="
echo
echo " whisper-stream: $BIN_DIR/whisper-stream"
echo " Model:          $MODEL_DIR/$MODEL_NAME"
echo " Plugin config:  $PLUGIN_FILE"
echo
echo " Next steps:"
echo "   1. Open Neovim and run :Lazy sync to install the plugin"
echo "   2. Press <F9> in insert mode to dictate"
echo
echo " To test whisper-stream manually:"
echo "   whisper-stream -m $MODEL_DIR/$MODEL_NAME -t 4 --step 5000 --length 8000"
echo "========================================="