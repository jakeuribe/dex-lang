# Dex (Fork)

Dex (named for "index") is a research language for typed, functional array
processing. This is a personal fork of [google-research/dex-lang](https://github.com/google-research/dex-lang)
focused on reviving and modernizing the project.

The goal of the project is to explore:

  * Type systems for array programming
  * Mathematical program transformations like differentiation and integration
  * User-directed compilation to parallel hardware
  * Interactive and incremental numerical programming and visualization

To learn more, check out the original
[paper](https://arxiv.org/abs/2104.05372)
or the [tutorial](https://google-research.github.io/dex-lang/examples/tutorial.html).

### Showcase

Interactive, rendered versions of the showcase examples (hosted on GitHub Pages):

  * [Mandelbrot Set](https://jakeuribe.github.io/dex-lang/showcase/mandelbrot.html)
  * [Multi-step Ray Tracer](https://jakeuribe.github.io/dex-lang/showcase/raytrace.html)
  * [Monte Carlo Estimates of Pi](https://jakeuribe.github.io/dex-lang/showcase/pi.html)
  * [Markov Chain Monte Carlo](https://jakeuribe.github.io/dex-lang/showcase/mcmc.html)
  * [ODE Integrator](https://jakeuribe.github.io/dex-lang/showcase/ode-integrator.html)
  * [Sierpinski Triangle](https://jakeuribe.github.io/dex-lang/showcase/sierpinski.html)
  * [Basis Function Regression](https://jakeuribe.github.io/dex-lang/showcase/regression.html)
  * [Brownian Motion](https://jakeuribe.github.io/dex-lang/showcase/brownian_motion.html)
  * [Levenshtein Distance](https://jakeuribe.github.io/dex-lang/showcase/levenshtein-distance.html)
  * [Molecular Dynamics](https://jakeuribe.github.io/dex-lang/showcase/md.html)

Or for a more comprehensive look:

  * [The InDex](https://jakeuribe.github.io/dex-lang/index.html) of all documents, libraries, and examples included in this repository.

## What's Changed from Upstream

This fork includes the following changes on top of the upstream `google-research/dex-lang`:

### Syntax Modernization
- Updated all `.dx` files (examples, tests, benchmarks, docs) from the old `data` keyword to `enum`
- Converted `--` comment syntax to `#` across the entire codebase
- Fixed deprecated function names (e.g. `b2i` to `b_to_f`)
- Re-enabled previously broken examples (`vega-plotting`, etc.)

### Build System Updates (Cabal)
- Updated `cabal.project` to use the `llvm-hs` llvm-15 branch for **LLVM 15** compatibility
- Fixed GHC 9.4 compatibility issues:
  - Bang pattern syntax (`!v` -> `! v`) in `Name.hs`, `Subst.hs`, `Algebra.hs`
  - Nested standalone deriving constraints in `Types/Core.hs`
  - CPP guard for opaque `PointerType` in `ImpToLLVM.hs`

### Stack Build (Unchanged)
- The `stack.yaml` still targets **LTS 18.23** (GHC 8.10.7) with **LLVM 12**
- Stack-based builds (`make build`, `make tests`) work as they always did

### Showcase Examples
- Added a `showcase/` directory with 10 curated, self-contained examples
- Each has a `run.sh` script, expected outputs, and a README
- Pre-rendered HTML with graphs deployed to GitHub Pages

### GitHub Pages via Actions
- Added `.github/workflows/docs.yaml` that deploys pre-built HTML from `docs/` to GitHub Pages on pushes to `main` or `claude/**` branches
- Full `make docs` build-from-source still runs on `main`

## Dependencies

There are two supported build paths:

### Option A: Stack (GHC 8.10 + LLVM 12)

This is the original upstream build path and remains the default.

  * Install [stack](https://www.haskellstack.org)
  * Install LLVM 12
    * Ubuntu/Debian: `apt-get install llvm-12-dev`
    * macOS: `brew install llvm@12`
      * Make sure `llvm@12` is on your `PATH` before building. Example: `export PATH="$(brew --prefix llvm@12)/bin:$PATH"`
  * Install clang 12 (may be installed together with llvm)
    * Ubuntu/Debian: `apt-get install clang-12`
    * macOS: installs with llvm
  * Install libpng
    * Ubuntu/Debian: `apt-get install libpng-dev`
    * macOS: `brew install libpng`

### Option B: Cabal (GHC 9.4 + LLVM 15)

This is the newer build path added in this fork.

  * Install GHC 9.4 via [ghcup](https://www.haskell.org/ghcup/): `ghcup install ghc 9.4`
  * Install cabal: `ghcup install cabal`
  * Install LLVM 15
    * Ubuntu/Debian: `apt-get install llvm-15-dev`
    * macOS: `brew install llvm@15`
  * Install libpng
    * Ubuntu/Debian: `apt-get install libpng-dev`
    * macOS: `brew install libpng`
  * Build: `cabal build`

The `cabal.project` file is already configured with the correct `llvm-hs` branch and LLVM 15 library paths for Ubuntu. On macOS you may need to adjust the `extra-lib-dirs` and `extra-include-dirs` in `cabal.project`.

## Installing

To build and install a release version of Dex run `make install`.

The default installation directory is `$HOME/.local/bin`, so make sure to add
that directory to `$PATH` after installing Dex. To install Dex somewhere else,
set the `PREFIX` environment variable before running `make install`. For
example, `PREFIX=$HOME make install` installs `dex` in `$HOME/bin`.

## Building

 * Build Dex in development (unoptimized) mode: `make`
 * Run tests in development mode: `make tests`

It is convenient to set up a `dex` alias (e.g. in `.bashrc`) for running Dex in
development mode:

```console
# Linux:
alias dex="stack exec dex -- --lib-path lib"

# macOS:
alias dex="stack exec --stack-yaml=stack-macos.yaml dex -- --lib-path lib"
```

You might also want to consider other development build targets:
  * `build-opt` for local optimized builds,
  * `build-dbg` for local debug builds,
  * `build-prof` for local optimized builds with profiling enabled.

Those non-standard targets require different aliases. Please consult the documentation
at the top of the [`makefile`](makefile) for detailed instructions.

### Haskell Language Server

In order to use [HLS](https://github.com/haskell/haskell-language-server) with
the Haskell code in this project:

- Install [ghcup](https://www.haskell.org/ghcup/)
- Run `ghcup install hls`
- Create a file in the root `dex` directory called `hie.yaml` with the following
contents:

```yaml
cradle:
  stack:
    stackYaml: "./stack-macos.yaml"  # Or stack.yaml if not on MacOS
```

Unfortunately one cannot dynamically select the `stack.yaml` file to use based
on the environment, and so one has to create an appropriate `hie.yaml` file
manually. This will be ignored by git.

This should work out of the box with Emacs' `lsp-haskell` package.

### Building with Nix

[Nix](https://nixos.org/) is a functional package manager and build system.

To build with vanilla Nix:
```bash
$ nix-build
```

To build with flakes-enabled Nix:
```bash
$ nix build .#dex
```
The resulting `dex` binary should be in `result/bin/dex`.

For development purposes, you can use a Nix environment with
```bash
$ nix-shell
$ nix develop  # With flakes
```
and use `make` to use Stack to build Dex.

## Running

  * Traditional REPL: `dex repl`
  * Execute script: `dex script examples/pi.dx`
  * Live-updated notebook display `dex web examples/pi.dx` (html) or `dex watch
    examples/pi.dx` (terminal).

## License

BSD-3

This is an early-stage research project, not an official Google product.
