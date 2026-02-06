#!/bin/bash
#
# Build script for NetHack Falcon's Eye Web (Emscripten) version
#
# Prerequisites:
#   1. Install Emscripten SDK:
#      git clone https://github.com/emscripten-core/emsdk.git
#      cd emsdk
#      ./emsdk install latest
#      ./emsdk activate latest
#      source ./emsdk_env.sh
#
#   2. Run this script from the sys/emscripten directory
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "NetHack Falcon's Eye Web Build"
echo "=============================="
echo ""

# Check for emcc
if ! command -v emcc &> /dev/null; then
    echo "ERROR: emcc not found!"
    echo ""
    echo "Please install the Emscripten SDK first:"
    echo "  git clone https://github.com/emscripten-core/emsdk.git"
    echo "  cd emsdk"
    echo "  ./emsdk install latest"
    echo "  ./emsdk activate latest"
    echo "  source ./emsdk_env.sh"
    exit 1
fi

echo "Using Emscripten: $(emcc --version | head -1)"
echo ""

# Create build directory
BUILD_DIR="$ROOT_DIR/build-web"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# First, build the native version to generate necessary files
echo "Step 1: Checking for generated source files..."
if [ ! -f "$ROOT_DIR/src/monstr.c" ] || [ ! -f "$ROOT_DIR/src/vis_tab.c" ]; then
    echo "  Generated source files not found."
    echo "  Please build the native version first using:"
    echo "    cd $ROOT_DIR/src && make"
    echo "  This creates necessary generated files (monstr.c, vis_tab.c, etc.)"
    echo ""
    echo "  Alternatively, you can run:"
    echo "    cd $ROOT_DIR/util && make makedefs"
    echo "    ./makedefs -v  # creates date.h"
    echo "    ./makedefs -m  # creates monstr.c"
    echo "    ./makedefs -t  # creates vis_tab.c and vis_tab.h"
    exit 1
fi

echo "  Found generated source files."
echo ""

# Check for game data
echo "Step 2: Checking for game data..."
GAMEDATA_DIR="$ROOT_DIR/win/jtp/gamedata"
if [ ! -d "$GAMEDATA_DIR" ]; then
    echo "  ERROR: Game data directory not found at $GAMEDATA_DIR"
    exit 1
fi
echo "  Found game data directory."
echo ""

# Build with Emscripten
echo "Step 3: Building with Emscripten..."
echo ""

# Copy the Makefile
cp "$SCRIPT_DIR/Makefile.em" "$BUILD_DIR/Makefile"

# Run make
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo ""
echo "Build complete!"
echo ""
echo "Output files in: $BUILD_DIR"
echo "  - nethack.html  (main HTML file)"
echo "  - nethack.js    (JavaScript glue code)"
echo "  - nethack.wasm  (WebAssembly binary)"
echo "  - nethack.data  (preloaded game data)"
echo ""
echo "To test, start a local web server:"
echo "  cd $BUILD_DIR"
echo "  python3 -m http.server 8080"
echo ""
echo "Then open: http://localhost:8080/nethack.html"
