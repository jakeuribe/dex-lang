# Issue Investigation & Fix Report

> 12 critical issues from google-research/dex-lang investigated in parallel.
> Each was verified at the source-code level, root-caused, and either fixed or documented as too deep.

---

## Summary

| # | Issue | Verdict | Branch | Status |
|---|-------|---------|--------|--------|
| **1345** | Can't negate Float64 | Trivial fix (2 lines) | `claude/fix-1345-float64-vspace-Z1mCt` | **Fixed & pushed** |
| **1033** | Complex pow(0,z) returns NaN | Easy fix (5 lines) | `claude/fix-1033-complex-pow-zero-Z1mCt` | **Fixed & pushed** |
| **1133** | Can't scan with effectful body | Easy fix (type sig) | `claude/fix-1133-effectful-scan-Z1mCt` | **Fixed & pushed** |
| **1211** | Unsigned rem/div uses signed instructions | Easy fix (17 lines) | `claude/fix-1211-unsigned-rem-div-Z1mCt` | **Fixed & pushed** |
| **1167** | REPL can't redefine failed variable | Easy fix (1 line) | `claude/fix-1167-repl-redefine-Z1mCt` | **Fixed & pushed** |
| **310** | Strings with # break notebook | Moderate fix (1 line) | `claude/fix-310-notebook-hash-strings-Z1mCt` | **Fixed & pushed** |
| **1338** | Can't put functions in structs | Moderate fix (12 lines) | `claude/fix-1338-fn-in-structs-Z1mCt` | **Fixed & pushed** |
| **1267** | >>> composition operator misparsed | Moderate fix (2 lines) | `claude/fix-1267-composition-operator-Z1mCt` | **Fixed & pushed** |
| **323** | Typeclass sibling method references | Moderate but risky | — | **Too deep** |
| **239** | ! operator can't handle dependent types | Medium difficulty | — | **Too deep** |
| **1333** | Struct field table indexing crash | Architectural | — | **Too deep** |
| **1019** | AD crash with sum-type indices | Fundamental limitation | — | **Too deep** |

**8 fixed, 4 documented as too deep.**

---

## Fixes Applied (8 branches)

### Fix 1: #1345 — Can't negate a Float64
- **Branch**: `claude/fix-1345-float64-vspace-Z1mCt`
- **File**: `lib/prelude.dx`
- **Root cause**: `Float64` was missing a `VSpace` instance. The `neg` function requires `VSpace`, so `Float64` negation was impossible.
- **Fix**: Added `instance VSpace(Float64)` with scalar multiply, mirroring the existing `Float32` instance.

### Fix 2: #1033 — Complex pow(0+0i, z) returns NaN
- **Branch**: `claude/fix-1033-complex-pow-zero-Z1mCt`
- **File**: `lib/complex.dx`
- **Root cause**: `complex_pow` uses `exp(power * log(base))`. When base=0: `log(0)=-inf`, then `0 * (-inf) = NaN` (IEEE 754), corrupting the result.
- **Fix**: Special-case zero base: return `0+0i` when `Re(power) > 0`, otherwise fall through.

### Fix 3: #1133 — Can't scan with an effectful body
- **Branch**: `claude/fix-1133-effectful-scan-Z1mCt`
- **File**: `lib/prelude.dx`
- **Root cause**: `scan` and `fold` had pure-only type signatures for their body parameters, despite the internal `run_state` implementation supporting effects.
- **Fix**: Generalized body type signatures to allow `{|eff}` effects, matching the pattern used by `run_state` and friends.

### Fix 4: #1211 — Unsigned remainder/division uses signed instructions
- **Branch**: `claude/fix-1211-unsigned-rem-div-Z1mCt`
- **File**: `src/lib/ImpToLLVM.hs`
- **Root cause**: `compileBinOp` unconditionally emitted `L.SDiv`/`L.SRem` (signed) regardless of operand type. For `Word8`/`Word32`/`Word64`, this produces wrong results.
- **Fix**: Added `isUnsigned` predicate and thread `BaseType` into `compileBinOp` to dispatch to `L.UDiv`/`L.URem` for unsigned types.

### Fix 5: #1167 — REPL can't redefine a failed variable
- **Branch**: `claude/fix-1167-repl-redefine-Z1mCt`
- **File**: `src/lib/TopLevel.hs`
- **Root cause**: When evaluation fails, `evalSourceBlock` registers the name in the source map via `uDeclErrSourceMap` with a "failed" marker (`ModuleVar desc Nothing`). This poisons the namespace so `SourceRename.hs` rejects future redefinitions.
- **Fix**: Removed the error-path source map registration so failed names don't block future definitions.

