#!/bin/bash
# validate_chain.sh
# Usage: ./validate_chain.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTFOLIO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🔍 Validating hash chains in portfolio..."
echo ""

ERRORS=0
CHILD_PARENT_MAP="$(mktemp)"

# Find all .md files with ValidationPacket headers
while read -r FILE; do
  
  # Extract parent_artifacts from front-matter (portable awk)
  PARENTS=$(awk '
    /^parent_artifacts:/ {in_parents=1; next}
    /^child_artifacts:/ {in_parents=0}
    in_parents && /path: "/ {
      split($0, parts, "\"")
      if (parts[2] != "") print parts[2]
    }
  ' "$FILE")
  
  for PARENT_PATH in $PARENTS; do
    FULL_PARENT_PATH="$PORTFOLIO_DIR/$PARENT_PATH"
    
    # Check if parent file exists
    if [ ! -f "$FULL_PARENT_PATH" ]; then
      echo "❌ ERROR: Parent artifact not found"
      echo "   Child: $FILE"
      echo "   Missing Parent: $PARENT_PATH"
      echo ""
      ((ERRORS++))
      continue
    fi
    
    # Extract expected parent hash from child's front-matter
    EXPECTED_HASH=$(awk -v path="$PARENT_PATH" '
      $0 ~ "path: \"" path "\"" {capture=1; next}
      capture && /hash: "/ {
        split($0, parts, "\"")
        print parts[2]
        exit
      }
    ' "$FILE")

    # Detect conflicting parent hashes for the same child
    collision_key="$FILE|$PARENT_PATH"
    existing_hash=$(grep -F "$collision_key|" "$CHILD_PARENT_MAP" | awk -F'|' '{print $3}')
    if [ -n "$existing_hash" ] && [ "$existing_hash" != "$EXPECTED_HASH" ]; then
      echo "❌ COLLISION: $FILE parent $PARENT_PATH has conflicting hash"
      ((ERRORS++))
    fi
    if [ -z "$existing_hash" ]; then
      echo "$collision_key|$EXPECTED_HASH" >> "$CHILD_PARENT_MAP"
    fi
    
    # Compute actual parent hash
    ACTUAL_HASH=$("$SCRIPT_DIR/compute_hash.sh" "$FULL_PARENT_PATH")
    
    # Compare hashes
    if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
      echo "❌ HASH MISMATCH"
      echo "   Child: $FILE"
      echo "   Parent: $PARENT_PATH"
      echo "   Expected: $EXPECTED_HASH"
      echo "   Actual: $ACTUAL_HASH"
      echo ""
      ((ERRORS++))
    else
      echo "✓ Valid: $FILE → $PARENT_PATH"
    fi
  done
done < <(find "$PORTFOLIO_DIR" -name "*.md" -type f)

rm -f "$CHILD_PARENT_MAP"

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✅ All hash chains valid. Provenance intact."
  exit 0
else
  echo "⚠️  Found $ERRORS validation errors. Provenance chain broken."
  exit 1
fi
