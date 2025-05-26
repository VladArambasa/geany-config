#!/bin/bash

# Define paths
PROJECT_ROOT="$(dirname "$(realpath "$0")")"
BUILD_DIR="$PROJECT_ROOT/build"
RELEASE_DIR="$PROJECT_ROOT/release"
OUTPUT_EXE="$RELEASE_DIR/program"

echo "→ Creating release folder if missing..."
mkdir -p "$RELEASE_DIR"

# Gather object files
OBJ_FILES=$(find "$BUILD_DIR" -type f -name "*.o")
[ -z "$OBJ_FILES" ] && echo "❌ No object files found. Run compile.sh first." && exit 1

# Detect dependencies
USES_OPENGL=$(grep -rIl --include=\*.{c,cpp,h} '#include <GL/' "$PROJECT_ROOT")
USES_WX=$(grep -rIl --include=\*.{c,cpp,h} '#include <wx/' "$PROJECT_ROOT")

OPENGL_FLAGS=""
WXWIDGETS_FLAGS=""

[ -n "$USES_OPENGL" ] && OPENGL_FLAGS="-lGL -lGLU -lglut" && echo "→ OpenGL detected."
[ -n "$USES_WX" ] && WXWIDGETS_FLAGS="$(wx-config --cxxflags --libs)" && echo "→ WxWidgets detected."

# Choose compiler
USES_CPP=$(find "$PROJECT_ROOT" -type f -name "*.cpp")
COMPILER="gcc"
[ -n "$USES_CPP" ] && COMPILER="g++"

# Link
echo "→ Linking with $COMPILER..."
$COMPILER $OBJ_FILES -o "$OUTPUT_EXE" $OPENGL_FLAGS $WXWIDGETS_FLAGS

echo "✅ Build complete → $OUTPUT_EXE"

