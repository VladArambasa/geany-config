#!/bin/bash

# project root
PROJECT_ROOT=$(pwd)
BUILD_DIR="$PROJECT_ROOT/build"

# check/ensure build folder exists
if [ ! -d "$BUILD_DIR" ]; then
    mkdir "$BUILD_DIR"
else
    # purge old .o files --- fresh compile
    find "$BUILD_DIR" -type f -name "*.o" -delete
fi

# mirror only relevant folders/subfolders into the build directory
find "$PROJECT_ROOT" \( -name "*.h" -o -name "*.c" -o -name "*.cpp" \) -printf "%P\n" | awk -F'/' '{OFS="/"; NF--; print}' | sort -u | while read -r REL_PATH; do
    if [ -n "$REL_PATH" ]; then
        mkdir -p "$BUILD_DIR/$REL_PATH"
    fi
done

# check opengl and wxwidgets
USES_OPENGL=$(grep -rIl --include=\*.{c,cpp,h} '^[^/]*#include <GL/' "$PROJECT_ROOT")
USES_WXWIDGETS=$(grep -rIl --include=\*.{c,cpp,h} '^[^/]*#include <wx/' "$PROJECT_ROOT")

# flags -- compile/build/link whatever
OPENGL_FLAGS=""
WXWIDGETS_FLAGS=""

if [ -n "$USES_OPENGL" ]; then
    OPENGL_FLAGS="-I/usr/include/GL"
    echo "OpenGL detected, adding flags: $OPENGL_FLAGS"
fi

if [ -n "$USES_WXWIDGETS" ]; then
    WXWIDGETS_FLAGS=$(wx-config --cxxflags --libs)
    echo "WxWidgets detected, adding flags: $WXWIDGETS_FLAGS"
fi

# compile the implementations (.c and .cpp)
find "$PROJECT_ROOT" \( -name "*.c" -o -name "*.cpp" \) -printf "%P\n" | while read -r FILE; do
    REL_DIR="$(dirname "$FILE")"
    OBJ_FILE="$BUILD_DIR/$REL_DIR/$(basename "$FILE" | sed 's/\.[^.]*$/.o/')"
    
    # Ensure the object file directory exists
    mkdir -p "$(dirname "$OBJ_FILE")"

    if [[ "$FILE" == *.c ]]; then
        gcc -c "$PROJECT_ROOT/$FILE" -o "$OBJ_FILE" -I/usr/include/GL
    elif [[ "$FILE" == *.cpp ]]; then
        g++ -c "$PROJECT_ROOT/$FILE" -o "$OBJ_FILE" -I/usr/include/GL $WXWIDGETS_FLAGS
    fi

    echo "Compiled: $FILE -> $OBJ_FILE"
done


echo "Compilation completed. Object files are stored in the build directory."

