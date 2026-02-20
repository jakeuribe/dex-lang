#!/usr/bin/env bash
#
# build-and-run-showcase.sh
#
# Comprehensive script to build Dex from source and run all showcase examples,
# capturing real outputs into each showcase folder.
#
# Usage:
#   ./build-and-run-showcase.sh              # full build + run all examples
#   ./build-and-run-showcase.sh --run-only   # skip build, just run examples (dex must be on PATH)
#   ./build-and-run-showcase.sh --build-only # just build dex, don't run examples
#   ./build-and-run-showcase.sh --example 03 # run only example 03
#
# Prerequisites (the script will check for these):
#   - stack (Haskell build tool)
#   - LLVM 12 (llvm-12-dev)
#   - clang 12 (clang-12 or clang++-12)
#   - libpng-dev
#   - pkg-config
#
# On Ubuntu/Debian, install deps with:
#   sudo apt-get install llvm-12-dev clang-12 libpng-dev pkg-config
#
# Install stack with:
#   curl -sSL https://get.haskellstack.org/ | sh
#
# Alternatively, if you have Nix:
#   nix build .#dex   # produces result/bin/dex
#   ./build-and-run-showcase.sh --run-only  # with result/bin/dex on PATH

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SHOWCASE_DIR="$REPO_ROOT/showcase"

# ── Parse arguments ──────────────────────────────────────────────────
BUILD=true
RUN=true
SINGLE_EXAMPLE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --run-only)   BUILD=false; shift ;;
        --build-only) RUN=false; shift ;;
        --example)    SINGLE_EXAMPLE="$2"; shift 2 ;;
        -h|--help)
            head -25 "$0" | grep '^#' | sed 's/^# \?//'
            exit 0 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# ── Colors ───────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[info]${NC}  $*"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
fail()  { echo -e "${RED}[FAIL]${NC}  $*"; }

# ── Dependency checks ────────────────────────────────────────────────
check_deps() {
    info "Checking dependencies..."
    local missing=()

    if ! command -v stack &>/dev/null && ! command -v cabal &>/dev/null; then
        missing+=("stack (or cabal) -- install via: curl -sSL https://get.haskellstack.org/ | sh")
    fi

    if ! command -v llvm-config-12 &>/dev/null && ! command -v llvm-config &>/dev/null; then
        missing+=("llvm-12-dev -- install via: sudo apt-get install llvm-12-dev")
    else
        local llvm_ver
        llvm_ver=$(llvm-config-12 --version 2>/dev/null || llvm-config --version 2>/dev/null)
        if [[ ! "$llvm_ver" =~ ^12\. ]]; then
            warn "LLVM version is $llvm_ver (need 12.x)"
            warn "If using stack.yaml (not llvm-head), this will likely fail."
            warn "Options:"
            warn "  1. Install llvm-12-dev alongside your current LLVM"
            warn "  2. Use nix: nix build .#dex"
            warn "  3. Use DEX_LLVM_HEAD=1 make build (if LLVM >= 13)"
        fi
    fi

    local found_clang=false
    for cc in clang++-12 clang++-11 clang++-10 clang++-9 clang++; do
        if command -v "$cc" &>/dev/null; then
            found_clang=true
            break
        fi
    done
    if ! $found_clang; then
        missing+=("clang-12 -- install via: sudo apt-get install clang-12")
    fi

    if ! dpkg -s libpng-dev &>/dev/null 2>&1 && ! pkg-config --exists libpng 2>/dev/null; then
        missing+=("libpng-dev -- install via: sudo apt-get install libpng-dev")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        fail "Missing dependencies:"
        for dep in "${missing[@]}"; do
            echo "  - $dep"
        done
        echo ""
        echo "On Ubuntu 22.04 (recommended for LLVM 12 availability):"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install llvm-12-dev clang-12 libpng-dev pkg-config"
        echo "  curl -sSL https://get.haskellstack.org/ | sh"
        echo ""
        echo "On Ubuntu 24.04+ (no LLVM 12 in repos), use Nix instead:"
        echo "  nix build .#dex"
        echo "  export PATH=\$PWD/result/bin:\$PATH"
        echo "  $0 --run-only"
        return 1
    fi

    ok "All dependencies found"
}

# ── Build Dex ────────────────────────────────────────────────────────
build_dex() {
    info "Building Dex..."
    cd "$REPO_ROOT"

    local start_time=$SECONDS

    # Build the runtime
    info "Compiling dexrt (C runtime)..."
    make dexrt-llvm

    # Build the Haskell compiler
    info "Building Dex compiler (this may take 10-30 minutes on first build)..."
    if command -v stack &>/dev/null; then
        stack build --fast --ghc-options="-j +RTS -A256m -n2m -RTS"
        # Clear cache and precompile prelude
        info "Precompiling prelude..."
        stack exec dex -- --lib-path lib clean
        stack exec dex -- --lib-path lib script /dev/null
    else
        cabal build
    fi

    local elapsed=$(( SECONDS - start_time ))
    ok "Dex built in ${elapsed}s"
}

