#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Levenshtein Distance example..."
dex script "$SCRIPT_DIR/levenshtein-distance.dx" > "$SCRIPT_DIR/output/levenshtein.txt" 2>&1
echo "==> Output saved to output/levenshtein.txt"
