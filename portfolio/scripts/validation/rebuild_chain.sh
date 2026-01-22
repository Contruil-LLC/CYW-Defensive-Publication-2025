#!/bin/bash

# rebuild_chain.sh - Automates the parent-to-child hash injection
# -------------------------------------------------------------
# 1. Identifies files in dependency order.
# 2. Computes parent hashes.
# 3. Injects them into child "parent_artifacts" blocks.
# 4. Re-hashes the children.

# Define the source files in order of dependency (relative to portfolio/)
ROOT="docs/origin/Origin_Story_Amazon_Experiments_2023.md"
TIMELINE="docs/timeline/Development_Timeline_and_Milestones.md"
CLAIMS="architecture/claims/System_Claims_and_Architecture_Spec.md"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTFOLIO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

update_and_link() {
    local parent_path=$1
    local child_path=$2

    echo "🔗 Linking $parent_path -> $child_path..."

    local parent_file="$PORTFOLIO_ROOT/$parent_path"
    local child_file="$PORTFOLIO_ROOT/$child_path"

    if [ ! -f "$parent_file" ] || [ ! -f "$child_file" ]; then
        echo "Error: Missing file for link: $parent_path -> $child_path" >&2
        exit 1
    fi

    # Update the parent hash first
    "$SCRIPT_DIR/update_hash.sh" "$parent_file"

    # Extract the new hash from the parent
    local new_hash
    new_hash=$(grep "hash_sha256:" "$parent_file" | awk '{print $2}' | tr -d '"')

    # Inject into the child file's parent_artifacts block
    # Use awk to update the hash line after the matching path
    tmp_file="$(mktemp)"
    awk -v path="$parent_path" -v hash="$new_hash" '
      $0 ~ "path: \"" path "\"" {
        print
        if (getline) {
          sub(/hash: ".*"/, "hash: \"" hash "\"")
          print
          next
        }
      }
      { print }
    ' "$child_file" > "$tmp_file" && mv "$tmp_file" "$child_file"
}

echo "🚀 Starting Automated Chain Rebuild..."

# Step 1: Update Root and flow to Timeline
update_and_link "$ROOT" "$TIMELINE"

# Step 2: Flow Root to Claims (multi-parent)
update_and_link "$ROOT" "$CLAIMS"

# Step 3: Flow Timeline to Claims
update_and_link "$TIMELINE" "$CLAIMS"

# Step 4: Final hash update for Claims (now that it has all parent hashes)
 "$SCRIPT_DIR/update_hash.sh" "$PORTFOLIO_ROOT/$CLAIMS"

echo "✅ Chain rebuilt. Running final validation..."
 "$SCRIPT_DIR/validate_chain.sh"
