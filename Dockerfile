FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    imagemagick \
    nodejs \
    npm \
    && apt-get clean

# Make app directory
WORKDIR /app

# Copy files
COPY package*.json ./
RUN npm install
COPY . .

# Make process.sh executable
RUN chmod +x /app/process.sh

# Expose port
EXPOSE 3000

# Start only the Node server
CMD ["node", "server.js"]
