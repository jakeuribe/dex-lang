# 07 - Basis Function Regression

Fits a polynomial to noisy observations of `x + sin(5x)` using
basis function regression solved by conjugate gradients.

## What it demonstrates

- **Conjugate gradients** -- a from-scratch iterative linear solver
- **Basis function design** -- `poly` maps a scalar to a polynomial feature vector
- **Generic regression** -- `regress` works with any featurization function
- **Multiple plots** -- raw data scatter, fitted curve, and overlaid comparison with color coding
- **RMS error** -- quantitative evaluation of the fit

## Source

[`regression.dx`](regression.dx) (symlink to [`examples/regression.dx`](../../examples/regression.dx))

## How to run

```bash
bash run.sh
dex script regression.dx
```

## Expected output

- Scatter plot of 100 noisy samples from `x + sin(5x)`
- Fitted 3rd-order polynomial curve on 200 test points
- Combined plot with data (color 0) and predictions (color 1)
- RMS error: `0.245...`
