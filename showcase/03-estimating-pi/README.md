# 03 - Estimating Pi

Two Monte Carlo methods for estimating the value of pi, with mean and
standard deviation computed from one million samples.

## What it demonstrates

- **Random number generation** -- `split_key`, `rand` for uniform samples
- **Monte Carlo estimation** -- area method (random points in the unit square) and average-value method
- **Statistical aggregation** -- computing mean and standard deviation over large sample sets
- **Literate programming** -- LaTeX math rendered in prose blocks (`'`)

## Source

[`pi.dx`](pi.dx) (symlink to [`examples/pi.dx`](../../examples/pi.dx))

## How to run

```bash
bash run.sh
dex script pi.dx   # fast -- runs in seconds
```

## Expected output

```
(3.141..., 1.64...)    # area method:     mean ~ pi, std ~ 1.64
(3.14...,  0.886...)   # avg-value method: mean ~ pi, std ~ 0.89
```

The average-value estimator has lower variance, converging faster.
