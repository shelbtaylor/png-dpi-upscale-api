#!/bin/bash
set -e

INPUT_FILE="/app/input.png"
OUTPUT_FILE="/app/output.png"

# 1) Upscale x3
echo "Upscaling x3..."
waifu2x-ncnn-vulkan -i "$INPUT_FILE" -o "$OUTPUT_FILE" -s 3

# 2) Force DPI to 300
echo "Updating DPI…"
convert "$OUTPUT_FILE" -units PixelsPerInch -density 300 "$OUTPUT_FILE"

# 3) Resize if >3600px
echo "Checking size…"
convert "$OUTPUT_FILE" -resize 3600x3600\> "$OUTPUT_FILE"

echo "✅ Done"
