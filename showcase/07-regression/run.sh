#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Basis Function Regression example..."
dex web "$SCRIPT_DIR/regression.dx" --outfmt html > "$SCRIPT_DIR/output/regression.html" 2>&1 \
  || dex script "$SCRIPT_DIR/regression.dx" > "$SCRIPT_DIR/output/regression.txt" 2>&1
echo "==> Output saved to output/"
