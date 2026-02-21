# 08 - Brownian Motion

Implements stateless, constant-memory sampling of Brownian motion (and
Brownian sheets) using the virtual Brownian tree algorithm from
[Scalable Gradients for Stochastic Differential Equations](https://arxiv.org/pdf/2001.01328.pdf).

## What it demonstrates

- **Virtual Brownian tree** -- lazy evaluation of Brownian bridge values at arbitrary precision
- **Typeclasses** -- `HasStandardNormal` and `HasBrownianSheet` for generic output types
- **Recursion via instances** -- higher-dimensional sheets built by nesting 1D bridge samplers
- **Iterative doubling** -- extending unit-interval bridges to the full real line
- **Image output** -- 2D Brownian sheet rendered as an RGB image via `imshow`

## Source

[`brownian_motion.dx`](brownian_motion.dx) (symlink to [`examples/brownian_motion.dx`](../../examples/brownian_motion.dx))

## How to run

```bash
bash run.sh
dex script brownian_motion.dx
```

## Expected output

1. A 1D Brownian motion trace (400 points, `t` in `[0.3, 2.1]`)
2. Finite differences of the trace (should look like white noise)
3. A 400x400 RGB image sampled from a 2D Brownian sheet -- a colorful,
   continuous random texture
