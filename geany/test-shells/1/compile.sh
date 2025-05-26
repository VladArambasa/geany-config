#!/bin/bash

# Set up paths
PROJECT_ROOT="$(dirname "$(realpath "$0")")"
BUILD_DIR="$PROJECT_ROOT/build"

echo "→ Project root: $PROJECT_ROOT"
echo "→ Build folder: $BUILD_DIR"

# Step 1: Create build folder if not exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "→ Creating build folder..."
    mkdir -p "$BUILD_DIR"
fi

# Step 2: Clean .o files
echo "→ Cleaning old object files..."
find "$BUILD_DIR" -type f -name "*.o" -exec rm -f {} +

# Step 3: Mirror source directory structure (only folders with source files)
echo "→ Mirroring project structure..."
find "$PROJECT_ROOT" -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" \) | while read -r FILE; do
    REL_DIR="$(dirname "${FILE#$PROJECT_ROOT/}")"
    TARGET_DIR="$BUILD_DIR/$REL_DIR"
    mkdir -p "$TARGET_DIR"
done

# Step 4: Compile each source file to its mirrored .o
echo "→ Compiling sources..."
find "$PROJECT_ROOT" -type f \( -name "*.c" -o -name "*.cpp" \) | while read -r SRC; do
    REL_PATH="${SRC#$PROJECT_ROOT/}"
    OBJ_PATH="$BUILD_DIR/${REL_PATH%.*}.o"
    OBJ_DIR="$(dirname "$OBJ_PATH")"
    mkdir -p "$OBJ_DIR"

    if [[ "$SRC" == *.c ]]; then
        echo "[C]   Compiling $REL_PATH"
        gcc -c "$SRC" -o "$OBJ_PATH"
    elif [[ "$SRC" == *.cpp ]]; then
        echo "[C++] Compiling $REL_PATH"
        g++ -c "$SRC" -o "$OBJ_PATH"
    fi
done

