# 10 - Molecular Dynamics

A port of [JAX MD](https://github.com/google/jax-md) into Dex, simulating
soft-sphere particles under periodic boundary conditions using FIRE descent
for energy minimization.

## What it demonstrates

- **Automatic differentiation** -- `grad energy` computes forces on all particles
- **FIRE descent** -- an accelerated gradient descent with adaptive step sizing
- **Periodic boundary conditions** -- toroidal wrapping for displacement and shift
- **Cell decomposition** -- O(N) neighbor list construction via spatial hashing
- **Bounded lists** -- growable arrays with O(1) push for in-place mutation
- **SVG diagram output** -- `render_svg` + `draw_system` visualizes particle positions
- **Scaling** -- demonstrates going from 500 to 50,000 particles with the neighbor list optimization

## Source

[`md.dx`](md.dx) (symlink to [`examples/md.dx`](../../examples/md.dx))

## How to run

```bash
bash run.sh
dex script md.dx   # uses IO for neighbor list rebuild logging
```

## Expected output

1. Initial random configuration of 500 particles in a periodic box
2. Energy vs. iteration plot showing monotonic decrease
3. Minimized configuration -- particles settle into a near-crystalline packing
4. Scaled-up run with 50,000 particles (when not in test mode)
