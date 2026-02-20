# 02 - Ray Tracer

A full Monte Carlo path tracer that renders a Cornell-box-style scene
with diffuse surfaces, mirrors, and area lighting.

## What it demonstrates

- **Algebraic data types** -- `enum ObjectGeom`, `enum Surface`, `enum RayMarchResult`
- **Structs and records** -- `Ray`, `Camera`, `Params`, `Scene`
- **Ray marching** -- signed-distance-function based scene intersection
- **Monte Carlo integration** -- cosine-weighted hemisphere sampling for diffuse reflection
- **Automatic differentiation** -- `grad` used in `calcNormal` to compute surface normals from SDFs
- **Image output** -- `:html imshow ...` renders the final image

## Source

[`raytrace.dx`](raytrace.dx) (symlink to [`examples/raytrace.dx`](../../examples/raytrace.dx))

## How to run

```bash
bash run.sh
dex script raytrace.dx   # or run directly (slow -- renders 250x250 @ 50 samples)
```

## Expected output

Two rendered images of a Cornell box scene:
1. A 250x250 image with 50 samples per pixel -- soft shadows, color bleeding, mirror reflections
2. A single-sample version showing the raw noise structure of the Monte Carlo estimator
