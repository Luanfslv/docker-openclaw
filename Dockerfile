FROM node:22-slim

LABEL maintainer="inematds"
LABEL description="OpenClaw - Personal AI Assistant with security hardening"

# System dependencies (git is required for npm install)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install OpenClaw
RUN npm install -g openclaw@latest

# Install Faster Whisper for audio transcription (optional, may fail on some architectures)
RUN pip3 install --break-system-packages --no-cache-dir \
    faster-whisper \
    torch --index-url https://download.pytorch.org/whl/cpu \
    || true

# Create non-root user
RUN useradd -m -s /bin/bash openclaw

# Create directories with proper permissions
RUN mkdir -p /home/openclaw/.openclaw /home/openclaw/workspace /home/openclaw/logs

# Copy files BEFORE switching to non-root user (need root for sed/chmod)
COPY config/openclaw.json.template /home/openclaw/.openclaw/openclaw.json.template
COPY entrypoint.sh /home/openclaw/entrypoint.sh

# Fix Windows CRLF line endings + set permissions
RUN sed -i 's/\r$//' /home/openclaw/entrypoint.sh \
    && chmod +x /home/openclaw/entrypoint.sh \
    && chown -R openclaw:openclaw /home/openclaw

# Switch to non-root user
USER openclaw
WORKDIR /home/openclaw/workspace

EXPOSE 18790

ENTRYPOINT ["/home/openclaw/entrypoint.sh"]
CMD ["openclaw", "gateway"]
