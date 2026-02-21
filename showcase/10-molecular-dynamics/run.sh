#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Molecular Dynamics example (this may take a while)..."
dex web "$SCRIPT_DIR/md.dx" --outfmt html > "$SCRIPT_DIR/output/md.html" 2>&1 \
  || dex script "$SCRIPT_DIR/md.dx" > "$SCRIPT_DIR/output/md.txt" 2>&1
echo "==> Output saved to output/"
