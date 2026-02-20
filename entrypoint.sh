#!/bin/bash
set -e

# Config directory: OpenClaw uses ~/.openclaw
CONFIG_DIR="$HOME/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
TEMPLATE_FILE="$CONFIG_DIR/openclaw.json.template"

# Create config directory if needed
mkdir -p "$CONFIG_DIR"

# Create config from template if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
  echo "🦞 First run — creating config from template..."
  if [ -f "$TEMPLATE_FILE" ]; then
    cp "$TEMPLATE_FILE" "$CONFIG_FILE"
  else
    echo "{\"gateway\":{\"port\":${GATEWAY_PORT:-18790}},\"channels\":{}}" > "$CONFIG_FILE"
  fi
fi

# Helper: inject JSON value using Node.js
inject_json() {
  local file="$1" script="$2"
  node -e "
    const fs = require('fs');
    const cfg = JSON.parse(fs.readFileSync('$file', 'utf8'));
    $script
    fs.writeFileSync('$file', JSON.stringify(cfg, null, 2));
  "
}

# Inject GATEWAY_AUTH_TOKEN
if [ -n "$GATEWAY_AUTH_TOKEN" ]; then
  echo "🔑 Setting gateway auth token..."
  inject_json "$CONFIG_FILE" "
    cfg.gateway = cfg.gateway || {};
    cfg.gateway.auth = cfg.gateway.auth || {};
    cfg.gateway.auth.token = process.env.GATEWAY_AUTH_TOKEN;
  "
fi

# Inject Telegram bot token
if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
  echo "📱 Enabling Telegram..."
  inject_json "$CONFIG_FILE" "
    cfg.channels = cfg.channels || {};
    cfg.channels.telegram = cfg.channels.telegram || {};
    cfg.channels.telegram.enabled = true;
    cfg.channels.telegram.botToken = process.env.TELEGRAM_BOT_TOKEN;
    cfg.channels.telegram.dmPolicy = cfg.channels.telegram.dmPolicy || 'pairing';
    cfg.channels.telegram.groupPolicy = cfg.channels.telegram.groupPolicy || 'allowlist';
  "
fi

# Inject Discord bot token
if [ -n "$DISCORD_BOT_TOKEN" ]; then
  echo "💜 Enabling Discord..."
  inject_json "$CONFIG_FILE" "
    cfg.channels = cfg.channels || {};
    cfg.channels.discord = cfg.channels.discord || {};
    cfg.channels.discord.enabled = true;
    cfg.channels.discord.token = process.env.DISCORD_BOT_TOKEN;
    cfg.channels.discord.dmPolicy = cfg.channels.discord.dmPolicy || 'pairing';
  "
fi

# Inject Slack tokens
if [ -n "$SLACK_BOT_TOKEN" ] && [ -n "$SLACK_APP_TOKEN" ]; then
  echo "💼 Enabling Slack..."
  inject_json "$CONFIG_FILE" "
    cfg.channels = cfg.channels || {};
    cfg.channels.slack = cfg.channels.slack || {};
    cfg.channels.slack.enabled = true;
    cfg.channels.slack.botToken = process.env.SLACK_BOT_TOKEN;
    cfg.channels.slack.appToken = process.env.SLACK_APP_TOKEN;
    cfg.channels.slack.dmPolicy = cfg.channels.slack.dmPolicy || 'pairing';
  "
fi

# Configure LLM provider (supports both Anthropic direct and OpenRouter keys)
if [ -n "$OPENROUTER_API_KEY" ] && [ "$OPENROUTER_API_KEY" != "sk-or-your-key-here" ]; then

  # Create agent directory structure and auth profiles file
  AGENT_DIR="$CONFIG_DIR/agents/main/agent"
  AUTH_PROFILES_FILE="$AGENT_DIR/auth-profiles.json"
  mkdir -p "$AGENT_DIR"

  # Detect key type: Anthropic direct (sk-ant-) vs OpenRouter (sk-or-)
  if echo "$OPENROUTER_API_KEY" | grep -q "^sk-ant-"; then
    # --- Direct Anthropic API key ---
    echo "🧠 Anthropic API key detected — using direct Anthropic API"

    DEFAULT_MODEL="${DEFAULT_MODEL:-anthropic/claude-sonnet-4-20250514}"
    export DEFAULT_MODEL

    cat > "$AUTH_PROFILES_FILE" <<EOF
{
  "anthropic:default": {
    "provider": "anthropic",
    "token": "$OPENROUTER_API_KEY"
  }
}
EOF
    chmod 600 "$AUTH_PROFILES_FILE"

    export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"
    # Do NOT set ANTHROPIC_BASE_URL — use the default Anthropic endpoint
    unset ANTHROPIC_BASE_URL

    echo "   Model: $DEFAULT_MODEL"
    echo "   ✓ Auth profile created (Anthropic direct)"
  else
    # --- OpenRouter API key ---
    echo "🧠 OpenRouter configured — multi-model gateway active"

    DEFAULT_MODEL="${DEFAULT_MODEL:-openrouter/anthropic/claude-sonnet-4.5}"
    export DEFAULT_MODEL

    cat > "$AUTH_PROFILES_FILE" <<EOF
{
  "openrouter:default": {
    "provider": "openrouter",
    "token": "$OPENROUTER_API_KEY"
  },
  "anthropic:default": {
    "provider": "anthropic",
    "token": "$OPENROUTER_API_KEY"
  }
}
EOF
    chmod 600 "$AUTH_PROFILES_FILE"

    export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"
    export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"

    echo "   Model: $DEFAULT_MODEL"
    echo "   ✓ Auth profile created (OpenRouter)"
    echo "   ✓ OpenRouter base URL configured"
  fi

  # Set default model in config
  inject_json "$CONFIG_FILE" "
    cfg.agents = cfg.agents || {};
    cfg.agents.defaults = cfg.agents.defaults || {};
    cfg.agents.defaults.model = { primary: process.env.DEFAULT_MODEL };
  "
else
  echo "⚠️  OPENROUTER_API_KEY not set! Please configure it in .env"
  echo "   Get your key at: https://openrouter.ai/"
fi

# Docker requires binding to 0.0.0.0 inside the container for port mapping to work.
# The docker-compose.yml restricts external access to 127.0.0.1 on the host.
GATEWAY_PORT="${GATEWAY_PORT:-18790}"
export GATEWAY_PORT
echo "🌐 Setting gateway bind to lan and port to $GATEWAY_PORT..."
inject_json "$CONFIG_FILE" "
  cfg.gateway = cfg.gateway || {};
  cfg.gateway.bind = 'lan';
  cfg.gateway.port = parseInt(process.env.GATEWAY_PORT || '18790');
"

# Configure logging
echo "📝 Configuring logging..."
inject_json "$CONFIG_FILE" "
  cfg.logging = cfg.logging || {};
  cfg.logging.level = cfg.logging.level || 'info';
"

# Set proper permissions on config (secrets inside)
chmod 600 "$CONFIG_FILE" 2>/dev/null || true

echo "🦞 Starting OpenClaw..."
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  🌐 Webchat: http://localhost:${GATEWAY_PORT}/chat                ║"
echo "║  🔑 Token: use your GATEWAY_AUTH_TOKEN from .env        ║"
echo "║  🧠 Model: ${DEFAULT_MODEL:-openrouter/anthropic/claude-sonnet-4.5} ║"
echo "║  📋 Status: docker exec openclaw-acelera openclaw doctor ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
exec "$@"
