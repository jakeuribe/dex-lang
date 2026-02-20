#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "==> Running ODE Integrator example..."
dex web "$SCRIPT_DIR/ode-integrator.dx" --outfmt html > "$SCRIPT_DIR/output/ode-integrator.html" 2>&1 \
  || dex script "$SCRIPT_DIR/ode-integrator.dx" > "$SCRIPT_DIR/output/ode-integrator.txt" 2>&1
echo "==> Output saved to output/"
