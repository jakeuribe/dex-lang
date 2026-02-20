# 01 - Mandelbrot Set

Renders the classic [Mandelbrot set](https://en.wikipedia.org/wiki/Mandelbrot_set)
fractal using the escape-time algorithm.

## What it demonstrates

- **Complex number library** -- uses `import complex` for arithmetic on the complex plane
- **Escape-time iteration** -- `bounded_iter` with early exit via `Done`/`Continue`
- **Grid evaluation** -- nested `each` over `linspace` ranges
- **Visualization** -- `:html matshow(...)` renders a heatmap of escape times

## Source

[`mandelbrot.dx`](mandelbrot.dx) (symlink to [`examples/mandelbrot.dx`](../../examples/mandelbrot.dx))

## How to run

```bash
bash run.sh          # saves HTML output to output/
dex script mandelbrot.dx   # or run directly
```

## Expected output

A 300x200 heatmap image of the Mandelbrot set, with the classic cardioid
and period-2 bulb clearly visible. The color intensity encodes how many
iterations each point took to escape.
