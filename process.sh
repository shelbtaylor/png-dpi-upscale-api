#!/bin/bash
set -e

INPUT="$1"
OUTPUT="$2"

echo "Starting processing…"
echo "Input: $INPUT"
echo "Output: $OUTPUT"

# Temp files
UPSCALED="temp_upscaled.png"

##############################################
# Try UPSCALE X3 only
##############################################
echo "Attempting upscale x3…"
if /waifu/waifu2x-ncnn-vulkan -i "$INPUT" -o "$UPSCALED" -s 3 -n 0; then
    echo "✅ x3 upscale succeeded"
else
    echo "❌ x3 failed — using original file"
    cp "$INPUT" "$UPSCALED"
fi

##############################################
# Force PNG + DPI 300
##############################################
echo "Setting DPI to 300 + PNG…"
convert "$UPSCALED" -units PixelsPerInch -density 300 "$OUTPUT"

##############################################
# Cleanup
##############################################
rm -f "$UPSCALED"

echo "✅ Done!"
exit 0
