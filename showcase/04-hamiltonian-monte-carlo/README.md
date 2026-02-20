# 04 - Hamiltonian Monte Carlo

Implements both Metropolis-Hastings and Hamiltonian Monte Carlo (HMC)
samplers, then compares them on a 2D multivariate normal target distribution.

## What it demonstrates

- **Automatic differentiation** -- `grad logProb` drives the leapfrog integrator in HMC
- **MCMC framework** -- generic `runChain` / `propose` combinators
- **Metropolis-Hastings** -- random-walk proposals with accept/reject
- **Leapfrog integration** -- symplectic ODE integration for Hamiltonian dynamics
- **Comparison** -- HMC recovers the true covariance much better than MH with the same step count

## Source

[`mcmc.dx`](mcmc.dx) (symlink to [`examples/mcmc.dx`](../../examples/mcmc.dx))

## How to run

```bash
bash run.sh
dex script mcmc.dx
```

## Expected output

- Estimated mean and covariance from both MH and HMC samplers
- Two trace plots showing the first coordinate over time
- HMC samples should cluster around mean `[1.5, 2.5]` with covariance
  `[[1, 0], [0, 0.05]]`; MH will show worse mixing
