#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Estimating Pi example..."
dex script "$SCRIPT_DIR/pi.dx" > "$SCRIPT_DIR/output/pi.txt" 2>&1
echo "==> Output saved to output/pi.txt"
