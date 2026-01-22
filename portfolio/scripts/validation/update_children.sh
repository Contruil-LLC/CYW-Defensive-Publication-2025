#!/bin/bash
# Auto-update child parent refs after hash change
FILE="$1"
NEW_HASH=$(sha256sum "$FILE" | cut -d' ' -f1)
NEW_TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update file front-matter
sed -i.bak "/hash_sha256:/c\hash_sha256: \"$NEW_HASH\"" "$FILE"
sed -i.bak "/timestamp:/c\timestamp: \"$NEW_TS\"" "$FILE"
sed -i.bak "/git_commit:/c\git_commit: \"$(git rev-parse HEAD)\"" "$FILE"

# Find and update children
grep -l "path:.*$(basename "$FILE")" docs/**/*.md architecture/**/*.md | while read child; do
  sed -i.bak "/path:.*$(basename "$FILE").*hash:/s|hash: \"[^\"]*\"|hash: \"$NEW_HASH\"|" "$child"
done

echo "✓ Updated $FILE and propagated to children"
rm *.bak
