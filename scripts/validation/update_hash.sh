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

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
GIT_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "NO_GIT_REPO")

tmp_file="$(mktemp)"
awk -v hash="$NEW_HASH" -v ts="$TIMESTAMP" -v commit="$GIT_COMMIT" '
  $0 == "---" && !fm_started { fm_started=1; print; next }
  $0 == "---" && fm_started && !fm_done { fm_done=1; print; next }
  fm_started && !fm_done {
    if ($0 ~ /^hash_sha256:/) { print "hash_sha256: \"" hash "\""; next }
    if ($0 ~ /^last_updated:/) { print "last_updated: \"" ts "\""; next }
    if ($0 ~ /^git_commit:/) { print "git_commit: \"" commit "\""; next }
  }
  { print }
' "$FILEPATH" > "$tmp_file" && mv "$tmp_file" "$FILEPATH"

echo "✓ Updated hash for $FILEPATH"
echo "  Hash: $NEW_HASH"
echo "  Timestamp: $TIMESTAMP"
echo "  Git Commit: $GIT_COMMIT"

