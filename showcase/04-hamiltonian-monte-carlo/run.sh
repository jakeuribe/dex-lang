#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running Hamiltonian Monte Carlo example..."
dex web "$SCRIPT_DIR/mcmc.dx" --outfmt html > "$SCRIPT_DIR/output/mcmc.html" 2>&1 \
  || dex script "$SCRIPT_DIR/mcmc.dx" > "$SCRIPT_DIR/output/mcmc.txt" 2>&1
echo "==> Output saved to output/"
