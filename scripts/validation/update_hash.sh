#!/bin/bash
# update_hash.sh
# Usage: ./update_hash.sh <filepath>

FILEPATH="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$FILEPATH" ]; then
  echo "Usage: $(basename "$0") <filepath>" >&2
  exit 1
fi

if [ ! -f "$FILEPATH" ] && [ -f "portfolio/$FILEPATH" ]; then
  FILEPATH="portfolio/$FILEPATH"
fi

if [ ! -f "$FILEPATH" ]; then
  echo "Error: File not found: $FILEPATH" >&2
  exit 1
fi

# Compute new hash
NEW_HASH=$("$SCRIPT_DIR/compute_hash.sh" "$FILEPATH")

# Update hash field in front-matter using sed
sed -i.bak "s/hash_sha256: .*/hash_sha256: \"$NEW_HASH\"/" "$FILEPATH"

# Update last_updated timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
sed -i.bak "s/last_updated: .*/last_updated: \"$TIMESTAMP\"/" "$FILEPATH"

# Capture git commit hash
GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "NO_GIT_REPO")
sed -i.bak "s/git_commit: .*/git_commit: \"$GIT_COMMIT\"/" "$FILEPATH"

echo "✓ Updated hash for $FILEPATH"
echo "  Hash: $NEW_HASH"
echo "  Timestamp: $TIMESTAMP"
echo "  Git Commit: $GIT_COMMIT"

# Clean up backup file
rm -f "$FILEPATH.bak"