### Fix 6: #310 — Strings containing # break the notebook
- **Branch**: `claude/fix-310-notebook-hash-strings-Z1mCt`
- **File**: `src/lib/Lexing.hs`
- **Root cause**: `lineComment` parser matches `#` and consumes to EOL. When `#` precedes `"` (e.g. as part of expression context), the comment parser interferes.
- **Fix**: Added `notFollowedBy (char '"')` guard so `#"` is not consumed as a comment start.

### Fix 7: #1338 — Can't put functions in structs or data constructors
- **Branch**: `claude/fix-1338-fn-in-structs-Z1mCt`
- **File**: `src/lib/AbstractSyntax.hs`
- **Root cause**: `CArrow` handler required LHS to be parenthesized (`CParens`). Non-parenthesized function types like `A -> B` threw `ArgsShouldHaveParens`.
- **Fix**: Added fallback: treat unparenthesized LHS as an anonymous type binder (`UIgnore`), so `A -> B` desugars to `(_:A) -> B`.

### Fix 8: #1267 — Function composition operator >>> misparsed
- **Branch**: `claude/fix-1267-composition-operator-Z1mCt`
- **File**: `src/lib/ConcreteSyntax.hs`
- **Root cause**: `>>>` and `<<<` were placed at lower precedence than `->` and `=>>` in the operator table, causing them to be parsed incorrectly relative to function application.
- **Fix**: Moved `>>>` and `<<<` above the arrow operators in the precedence table.

---

## Too Deep — Why We Stopped (4 issues)

### #323 — Typeclass instance methods can't reference sibling methods
- **Verified**: Yes. Test cases exist in `tests/instance-methods-tests.dx`.
- **Root cause**: Instance methods are type-checked sequentially *before* the instance is registered. When method `i` calls method `j` (where `j <= i`), the synthesizer tries `Full` access (all methods required) but the instance is incomplete.
- **Infrastructure exists**: `RequiredMethodAccess` has `Full` and `Partial Int` variants already.
- **Why too deep**: The fix requires modifying instance elaboration order in `Inference.hs` to register partial instances during checking. While the data structures exist, the change touches instance synthesis, method checking loops, and dictionary access control (~100-150 lines across a critical compiler pass). Risk of subtle regressions in type class resolution is high.

### #239 — The ! operator can't handle dependent types
- **Verified**: Yes. Test case at `tests/type-tests.dx:353`.
- **Root cause**: `Inference.hs:1136` — `checkSigmaDependent` requires dependent arguments to be "fully reducible" via `withReducibleEmissions`. For table indexing, this is unnecessarily strict: `typeOfIndexRef` in `QueryType.hs` only needs substitution, not full reduction.
- **Why too deep**: Requires creating a special inference path for table indexing that bypasses the "fully reducible" check. This means modifying `checkOrInferExplicitArg` to detect the table-indexing context and handle it differently — a surgical but sensitive change in the core type inference pipeline (~20-30 lines, but regression risk in the dependent-type machinery is moderate).

### #1333 — Compiler crash: struct field table indexing
- **Verified**: Yes. Error path traced to `Simplify.hs:141-142` where `StuckTabApp` hits `CCCon` or `CCFun`.
- **Root cause**: **Architectural contradiction** — the type system (`QueryType.hs:isData`) classifies table types as "data", but the simplifier (`Simplify.hs:toDataAtom`) can't represent tables as data values. When a table is stored in a struct field, projection returns a form the simplifier doesn't expect.
- **Why too deep**: The fix requires either (a) reclassifying tables as non-data (500-1500 lines across 10+ modules), (b) special-casing table projections (band-aid, incomplete), or (c) disallowing tables in structs (restricts language). All options have major architectural implications. This is a **design conflict**, not a bug.

### #1019 — Compiler crash on higher AD with sum-type indices
- **Verified**: Yes. Crash occurs at three points: `Builder.hs:861-874` (missing tangent type), `Linearize.hs:599` (unimplemented sum constructor linearization), `Linearize.hs:399` (active sum scrutinees not handled).
- **Root cause**: Sum types are **discrete choices**, not continuous values. The AD system has no mathematical framework for differentiating through discrete branches.
- **Why too deep**: Fixing this requires either (a) a new mathematical framework for sum-type differentiation, (b) control-flow-dependent AD (fundamentally incompatible with current reverse-mode design), or (c) symbolic gradients (major redesign). Estimated at **60-100+ hours** of work. This is a **fundamental limitation** of the AD architecture, not a simple bug.
