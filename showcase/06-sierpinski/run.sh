#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Sierpinski Triangle example..."
dex web "$SCRIPT_DIR/sierpinski.dx" --outfmt html > "$SCRIPT_DIR/output/sierpinski.html" 2>&1 \
  || dex script "$SCRIPT_DIR/sierpinski.dx" > "$SCRIPT_DIR/output/sierpinski.txt" 2>&1
echo "==> Output saved to output/"
