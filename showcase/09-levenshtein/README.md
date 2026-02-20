# 09 - Levenshtein Distance

Computes minimum edit distance between strings via dynamic programming,
then builds a crude spelling corrector by searching `/usr/share/dict/words`.

## What it demonstrates

- **Dynamic programming** -- filling a 2D table with `yield_state` and nested `for`
- **Flexible index sets** -- `Post n` is one larger than `n`, encoding the DP table dimensions statically
- **Zero off-by-one errors** -- the type system prevents indexing mistakes at compile time
- **Benchmarking** -- `%bench` and `%time` directives for performance measurement
- **Real-world data** -- reads the system dictionary and finds closest words

## Source

[`levenshtein-distance.dx`](levenshtein-distance.dx) (symlink to [`examples/levenshtein-distance.dx`](../../examples/levenshtein-distance.dx))

## How to run

```bash
bash run.sh
dex script levenshtein-distance.dx
```

## Expected output

```
"kitten" vs "sitting": full DP table, distance = 3
Sountsov benchmark (all pairs up to size 100): ~80ms
closest_word "hello"       => "hello"
closest_word "kitttens"    => "kittens"
closest_word "functor"     => "function"
closest_word "paralllel"   => "parallel"
```
