FROM node:18-bullseye

# Install required tools
RUN apt-get update && apt-get install -y \
    imagemagick \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install waifu2x-ncnn-vulkan (CPU build packaged by upstream)
RUN wget https://github.com/nihui/waifu2x-ncnn-vulkan/releases/download/20220728/waifu2x-ncnn-vulkan-20220728-ubuntu.zip \
    && unzip waifu2x-ncnn-vulkan-20220728-ubuntu.zip \
    && mv waifu2x-ncnn-vulkan-20220728-ubuntu /waifu2x \
    && chmod +x /waifu2x/waifu2x-ncnn-vulkan

# App files
WORKDIR /app
COPY process.sh /app/process.sh
COPY server.js /app/server.js
RUN chmod +x /app/process.sh

# Start the Node server
CMD ["node", "/app/server.js"]
