#!/bin/bash

echo "========================================"
echo "GSD Universal - Update Script"
echo "========================================"
echo ""

# Get target directory
read -p "Enter the path to your project directory: " TARGET_DIR

# Expand tilde and remove quotes
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"
TARGET_DIR="${TARGET_DIR//\"/}"

# Validate target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo ""
    echo "ERROR: Directory does not exist: $TARGET_DIR"
    echo "Please check the path and try again."
    exit 1
fi

# Check if target has GSD files
if [ ! -d "$TARGET_DIR/.gsd" ]; then
    echo ""
    echo "ERROR: Target directory does not have GSD installed."
    echo "Please run install.sh first."
    exit 1
fi

echo ""
echo "Target directory: $TARGET_DIR"
echo ""
echo "WARNING: This will update GSD framework files in your project."
echo ""
echo "Files that will be UPDATED (overwritten):"
echo "  - .gsd/ directory (workflows, protocols, templates, etc.)"
echo "  - scripts/ directory (validation, indexing, ralph scripts)"
echo "  - loop.ps1 and loop.sh"
echo "  - PROMPT_build.md and PROMPT_plan.md"
echo ""
echo "Files that will be PRESERVED (not touched):"
echo "  - IMPLEMENTATION_PLAN.md (your tasks)"
echo "  - specs/ directory (your requirements)"
echo "  - .git/ directory (your git history)"
echo "  - Your source code"
echo "  - README.md, QUICKSTART.md, etc. (your docs)"
echo ""
read -p "Continue with update? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo ""
    echo "Update cancelled."
    exit 0
fi

echo ""
echo "Updating GSD files..."
echo ""

# Update .gsd directory
echo "[1/4] Updating .gsd directory..."
cp -r .gsd/* "$TARGET_DIR/.gsd/" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy .gsd directory"
    exit 1
fi
echo "  - .gsd directory updated"

# Update scripts directory
echo "[2/4] Updating scripts directory..."
mkdir -p "$TARGET_DIR/scripts"
cp -r scripts/* "$TARGET_DIR/scripts/" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy scripts directory"
    exit 1
fi
# Make scripts executable
chmod +x "$TARGET_DIR/scripts"/*.sh 2>/dev/null
chmod +x "$TARGET_DIR/scripts/hooks"/* 2>/dev/null
echo "  - scripts directory updated"

# Update loop files
echo "[3/4] Updating loop files..."
cp loop.ps1 "$TARGET_DIR/loop.ps1"
cp loop.sh "$TARGET_DIR/loop.sh"
chmod +x "$TARGET_DIR/loop.sh"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy loop files"
    exit 1
fi
echo "  - loop.ps1 and loop.sh updated"

# Update PROMPT files
echo "[4/4] Updating PROMPT files..."
cp PROMPT_build.md "$TARGET_DIR/PROMPT_build.md"
cp PROMPT_plan.md "$TARGET_DIR/PROMPT_plan.md"
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to copy PROMPT files"
    exit 1
fi
echo "  - PROMPT_build.md and PROMPT_plan.md updated"

# Optional: Update AGENTS.md
echo ""
read -p "Update AGENTS.md? This may overwrite your custom commands (y/n): " UPDATE_AGENTS
if [ "$UPDATE_AGENTS" = "y" ] || [ "$UPDATE_AGENTS" = "Y" ]; then
    cp AGENTS.md "$TARGET_DIR/AGENTS.md"
    echo "  - AGENTS.md updated"
else
    echo "  - AGENTS.md preserved (not updated)"
fi

# Optional: Update documentation
echo ""
read -p "Update documentation files (README.md, QUICKSTART.md, etc.)? (y/n): " UPDATE_DOCS
if [ "$UPDATE_DOCS" = "y" ] || [ "$UPDATE_DOCS" = "Y" ]; then
    cp README.md "$TARGET_DIR/README.md" 2>/dev/null
    cp QUICKSTART.md "$TARGET_DIR/QUICKSTART.md" 2>/dev/null
    cp GLOSSARY.md "$TARGET_DIR/GLOSSARY.md" 2>/dev/null
    cp GSD-STYLE.md "$TARGET_DIR/GSD-STYLE.md" 2>/dev/null
    echo "  - Documentation files updated"
else
    echo "  - Documentation files preserved (not updated)"
fi

echo ""
echo "========================================"
echo "Update Complete!"
echo "========================================"
echo ""
echo "Updated files in: $TARGET_DIR"
echo ""
echo "What was updated:"
echo "  - GSD framework files (.gsd/)"
echo "  - Validation and utility scripts (scripts/)"
echo "  - Ralph Loop files (loop.ps1, loop.sh)"
echo "  - Prompt templates (PROMPT_*.md)"
echo ""
echo "What was preserved:"
echo "  - Your tasks (IMPLEMENTATION_PLAN.md)"
echo "  - Your specs (specs/)"
echo "  - Your source code"
echo "  - Your git history"
echo ""
echo "Next steps:"
echo "  1. Review changes: cd \"$TARGET_DIR\" && git status"
echo "  2. Test validation: ./scripts/validate.sh --all"
echo "  3. Commit if satisfied: git add -A && git commit -m \"chore: update GSD framework\""
echo ""
