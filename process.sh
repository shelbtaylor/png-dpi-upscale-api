#!/bin/bash
set -e

INPUT_FILE="$1"         
OUTPUT_FILE="$2"        

echo "Upscaling x3…"
if /waifu2x/waifu2x-ncnn-vulkan -i "$INPUT_FILE" -o "$OUTPUT_FILE" -n 0 -s 3; then
    echo "Upscale succeeded (x3)"
else
    echo "Upscale x3 failed → trying x2"
    if /waifu2x/waifu2x-ncnn-vulkan -i "$INPUT_FILE" -o "$OUTPUT_FILE" -n 0 -s 2; then
        echo "Upscale succeeded (x2)"
    else
        echo "Upscale failed → copying original"
        cp "$INPUT_FILE" "$OUTPUT_FILE"
    fi
fi

echo "Forcing 300 DPI"
magick "$OUTPUT_FILE" -units PixelsPerInch -density 300 "$OUTPUT_FILE"

echo "Done"
