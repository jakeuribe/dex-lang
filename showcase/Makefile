# Showcase Makefile -- run Dex README examples and capture output
#
# Usage:
#   make all       Run every example
#   make fast      Run only the quick examples (~seconds each)
#   make slow      Run the compute-heavy examples
#   make clean     Remove all generated output
#   make 01        Run just the Mandelbrot example (etc. for 02-10)

SHELL := /bin/bash

DIRS := 01-mandelbrot 02-raytrace 03-estimating-pi \
        04-hamiltonian-monte-carlo 05-ode-integrator \
        06-sierpinski 07-regression 08-brownian-motion \
        09-levenshtein 10-molecular-dynamics

FAST := 03-estimating-pi 06-sierpinski 09-levenshtein
SLOW := 01-mandelbrot 02-raytrace 04-hamiltonian-monte-carlo \
        05-ode-integrator 07-regression 08-brownian-motion \
        10-molecular-dynamics

.PHONY: all fast slow clean $(DIRS)

all: $(DIRS)

fast: $(FAST)

slow: $(SLOW)

$(DIRS):
	@echo "━━━ $@ ━━━"
	@cd $@ && bash run.sh

# Shorthand numeric targets: make 01, make 02, etc.
01: 01-mandelbrot
02: 02-raytrace
03: 03-estimating-pi
04: 04-hamiltonian-monte-carlo
05: 05-ode-integrator
06: 06-sierpinski
07: 07-regression
08: 08-brownian-motion
09: 09-levenshtein
10: 10-molecular-dynamics

clean:
	@for d in $(DIRS); do \
		rm -f $$d/output/*.html $$d/output/*.txt $$d/output/*.png; \
	done
	@echo "Cleaned all output files (kept .gitkeep)"
