#!/bin/bash

# Script to diff auxiliary files between current directory and ../kraken-aux
# Auxiliary files include: .aux/, .devcontainer/, .vscode/, Dockerfile, run.sh, build.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KRAKEN_DIR="$(dirname "$SCRIPT_DIR")"
AUX_DIR="$(dirname "$KRAKEN_DIR")/kraken-aux"

echo -e "${YELLOW}Comparing auxiliary files between:${NC}"
echo -e "  Current: $KRAKEN_DIR"
echo -e "  Reference: $AUX_DIR"
echo

# Check if kraken-aux directory exists
if [ ! -d "$AUX_DIR" ]; then
    echo -e "${RED}Error: Directory $AUX_DIR does not exist${NC}"
    exit 1
fi

# List of auxiliary files and directories to compare
AUX_ITEMS=(
    ".aux"
    ".devcontainer"
    ".vscode"
    "Dockerfile"
    "run.sh"
    "build.sh"
)

# Function to compare files or directories
compare_item() {
    local item="$1"
    local current_path="$KRAKEN_DIR/$item"
    local ref_path="$AUX_DIR/$item"
    
    echo -e "${YELLOW}=== Comparing $item ===${NC}"
    
    # Check if item exists in both locations
    if [ ! -e "$current_path" ] && [ ! -e "$ref_path" ]; then
        echo -e "${YELLOW}  $item does not exist in either location${NC}"
        return
    elif [ ! -e "$current_path" ]; then
        echo -e "${RED}  $item missing from current directory${NC}"
        return
    elif [ ! -e "$ref_path" ]; then
        echo -e "${RED}  $item missing from reference directory${NC}"
        return
    fi
    
    # Perform the diff
    if [ -d "$current_path" ] && [ -d "$ref_path" ]; then
        # Directory comparison
        if diff -r "$current_path" "$ref_path" >/dev/null 2>&1; then
            echo -e "${GREEN}  ✓ Directories are identical${NC}"
        else
            echo -e "${RED}  ✗ Directories differ:${NC}"
            diff -r "$current_path" "$ref_path" || true
        fi
    elif [ -f "$current_path" ] && [ -f "$ref_path" ]; then
        # File comparison
        if diff "$current_path" "$ref_path" >/dev/null 2>&1; then
            echo -e "${GREEN}  ✓ Files are identical${NC}"
        else
            echo -e "${RED}  ✗ Files differ:${NC}"
            diff "$current_path" "$ref_path" || true
        fi
    else
        echo -e "${RED}  ✗ Type mismatch (one is file, other is directory)${NC}"
    fi
    echo
}

# Compare each auxiliary item
for item in "${AUX_ITEMS[@]}"; do
    compare_item "$item"
done

echo -e "${YELLOW}Diff comparison complete.${NC}"
