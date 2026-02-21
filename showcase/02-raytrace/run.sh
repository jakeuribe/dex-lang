#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Ray Tracer example (this may take a while)..."
dex web "$SCRIPT_DIR/raytrace.dx" --outfmt html > "$SCRIPT_DIR/output/raytrace.html" 2>&1 \
  || dex script "$SCRIPT_DIR/raytrace.dx" > "$SCRIPT_DIR/output/raytrace.txt" 2>&1
echo "==> Output saved to output/"
