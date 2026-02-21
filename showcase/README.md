# Dex Showcase

A curated collection of the examples highlighted in the [project README](../README.md),
organized into self-contained folders so you can explore, run, and capture outputs
one example at a time.

Each folder contains:
- A **symlink** to the original `.dx` source in `examples/`
- A **README** explaining what the example does and which Dex features it highlights
- A **`run.sh`** script that executes the example and saves output to `output/`
- An **`output/`** directory for rendered HTML, images, or text output

## Examples at a Glance

| # | Example | Key Concepts |
|---|---------|-------------|
| 01 | [Mandelbrot Set](01-mandelbrot/) | Complex arithmetic, escape-time algorithm, `matshow` plotting |
| 02 | [Ray Tracer](02-raytrace/) | ADTs, ray marching, Monte Carlo path tracing, `imshow` |
| 03 | [Estimating Pi](03-estimating-pi/) | Monte Carlo sampling, statistical estimation |
| 04 | [Hamiltonian Monte Carlo](04-hamiltonian-monte-carlo/) | MCMC, HMC, automatic differentiation, `grad` |
| 05 | [ODE Integrator](05-ode-integrator/) | Dormand-Prince adaptive solver, Butcher tableaux, triangular arrays |
| 06 | [Sierpinski Triangle](06-sierpinski/) | Chaos game, stateful iteration, XY plotting |
| 07 | [Basis Function Regression](07-regression/) | Conjugate gradients, polynomial fitting, plotting |
| 08 | [Brownian Motion](08-brownian-motion/) | Virtual Brownian tree, typeclasses, recursion via instances, 2D sheets |
| 09 | [Levenshtein Distance](09-levenshtein/) | Dynamic programming, flexible index sets, `Post` types |
| 10 | [Molecular Dynamics](10-molecular-dynamics/) | FIRE descent, neighbor lists, cell decomposition, `grad` |

## Quick Start

```bash
# Run a single example
cd 01-mandelbrot && bash run.sh

# Run all examples (requires dex on PATH)
make all

# Run just the fast ones (pi, sierpinski, levenshtein)
make fast
```

## Requirements

A working `dex` installation. See the [main README](../README.md#installing) for build instructions.
