FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_ENV=production

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (v18 LTS recommended)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Clone Pokemon Showdown repository
RUN git clone https://github.com/smogon/pokemon-showdown.git . && \
    npm install

# Expose port (default Showdown ports)
EXPOSE 8000

# Create a non-root user for security
RUN useradd -m -u 1000 showdown && \
    chown -R showdown:showdown /app

USER showdown

# Start the server
CMD ["node", "pokemon-showdown", "start"]
