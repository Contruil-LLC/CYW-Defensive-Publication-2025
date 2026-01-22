#!/bin/bash
# Topo-order: origin, timeline, claims
FILES=(
  "docs/origin/Origin_Story_Amazon_Experiments_2023.md"
  "docs/timeline/Development_Timeline_and_Milestones.md"
  "architecture/claims/System_Claims_and_Architecture_Spec.md"
)
PROVENANCE="docs/CYW_Virgil_Provenance_Chain_Integration.md"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resolve_path() {
  local path="$1"
  if [ -f "$path" ]; then
    echo "$path"
  elif [ -f "portfolio/$path" ]; then
    echo "portfolio/$path"
  else
    echo ""
  fi
}

for file in "${FILES[@]}"; do
  resolved=$(resolve_path "$file")
  if [ -z "$resolved" ]; then
    echo "Error: file not found for chain rebuild: $file" >&2
    exit 1
  fi
  "$SCRIPT_DIR/update_hash.sh" "$resolved"
  "$SCRIPT_DIR/update_children.sh" "$resolved"
done

# Provenance Integration (leaf node)
resolved_provenance=$(resolve_path "$PROVENANCE")
if [ -z "$resolved_provenance" ]; then
  echo "Error: file not found for chain rebuild: $PROVENANCE" >&2
  exit 1
fi
"$SCRIPT_DIR/update_hash.sh" "$resolved_provenance"
"$SCRIPT_DIR/update_children.sh" "$resolved_provenance"

"$SCRIPT_DIR/validate_chain.sh"
echo "✅ Chain rebuilt and validated"
