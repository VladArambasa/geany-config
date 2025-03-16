#!/bin/bash

# project root - define 
PROJECT_ROOT=$(dirname "$(realpath "$0")")
BUILD_DIR="$PROJECT_ROOT/build"
RELEASE_DIR="$PROJECT_ROOT/release"
OUTPUT_EXE="$RELEASE_DIR/program"

# check existence of directory -release
if [ ! -d "$RELEASE_DIR" ]; then
    mkdir "$RELEASE_DIR"
fi

# find all .o files in build
OBJ_FILES=$(find "$BUILD_DIR" -type f -name "*.o")

# check opengl and wxwidgets
USES_OPENGL=$(grep -rIl --include=\*.{c,cpp,h} '^[^/]*#include <GL/' "$PROJECT_ROOT")
USES_WXWIDGETS=$(grep -rIl --include=\*.{c,cpp,h} '^[^/]*#include <wx/' "$PROJECT_ROOT")

# compile flags
OPENGL_FLAGS=""
WXWIDGETS_FLAGS=""

if [ -n "$USES_OPENGL" ]; then
    OPENGL_FLAGS="-lGL -lGLU -lglut"
    echo "OpenGL detected, adding flags: $OPENGL_FLAGS"
fi

if [ -n "$USES_WXWIDGETS" ]; then
    WXWIDGETS_FLAGS=$(wx-config --cxxflags --libs)
    echo "WxWidgets detected, adding flags: $WXWIDGETS_FLAGS"
fi

# link .o files in .program
if [ -n "$OBJ_FILES" ]; then
    g++ $OBJ_FILES -o "$OUTPUT_EXE" $OPENGL_FLAGS $WXWIDGETS_FLAGS
    echo "Build completed. Executable created at $OUTPUT_EXE"
else
    echo "No object files found. Compile first."
fi

