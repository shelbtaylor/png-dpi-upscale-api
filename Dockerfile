FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y imagemagick curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY process.sh /app/process.sh
RUN chmod +x /app/process.sh

CMD ["/app/process.sh"]
