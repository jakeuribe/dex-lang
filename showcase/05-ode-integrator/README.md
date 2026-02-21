# 05 - ODE Integrator

An adaptive-stepsize ODE solver using the Dormand-Prince (RK45) method,
ported from [JAX's experimental ODE module](https://github.com/google/jax/blob/4236eb2b5929b9643977553f7f988ca518b7df4e/jax/experimental/ode.py).

## What it demonstrates

- **Triangular array types** -- the Butcher tableau `beta` uses Dex's dependent `(i:Fin 6)=>(..i)=>Float` type
- **Adaptive stepping** -- error estimation and step-size control via embedded RK methods
- **Polynomial interpolation** -- 4th-order polynomial fitted between RK steps for dense output
- **Stateful iteration** -- `yield_state` + `iter` for the while-loop-style adaptive integration

## Source

[`ode-integrator.dx`](ode-integrator.dx) (symlink to [`examples/ode-integrator.dx`](../../examples/ode-integrator.dx))

## How to run

```bash
bash run.sh
dex script ode-integrator.dx
```

## Expected output

- Numerical approximation of `e` (Euler's number): `[[2.720...]]`
  (the linear ODE `dz/dt = z` with `z(0) = 1` gives `z(1) = e`)
- Numerical error vs. exact value: `[[0.001...]]`
- A plot of the exponential curve from `t=0` to `t=1`
