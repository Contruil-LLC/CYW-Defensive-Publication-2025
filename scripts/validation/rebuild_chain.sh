#!/bin/bash
# Topo-order: origin, timeline, claims
FILES=(
  "docs/origin/Origin_Story_Amazon_Experiments_2023.md"
  "docs/timeline/Development_Timeline_and_Milestones.md"
  "architecture/claims/System_Claims_and_Architecture_Spec.md"
)

for file in "${FILES[@]}"; do
  ./scripts/validation/update_hash.sh "$file"
  ./scripts/validation/update_children.sh "$file"
done

./scripts/validation/validate_chain.sh
echo "✅ Chain rebuilt and validated"
