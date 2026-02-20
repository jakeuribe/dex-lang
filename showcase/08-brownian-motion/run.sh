#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Brownian Motion example..."
dex web "$SCRIPT_DIR/brownian_motion.dx" --outfmt html > "$SCRIPT_DIR/output/brownian_motion.html" 2>&1 \
  || dex script "$SCRIPT_DIR/brownian_motion.dx" > "$SCRIPT_DIR/output/brownian_motion.txt" 2>&1
echo "==> Output saved to output/"
