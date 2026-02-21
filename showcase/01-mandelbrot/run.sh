#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Mandelbrot Set example..."
dex web "$SCRIPT_DIR/mandelbrot.dx" --outfmt html > "$SCRIPT_DIR/output/mandelbrot.html" 2>&1 \
  || dex script "$SCRIPT_DIR/mandelbrot.dx" > "$SCRIPT_DIR/output/mandelbrot.txt" 2>&1
echo "==> Output saved to output/"
