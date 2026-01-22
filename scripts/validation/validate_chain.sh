#!/bin/bash
# validate_chain.sh
# Usage: ./validate_chain.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTFOLIO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "🔍 Validating hash chains in portfolio..."
echo ""

ERRORS=0
declare -A child_parents

# Find all .md files with ValidationPacket headers
find "$PORTFOLIO_DIR" -name "*.md" -type f | while read -r FILE; do
  
  # Extract parent_artifacts from front-matter
  PARENTS=$(awk '/^parent_artifacts:/,/^child_artifacts:/' "$FILE" | grep -oP 'path: "\K[^"]+')
  
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
    EXPECTED_HASH=$(awk "/path: \"$PARENT_PATH\"/,/hash:/" "$FILE" | grep -oP 'hash: "\K[^"]+' | head -1)
    
    # Detect conflicting parent hashes for the same child
    if [[ -n "${child_parents[$FILE]// }" && "${child_parents[$FILE]}" != "$EXPECTED_HASH" ]]; then
      echo "❌ COLLISION: $FILE has conflicting parents"
    fi
    child_parents[$FILE]="$EXPECTED_HASH"
    
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
done

echo ""
if [ $ERRORS -eq 0 ]; then
  echo "✅ All hash chains valid. Provenance intact."
  exit 0
else
  echo "⚠️  Found $ERRORS validation errors. Provenance chain broken."
  exit 1
fi
