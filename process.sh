#!/bin/bash
set -e

INPUT_FILE="$1"
OUTPUT_FILE="$2"

echo "Starting processing..."

# Temp paths
TMP_DIR="/tmp/process"
mkdir -p "$TMP_DIR"

ORIGINAL="$TMP_DIR/original.png"
UPSCALED="$TMP_DIR/upscaled.png"
FINAL="$TMP_DIR/final.png"

cp "$INPUT_FILE" "$ORIGINAL"

echo "Attempting upscale x3..."

# CPU upscale using ImageMagick
magick "$ORIGINAL" -filter Mitchell -resize 300% "$UPSCALED" || {
    echo "❌ x3 upscale failed — using original"
    cp "$ORIGINAL" "$UPSCALED"
}

# Resize longest edge DOWN to 3600px max
echo "Resizing to max 3600px..."
magick "$UPSCALED" -resize 3600x3600\> "$FINAL"

# Add DPI
echo "Setting DPI to 300..."
magick "$FINAL" -units PixelsPerInch -density 300 "$OUTPUT_FILE"

echo "✅ Done."
