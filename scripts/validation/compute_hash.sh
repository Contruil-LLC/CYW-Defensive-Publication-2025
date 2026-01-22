#!/bin/bash
# compute_hash.sh
# Usage: ./compute_hash.sh <filepath>

FILEPATH="$1"

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

# Extract content after front-matter (everything after second '---')
CONTENT=$(awk '/^---$/{++n; next} n==2' "$FILEPATH")

# Compute SHA-256 hash
HASH=$(echo -n "$CONTENT" | shasum -a 256 | awk '{print $1}')

echo "$HASH"
