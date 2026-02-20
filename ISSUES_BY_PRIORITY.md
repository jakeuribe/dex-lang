# google-research/dex-lang — Open Issues Sorted by Priority

> Generated from the upstream repository [google-research/dex-lang](https://github.com/google-research/dex-lang).
> Issues are categorized into priority tiers based on severity, user impact, and project health,
> then sorted within each tier by comparing relative importance.

---

## Priority Criteria

| Priority | Description |
|----------|-------------|
| **P0 — Critical** | Compiler crashes, data-loss bugs, broken builds — blocks all users |
| **P1 — High** | Core language limitations, major missing features, regressions that break real workflows |
| **P2 — Medium** | Important language/tooling enhancements, moderate bugs, quality-of-life improvements |
| **P3 — Low** | Nice-to-haves, minor polish, discussion items, speculative features |
| **P4 — Wishlist** | Examples, demos, naming bikesheds, educational PRs |

---

## P0 — Critical (Blocks users / broken builds)

These issues cause compiler crashes, build failures, or data-correctness bugs that prevent basic usage.

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#1278](https://github.com/google-research/dex-lang/issues/1278) | Fix test regressions after LLVM 15 upgrade | — | Multiple segfaults and nondeterministic crashes across the test suite after LLVM 15; blocks the upgrade path |
| [#1211](https://github.com/google-research/dex-lang/issues/1211) | Do unsigned remainder on unsigned types | bug, good first issue | `rem` emits signed instruction for unsigned types — silently produces wrong results |
| [#1019](https://github.com/google-research/dex-lang/issues/1019) | Compiler bug on higher AD involving `(\|)` index type | bug | Compiler crash on higher-order AD with sum-type indices |
| [#1333](https://github.com/google-research/dex-lang/issues/1333) | Can't retrieve a toplevel table from a local struct field | — | "Compiler bug! Unexpected table" — internal crash |
| [#310](https://github.com/google-research/dex-lang/issues/310) | Strings containing `#` break the web notebook | bug, tooling / notebooks | Valid code crashes the notebook parser |
| [#1345](https://github.com/google-research/dex-lang/issues/1345) | Can't negate a `Float64` | — | Basic arithmetic operation fails — no `Float64` negation |
| [#1033](https://github.com/google-research/dex-lang/issues/1033) | Complex `pow` numerics at zero | — | `pow(0+0i, 2+0i)` returns NaN instead of 0 — numerical correctness |

---

## P1 — High (Core language gaps / major regressions)

Fundamental language features that are missing or broken, significantly limiting what users can express.

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#1264](https://github.com/google-research/dex-lang/issues/1264) | Upgrade to LLVM 15, support Apple M1 | — | PR that enables M1 support; high user demand, blocked on #1278 regressions |
| [#331](https://github.com/google-research/dex-lang/issues/331) | Recursive algebraic data types | language / compiler, backend | Fundamental data structure (linked lists, trees) impossible to define |
| [#1338](https://github.com/google-research/dex-lang/issues/1338) | Can't put functions in structs or data constructors | — | Functions-as-values in data types is essential for many patterns |
| [#710](https://github.com/google-research/dex-lang/issues/710) | Allow unreduced applications in types | — | Dependent type applications don't work — limits the type system |
| [#1141](https://github.com/google-research/dex-lang/issues/1141) | Plan for associated types | — | Major type-system feature with a concrete implementation plan |
| [#1139](https://github.com/google-research/dex-lang/issues/1139) | Enforce constraints from type-parameter role system | — | Correctness invariants not yet enforced after role system was added |
| [#621](https://github.com/google-research/dex-lang/issues/621) | Higher-kinded interfaces | language / type system | Can't abstract over type constructors in interfaces |
| [#258](https://github.com/google-research/dex-lang/issues/258) | No support for polymorphism over record fields | language / type system | Can't write generic code over records — major expressiveness gap |
| [#239](https://github.com/google-research/dex-lang/issues/239) | The `!` operator cannot handle dependent types | language / type system | Dependent indexing is broken with `!` |
| [#323](https://github.com/google-research/dex-lang/issues/323) | Typeclass instance methods can't reference sibling methods | language / concrete syntax, shovel-ready | Standard OOP/typeclass pattern doesn't work |
| [#340](https://github.com/google-research/dex-lang/issues/340) | Overlapping/default type class instances | language / concrete syntax | No way to provide default implementations with specializations |
| [#1133](https://github.com/google-research/dex-lang/issues/1133) | Can't scan with a body that has an effect | — | Effectful scan is mathematically valid but rejected by the compiler |
| [#302](https://github.com/google-research/dex-lang/issues/302) | Support unicode strings | language / compiler, backend | Strings are ASCII-only — basic internationalization gap |
| [#174](https://github.com/google-research/dex-lang/issues/174) | Report stack traces for runtime errors | language / compiler, backend | Runtime errors give no location context — very hard to debug |
| [#371](https://github.com/google-research/dex-lang/issues/371) | Provide self-contained packages for Dex | maintenance | No easy install path for users (no binaries, no wheels) |
| [#1247](https://github.com/google-research/dex-lang/issues/1247) | Building on M1 Mac | — | Apple Silicon users can't build without workarounds |
| [#1248](https://github.com/google-research/dex-lang/issues/1248) | Error installing Dex using Nix on Docker | — | Nix install path broken due to `floating-bits` marked as broken |
| [#521](https://github.com/google-research/dex-lang/issues/521) | Build fails on AArch64, Fedora 33 | — | ARM Linux builds don't work |

---

## P2 — Medium (Enhancements, moderate bugs, quality-of-life)

Important improvements to the language, tooling, or standard library that would meaningfully improve the user experience.

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#1167](https://github.com/google-research/dex-lang/issues/1167) | Redefine an ill-defined variable in the REPL | tooling / repl | Typo in REPL permanently blocks that variable name |
| [#1267](https://github.com/google-research/dex-lang/issues/1267) | Function composition operator mixup | — | `>>>` parses incorrectly — confusing for users |
| [#409](https://github.com/google-research/dex-lang/issues/409) | Sort top-level declarations topologically | language / concrete syntax | Requiring forward-declaration order is an unnecessary burden |
| [#307](https://github.com/google-research/dex-lang/issues/307) | Support nested refutable patterns | language / concrete syntax | Pattern matching is less powerful than expected |
| [#334](https://github.com/google-research/dex-lang/issues/334) | Add a way to (de)serialize Dex values | language / concrete syntax | No way to save/load data — limits practical workflows |
| [#338](https://github.com/google-research/dex-lang/issues/338) | Add variable shadowing warning | language / concrete syntax | Silent shadowing causes subtle bugs |
| [#413](https://github.com/google-research/dex-lang/issues/413) | Write a system for emitting warnings from compiler | language / concrete syntax | No warning infrastructure at all — prerequisite for #338 |
| [#192](https://github.com/google-research/dex-lang/issues/192) | Add more number types | — | Limited numeric type support |
| [#497](https://github.com/google-research/dex-lang/issues/497) | How to input a `Float64`? | language / concrete syntax | No Float64 literal syntax |
| [#496](https://github.com/google-research/dex-lang/issues/496) | Print floating-point values with high precision | — | Float output truncates precision |
| [#513](https://github.com/google-research/dex-lang/issues/513) | Can't define multiline `data` in REPL | bug, language / concrete syntax | REPL parses data definitions prematurely |
| [#309](https://github.com/google-research/dex-lang/issues/309) | Strided index sets | language / concrete syntax | No ergonomic way to select every N-th element |
| [#308](https://github.com/google-research/dex-lang/issues/308) | Feature Question: Record Subtyping | language / type system | Can't pass a record with extra fields where fewer are expected |
| [#967](https://github.com/google-research/dex-lang/issues/967) | Subset design | language / concrete syntax | Subset typeclass needs a redesign for correctness |
| [#1015](https://github.com/google-research/dex-lang/issues/1015) | Syntax for array-kinded type parameters in `data` | — | Type parameter expressiveness gap |
| [#1046](https://github.com/google-research/dex-lang/issues/1046) | Handling of Nat at the Jax-Dex boundary | — | Dex-JAX interop broken for `Nat` arguments |
| [#1059](https://github.com/google-research/dex-lang/issues/1059) | Building Dex on Fedora 36 (clang++-14) | — | Build doesn't work with newer clang versions |
| [#1063](https://github.com/google-research/dex-lang/issues/1063) | Finish numerics for Gaussian distributions | — | Incomplete standard library for statistics |
| [#1283](https://github.com/google-research/dex-lang/issues/1283) | Auto-cancellation of `ordinal . unsafe_from_ordinal` | — | Missing optimization causes unnecessary work in generated code |
| [#1310](https://github.com/google-research/dex-lang/issues/1310) | Adding support for sparse matrices/arrays? | — | No sparse data structure support |
| [#382](https://github.com/google-research/dex-lang/issues/382) | Fix `-Wnonportable-include-path` workaround | bug, maintenance | Build warning suppressed instead of properly fixed |
| [#373](https://github.com/google-research/dex-lang/issues/373) | Benchmarking should use minimum time, not mean | language / compiler | Benchmark methodology produces noisy results |
| [#1057](https://github.com/google-research/dex-lang/issues/1057) | Can't benchmark constructing an array of lists | — | `%bench` doesn't work with certain data structures |
| [#1331](https://github.com/google-research/dex-lang/issues/1331) | Why doesn't `rlwrap` work with `dex repl`? | — | Standard REPL wrapper tool doesn't work |

### Backend / Optimization (P2)

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#418](https://github.com/google-research/dex-lang/issues/418) | Modify arrays in-place whenever possible | backend / optimization | Major performance opportunity — array reuse |
| [#417](https://github.com/google-research/dex-lang/issues/417) | Tile matmul-like and transpose-like loops | backend / optimization | Cache efficiency for core linear algebra |
| [#416](https://github.com/google-research/dex-lang/issues/416) | Automatic vectorization | backend / CPU | LLVM auto-vectorization insufficient — needs explicit passes |
| [#423](https://github.com/google-research/dex-lang/issues/423) | Loop/For-invariant code motion | backend / optimization | Hoist loop-independent code for performance |
| [#422](https://github.com/google-research/dex-lang/issues/422) | Improve CUDA allocation lifting | backend / GPU | GPU allocation only works for statically-known sizes |
| [#419](https://github.com/google-research/dex-lang/issues/419) | Allocation coalescing and hoisting | backend / optimization | Reduce allocator overhead in tight loops |
| [#415](https://github.com/google-research/dex-lang/issues/415) | Optimize sum-type storage | backend / optimization, shovel-ready | Sum types waste ~2.5x storage |

---

## P3 — Low (Nice-to-haves, minor improvements)

Features and improvements that would be nice but don't block core workflows.

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#1144](https://github.com/google-research/dex-lang/issues/1144) | Add syntax for "the previous value" | good first issue, language / concrete syntax, shovel-ready | Syntactic sugar convenience |
| [#1154](https://github.com/google-research/dex-lang/issues/1154) | Add a primitive to inhibit constant folding | good first issue | Testing infrastructure improvement |
| [#1149](https://github.com/google-research/dex-lang/issues/1149) | `with_` better names | libraries | Naming consistency discussion |
| [#1157](https://github.com/google-research/dex-lang/issues/1157) | Simplex demo doesn't work anymore | — | Demo broken by syntax changes; needs mechanical fix |
| [#300](https://github.com/google-research/dex-lang/issues/300) | Chained Comparators: `a < b < c` | — | Syntactic sugar for chained comparisons |
| [#99](https://github.com/google-research/dex-lang/issues/99) | Dex support in Jupyter notebooks | python | Jupyter kernel for Dex |
| [#176](https://github.com/google-research/dex-lang/issues/176) | Portable regex-based syntax highlighting | good first issue, tooling / editors | Editor syntax highlighting definitions |
| [#332](https://github.com/google-research/dex-lang/issues/332) | Associative Map (dictionary data structure) | examples | Request for a hash-map implementation |
| [#1304](https://github.com/google-research/dex-lang/issues/1304) | Tooltips in notebook | tooling / notebooks | Show expression types on hover |
| [#412](https://github.com/google-research/dex-lang/issues/412) | Make the notebook interactive | tooling / notebooks | Add sliders/dropdowns to notebooks |
| [#411](https://github.com/google-research/dex-lang/issues/411) | Make it possible to collapse notebook cells | tooling / notebooks | UI improvement for long notebooks |
| [#410](https://github.com/google-research/dex-lang/issues/410) | Reimplement cell result caching in notebook mode | tooling / notebooks | Re-enable disabled caching |
| [#421](https://github.com/google-research/dex-lang/issues/421) | Provide visual feedback on evaluation progress | tooling / notebooks | Show evaluation status per cell |

### Open PRs awaiting review/merge (P3)

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#1342](https://github.com/google-research/dex-lang/issues/1342) | `make install` failing after TypeScript transition | — | Build fix PR |
| [#1343](https://github.com/google-research/dex-lang/issues/1343) | Fix debug build missing conditional import | — | Build fix PR |
| [#1344](https://github.com/google-research/dex-lang/issues/1344) | Implement `erfinv` for `Float32` and `Float64` | — | Math library PR |
| [#1323](https://github.com/google-research/dex-lang/issues/1323) | Make a `BinderAndDecls` data type | — | Preparatory refactor PR |
| [#1293](https://github.com/google-research/dex-lang/issues/1293) | Automatic derivation of instances | — | Feature PR |
| [#1337](https://github.com/google-research/dex-lang/issues/1337) | Add Futhark IR module | — | Experimental feature PR |
| [#1335](https://github.com/google-research/dex-lang/issues/1335) | Add multisets | — | Library PR |
| [#1332](https://github.com/google-research/dex-lang/issues/1332) | Add Multivariate Normal distribution | — | Stats library PR |
| [#1271](https://github.com/google-research/dex-lang/issues/1271) | WIP: printing tables aligned by columns | — | Formatting PR |
| [#1348](https://github.com/google-research/dex-lang/issues/1348) | Got sets working with new syntax | — | Syntax migration PR |
| [#1347](https://github.com/google-research/dex-lang/issues/1347) | Got FFT working again with new syntax | — | Syntax migration PR |
| [#1093](https://github.com/google-research/dex-lang/issues/1093) | Educational: built-in `map` primitive | — | Educational/experimental (DO NOT MERGE) |
| [#603](https://github.com/google-research/dex-lang/issues/603) | Speech processing MFCC demo | cla: yes | Example/demo PR |

---

## P4 — Wishlist (Demos, discussions, bikesheds)

Low-stakes items: naming discussions, example contributions, and speculative ideas.

| # | Title | Labels | Rationale |
|---|-------|--------|-----------|
| [#396](https://github.com/google-research/dex-lang/issues/396) | Convention: should type-class names be adjectives? | discussion | Naming bikeshed |
| [#397](https://github.com/google-research/dex-lang/issues/397) | RFC: make print polymorphic and fluent | cla: yes | Small ergonomic RFC |
| [#395](https://github.com/google-research/dex-lang/issues/395) | Relational Algebra example | cla: yes | WIP example contribution |
| [#343](https://github.com/google-research/dex-lang/issues/343) | Associative Map Example | cla: yes | WIP example PR |
| [#274](https://github.com/google-research/dex-lang/issues/274) | Caustic rendering demo | cla: yes | Example/demo PR |
| [#294](https://github.com/google-research/dex-lang/issues/294) | Add AffProp clustering example | cla: yes | Example/demo PR |
| [#1349](https://github.com/google-research/dex-lang/issues/1349) | Dex (inDEX) lang | — | No description; unclear purpose |

---

## Summary

| Priority | Count | Description |
|----------|-------|-------------|
| **P0 — Critical** | 7 | Compiler crashes, wrong results, broken builds |
| **P1 — High** | 18 | Core language gaps, platform support, install blockers |
| **P2 — Medium** | 31 | Language enhancements, moderate bugs, optimizations |
| **P3 — Low** | 26 | Nice-to-haves, notebook polish, open PRs |
| **P4 — Wishlist** | 7 | Examples, discussions, naming |
| **Total open** | **89** | |

---

## Pairwise Comparison Notes (Priority Sorting Rationale)

Within each priority group, issues were compared pairwise and sorted by the following criteria:

### P0 Internal Sort
1. **#1278 > #1211**: Regressions from LLVM 15 block an entire upgrade path (multiple tests segfault) vs. a single wrong-result bug in `rem`.
2. **#1211 > #1019**: Wrong results silently corrupt data vs. a crash (at least a crash is visible).
3. **#1019 > #1333**: Higher AD with sum types is a more common pattern than struct-field table indexing.
4. **#1333 > #310**: Struct fields are core language; notebook `#` is a specific parser edge case.
5. **#310 > #1345**: Notebook crash blocks users visibly; `Float64` negation has a workaround (cast to `Float32`).
6. **#1345 > #1033**: Negation is more commonly needed than complex `pow` at zero.

### P1 Internal Sort
1. **#1264 > #331**: LLVM 15 / M1 support affects all Apple users immediately vs. recursive ADTs being a language design choice.
2. **#331 > #1338**: Recursive types enable a class of data structures; function-in-struct is a specific pattern.
3. **#1338 > #710**: Functions in data types are a common ask; unreduced type applications are more niche.
4. **#710 > #1141**: Unreduced applications block existing code; associated types are a new feature.
5. **#1141 > #1139**: Associated types are a bigger feature; role enforcement is an invariant cleanup.
6. **#621 > #258**: Higher-kinded types enable more abstractions than record-field polymorphism.
7. **#258 > #239**: Record polymorphism is more commonly needed than dependent `!`.
8. **#323 > #340**: Sibling method references are a basic expectation; overlapping instances is advanced.
9. **#302 > #174**: Unicode is a basic modern expectation; stack traces improve DX but aren't blocking.
10. **#371 > #1247 > #1248 > #521**: Self-contained packages help the most users; then M1, then Nix, then ARM Linux (by user base size).

### P2 Internal Sort
1. **#1167 > #1267**: REPL variable redefinition blocks interactive workflows; operator mixup is confusing but has workarounds.
2. **#409 > #307**: Topological sort removes a major ergonomic burden; nested patterns are less commonly needed.
3. **#334 > #338**: Serialization enables practical workflows; shadowing warnings prevent subtle bugs.
4. **#413 > #192**: Warning infrastructure is a prerequisite for many improvements; more number types is additive.
5. Optimization issues (#418 > #417 > #416 > #423 > #422 > #419 > #415): In-place arrays have the broadest performance impact; then tiling; then vectorization; then LICM; then GPU alloc; then coalescing; then sum-type storage.
