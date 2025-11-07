#!/bin/bash
INPUT=$1
OUTPUT=$2

echo "Upscaling..."
/waifu2x/waifu2x-ncnn-vulkan -i "$INPUT" -o /tmp/upscaled.png -s 3

echo "Setting DPI..."
magick /tmp/upscaled.png -units PixelsPerInch -density 300 "$OUTPUT"

echo "Done."
