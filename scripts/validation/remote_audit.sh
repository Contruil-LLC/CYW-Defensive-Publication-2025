#!/usr/bin/env bash
set -euo pipefail

DOMAIN="https://timothywheels.com"
MANIFEST="docs/manifest.yml"
ENDPOINT="$DOMAIN/architecture.html"

echo "📡 Starting Remote Integrity Audit for $DOMAIN..."

# 1. Run the local chain first to ensure local state is perfect
echo "🔄 Step 1: Running local Rebuild & Validate..."
./scripts/validation/rebuild_chain.sh && ./scripts/validation/validate_chain.sh

if [ $? -ne 0 ]; then
    echo "❌ Local validation failed. Aborting remote audit."
    exit 1
fi

# 2. Ping the live endpoint
echo "🌐 Step 2: Pinging $ENDPOINT..."
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$ENDPOINT")

if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "❌ Remote endpoint unreachable (Status: $HTTP_STATUS). Check DNS/Vercel deployment."
    exit 1
fi

# 3. Verify specific hash from manifest against live content
# (Assuming your manifest lists the Origin Story hash as the primary anchor)
LOCAL_HASH=$(grep "Origin_Story" "$MANIFEST" -A 5 | grep "hash:" | awk '{print $2}' | tr -d '"')
echo "🔍 Step 3: Comparing Local Hash ($LOCAL_HASH) with Live Site..."

# Download the live page and check if the hash string exists in the HTML
if curl -s "$ENDPOINT" | grep -q "$LOCAL_HASH"; then
    echo "✅ MATCH: Live site integrity verified against local manifest."
    echo "⚖️  PROVENANCE INTACT."
else
    echo "⚠️  MISMATCH: Live site hash does not match local manifest. PUSH REQUIRED."
    exit 1
fi