# ── Find the dex binary ─────────────────────────────────────────────
find_dex() {
    if command -v dex &>/dev/null; then
        echo "dex"
    elif [[ -x "$REPO_ROOT/result/bin/dex" ]]; then
        echo "$REPO_ROOT/result/bin/dex --lib-path $REPO_ROOT/lib"
    elif command -v stack &>/dev/null; then
        echo "stack exec dex -- --lib-path $REPO_ROOT/lib"
    elif command -v cabal &>/dev/null; then
        echo "cabal exec dex -- --lib-path $REPO_ROOT/lib"
    else
        fail "Cannot find dex binary. Build first or add to PATH."
        return 1
    fi
}

# ── Run a single example ────────────────────────────────────────────
run_example() {
    local dir="$1"
    local name
    name="$(basename "$dir")"
    local dx_file
    dx_file=$(find "$dir" -name '*.dx' -type l -o -name '*.dx' -type f | head -1)

    if [[ -z "$dx_file" ]]; then
        warn "No .dx file found in $dir, skipping"
        return 0
    fi

    # Resolve symlink to actual file
    local real_dx
    real_dx=$(readlink -f "$dx_file")

    local output_dir="$dir/output"
    mkdir -p "$output_dir"

    local base
    base=$(basename "$dx_file" .dx)
    local out_txt="$output_dir/${base}-output.txt"
    local out_html="$output_dir/${base}.html"

    info "Running ${BOLD}$name${NC} ..."
    local start_time=$SECONDS

    # Try HTML output first (captures plots), fall back to text
    # Note: we always capture text output too
    if $DEX_CMD script "$real_dx" > "$out_txt" 2>&1; then
        ok "$name completed in $(( SECONDS - start_time ))s"

        # Also try generating HTML if dex web is available
        if $DEX_CMD web "$real_dx" --outfmt html > "$out_html" 2>/dev/null; then
            ok "  HTML output: $out_html"
        else
            rm -f "$out_html"
        fi
    else
        local exit_code=$?
        fail "$name failed (exit $exit_code) in $(( SECONDS - start_time ))s"
        fail "  Output saved to: $out_txt"
        # Keep the output file for debugging
        return 0  # Don't abort the whole run
    fi

    # Show a preview of the output
    local line_count
    line_count=$(wc -l < "$out_txt")
    echo "  ($line_count lines of output)"
    if [[ $line_count -le 10 ]]; then
        sed 's/^/    /' "$out_txt"
    else
        head -5 "$out_txt" | sed 's/^/    /'
        echo "    ..."
        tail -3 "$out_txt" | sed 's/^/    /'
    fi
    echo ""
}

# ── Main ─────────────────────────────────────────────────────────────
main() {
    echo -e "${BOLD}━━━ Dex Showcase: Build & Run ━━━${NC}"
    echo ""

    if $BUILD; then
        check_deps || exit 1
        build_dex
    fi

    if $RUN; then
        DEX_CMD=$(find_dex) || exit 1
        info "Using dex: $DEX_CMD"
        echo ""

        # Determine which examples to run
        local examples=()
        if [[ -n "$SINGLE_EXAMPLE" ]]; then
            local matched
            matched=$(find "$SHOWCASE_DIR" -maxdepth 1 -type d -name "${SINGLE_EXAMPLE}*" | head -1)
            if [[ -z "$matched" ]]; then
                fail "No showcase folder matching '$SINGLE_EXAMPLE'"
                exit 1
            fi
            examples=("$matched")
        else
            while IFS= read -r d; do
                examples+=("$d")
            done < <(find "$SHOWCASE_DIR" -maxdepth 1 -type d -name '[0-9]*' | sort)
        fi

        local total=${#examples[@]}
        local passed=0
        local failed=0

        for dir in "${examples[@]}"; do
            if run_example "$dir"; then
                ((passed++))
            else
                ((failed++))
            fi
        done

        echo -e "${BOLD}━━━ Results ━━━${NC}"
        echo -e "  ${GREEN}Passed:${NC} $passed / $total"
        if [[ $failed -gt 0 ]]; then
            echo -e "  ${RED}Failed:${NC} $failed / $total"
        fi
        echo ""
        echo "Output files are in each showcase/*/output/ directory."
    fi
}

main "$@"
