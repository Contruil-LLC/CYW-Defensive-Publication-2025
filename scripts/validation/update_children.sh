#!/bin/bash
# Auto-update child parent refs after hash change
FILE="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

NEW_HASH=$("$SCRIPT_DIR/compute_hash.sh" "$FILE")
NEW_TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Update file front-matter using awk for portability
tmp_file="$(mktemp)"
awk -v hash="$NEW_HASH" -v ts="$NEW_TS" -v commit="$(git rev-parse HEAD 2>/dev/null || echo NO_GIT_REPO)" '
  $0 == "---" && !fm_started { fm_started=1; print; next }
  $0 == "---" && fm_started && !fm_done { fm_done=1; print; next }
  fm_started && !fm_done {
    if ($0 ~ /^hash_sha256:/) { print "hash_sha256: \"" hash "\""; next }
    if ($0 ~ /^last_updated:/) { print "last_updated: \"" ts "\""; next }
    if ($0 ~ /^git_commit:/) { print "git_commit: \"" commit "\""; next }
  }
  { print }
' "$FILE" > "$tmp_file" && mv "$tmp_file" "$FILE"

# Find and update children in both root and portfolio trees
find . -name "*.md" -type f -print0 2>/dev/null | while IFS= read -r -d '' CHILD; do
  if grep -q "path:.*$(basename "$FILE")" "$CHILD"; then
    tmp_file="$(mktemp)"
    awk -v target="$(basename "$FILE")" -v hash="$NEW_HASH" '
      $0 ~ "path: .*" target {
        print
        if (getline) {
          sub(/hash: ".*"/, "hash: \"" hash "\"")
          print
          next
        }
      }
      { print }
    ' "$CHILD" > "$tmp_file" && mv "$tmp_file" "$CHILD"
  fi
done

echo "✓ Updated $FILE and propagated to children"
