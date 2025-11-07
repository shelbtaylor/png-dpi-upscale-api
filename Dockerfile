FROM public.ecr.aws/ubuntu/ubuntu:22.04

# Install dependencies: ImageMagick + tools
RUN apt-get update && \
    apt-get install -y imagemagick curl wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Install waifu2x-ncnn-vulkan
RUN wget https://github.com/nihui/waifu2x-ncnn-vulkan/releases/download/20220728/waifu2x-ncnn-vulkan-20220728-ubuntu.zip && \
    unzip waifu2x-ncnn-vulkan-20220728-ubuntu.zip && \
    mv waifu2x-ncnn-vulkan-20220728-ubuntu /waifu && \
    rm waifu2x-ncnn-vulkan-20220728-ubuntu.zip

WORKDIR /app

# Copy your script into container
COPY process.sh /app/process.sh
RUN chmod +x /app/process.sh

CMD ["/app/process.sh"]
