FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y imagemagick curl unzip wget && \
    rm -rf /var/lib/apt/lists/*

# Install waifu2x-ncnn-vulkan
RUN wget https://github.com/nihui/waifu2x-ncnn-vulkan/releases/download/20220728/waifu2x-ncnn-vulkan-20220728-ubuntu.zip && \
    unzip waifu2x-ncnn-vulkan-20220728-ubuntu.zip && \
    mv waifu2x-ncnn-vulkan-20220728-ubuntu /waifu && \
    rm waifu2x-ncnn-vulkan-20220728-ubuntu.zip && \
    chmod +x /waifu/waifu2x-ncnn-vulkan

ENV PATH="/waifu:${PATH}"

WORKDIR /app

COPY process.sh /app/process.sh
COPY server.js /app/server.js

RUN chmod +x /app/process.sh

# Install Node
RUN apt-get update && apt-get install -y nodejs npm
COPY package.json /app/package.json
RUN npm install

CMD ["node", "server.js"]
