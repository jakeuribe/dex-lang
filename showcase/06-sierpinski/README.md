# 06 - Sierpinski Triangle

Generates a Sierpinski triangle fractal using the
[chaos game](https://en.wikipedia.org/wiki/Chaos_game) algorithm.

## What it demonstrates

- **Stateful iteration** -- `with_state` + `for` loop to build a Markov chain
- **Random index sampling** -- `rand_idx` to pick a random vertex each step
- **Point arithmetic** -- midpoint computation between current position and a random vertex
- **XY scatter plotting** -- `:html show_plot $ xy_plot xs ys`

## Source

[`sierpinski.dx`](sierpinski.dx) (symlink to [`examples/sierpinski.dx`](../../examples/sierpinski.dx))

## How to run

```bash
bash run.sh
dex script sierpinski.dx   # fast
```

## Expected output

A scatter plot of 3000 points that form the classic Sierpinski triangle --
a self-similar fractal built from three vertices at `(0,0)`, `(1,0)`,
and `(0.5, sqrt(0.75))`.
