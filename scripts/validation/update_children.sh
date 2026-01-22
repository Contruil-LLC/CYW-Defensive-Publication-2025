#!/bin/bash
# Auto-update child parent refs after hash change
FILE="$1"

if [ -z "$FILE" ]; then
  echo "Usage: $(basename "$0") <file-path>" >&2
  exit 1
fi

# If the provided path doesn't exist, try resolving from portfolio/
if [ ! -f "$FILE" ] && [ -f "portfolio/$FILE" ]; then
  FILE="portfolio/$FILE"
fi

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE" >&2
  exit 1
fi

NEW_HASH=$(sha256sum "$FILE" | cut -d' ' -f1)
NEW_TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update file front-matter
sed -i.bak "/hash_sha256:/c\hash_sha256: \"$NEW_HASH\"" "$FILE"
sed -i.bak "/timestamp:/c\timestamp: \"$NEW_TS\"" "$FILE"
sed -i.bak "/git_commit:/c\git_commit: \"$(git rev-parse HEAD)\"" "$FILE"

# Find and update children in both root and portfolio trees
for CHILD in $(grep -l "path:.*$(basename "$FILE")" docs/**/*.md architecture/**/*.md portfolio/docs/**/*.md portfolio/architecture/**/*.md 2>/dev/null); do
  sed -i.bak "/path:.*$(basename "$FILE").*hash:/s|hash: \"[^\"]*\"|hash: \"$NEW_HASH\"|" "$CHILD"
done

echo "✓ Updated $FILE and propagated to children"
rm -f *.bak
