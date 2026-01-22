#!/bin/bash

# Remote Audit Script - Static Site Version
# Verifies deployed content matches local source via SHA-256 hashing

set -e

# Configuration
SITE_URL="https://timothywheels.com"
LOCAL_FILE="index.html"
REMOTE_TEMP="/tmp/remote_index.html"

echo "========================================="
echo "REMOTE AUDIT: Sovereign Deployment Pipeline"
echo "========================================="
echo ""

# Phase 1: Verify local file exists
echo "Phase 1: Verifying local source..."
if [ ! -f "$LOCAL_FILE" ]; then
    echo "❌ ERROR: Local file not found: $LOCAL_FILE"
    echo "   Run: Create index.html in repository root"
    exit 1
fi

LOCAL_HASH=$(shasum -a 256 "$LOCAL_FILE" | awk '{print $1}')
echo "✅ Local file found"
echo "   SHA-256: $LOCAL_HASH"
echo ""

# Phase 2: Fetch remote content
echo "Phase 2: Fetching remote deployment..."
if ! curl -sf --max-time 30 --max-redirs 5 "$SITE_URL/" -o "$REMOTE_TEMP"; then
    echo "❌ ERROR: Failed to fetch remote site"
    echo "   URL: $SITE_URL/"
    echo ""
    echo "Possible causes:"
    echo "  1. DNS not propagated (wait 5-10 minutes)"
    echo "  2. Vercel deployment not complete (check dashboard)"
    echo "  3. Network connectivity issue (check internet)"
    echo ""
    echo "Diagnostic commands:"
    echo "  dig timothywheels.com +short"
    echo "  curl -I $SITE_URL/"
    exit 1
fi

REMOTE_HASH=$(shasum -a 256 "$REMOTE_TEMP" | awk '{print $1}')
echo "✅ Remote content fetched"
echo "   SHA-256: $REMOTE_HASH"
echo ""

# Phase 3: Compare hashes
echo "Phase 3: Cryptographic verification..."
if [ "$LOCAL_HASH" == "$REMOTE_HASH" ]; then
    echo "✅ DEPLOYMENT INTEGRITY VERIFIED"
    echo ""
    echo "========================================="
    echo "🌐 Live Site: $SITE_URL/"
    echo "🔒 Cryptographic Match: Confirmed"
    echo "📊 Verification Method: SHA-256"
    echo "========================================="
    echo ""
    rm "$REMOTE_TEMP"
    exit 0
else
    echo "❌ INTEGRITY BREACH DETECTED"
    echo ""
    echo "========================================="
    echo "Hash Mismatch Details:"
    echo "----------------------------------------"
    echo "Local:  $LOCAL_HASH"
    echo "Remote: $REMOTE_HASH"
    echo "========================================="
    echo ""
    echo "This indicates deployed content differs from source."
    echo ""
    echo "Diagnostic steps:"
    echo "  1. Check if you committed latest changes: git status"
    echo "  2. Verify Vercel deployed from correct commit: Check dashboard"
    echo "  3. Check CDN propagation: Wait 60 seconds and retry"
    echo "  4. Force redeploy: make deploy"
    echo ""
    echo "Detailed comparison:"
    diff "$LOCAL_FILE" "$REMOTE_TEMP" || true
    echo ""
    rm "$REMOTE_TEMP"
    exit 1
fi
