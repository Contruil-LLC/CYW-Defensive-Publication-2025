#!/bin/bash
# compute_hash.sh
# Usage: ./compute_hash.sh <filepath>

FILEPATH="$1"

if [ ! -f "$FILEPATH" ]; then
  echo "Error: File not found: $FILEPATH"
  exit 1
fi

# Extract content after front-matter (everything after second '---')
CONTENT=$(awk '/^---$/{++n; next} n==2' "$FILEPATH")

# Compute SHA-256 hash
HASH=$(echo -n "$CONTENT" | shasum -a 256 | awk '{print $1}')

echo "$HASH"
