# Proposed Test Plan

## Goal

Create a regression-oriented test strategy for the OpenSCAD library that is strong enough to support a major refactoring, while remaining easy to understand and maintain for a solo author and for junior engineers.

The strategy should be incremental: start with the highest value tests first, then expand coverage as the library grows.

---

## Principles

1. Prefer tests that express behavior clearly over tests that are clever.
2. Favor small, focused tests that are easy to debug.
3. Use a layered approach:
   - contract tests for pure helpers
   - invariants for modules
   - a small golden-file layer for a few critical public cases
4. Keep the test harness simple enough that contributors can run it locally with one command.
5. Make failures actionable and easy to understand.

---

## Proposed Testing Layers

### 1. Contract tests for pure functions

These tests target helper logic that has deterministic input/output behavior.

Examples:
- value normalization
- list expansion
- rounding helpers
- unit conversion helpers

Why this layer matters:
- These are the fastest tests to write.
- They are easy to reason about.
- They protect core utility behavior during refactors.

Expected outcome:
- A change to a helper function must preserve its documented semantics.

### 2. Module invariants tests

These tests check that public modules still produce the expected geometric properties.

Examples:
- dimensions remain correct
- placement is centered correctly
- chamfered geometry still has the expected extent
- wall thickness remains consistent
- invalid parameter combinations still fail as expected

Why this layer matters:
- It protects the library’s public API without requiring brittle exact-output matching.
- It is a strong fit for OpenSCAD, where geometry semantics matter more than implementation details.

### 3. Render smoke tests

These tests ensure that a module can be parsed and rendered successfully.

Why this layer matters:
- It catches syntax regressions and broken includes.
- It protects against accidental breakage introduced during refactoring.

### 4. Golden-file regression tests for selected high-value cases

A small number of curated examples should be stored as expected artifacts for comparison.

These should be used only for the most important public modules and most important scenarios.

Examples:
- a simple cube with default settings
- a box with explicit center behavior
- a tube with chamfer enabled
- a cylinder with tapered shape

Why this layer matters:
- It provides a strong regression signal for visual/structural drift.
- It is particularly useful before and after large refactors.

Caution:
- Golden files should be limited to a small set of stable cases.
- They should not become the only testing mechanism.

---

## Suggested Test Structure

```text
tests/
  README.md
  run_tests.py
  unit/
    test_mutil.scad
  system/
    test_mcube_render.scad
  fixtures/
    golden/
      mcube_default.stl
      mbox_centered.stl
```

### Recommended conventions

- Use `test_*.scad` filenames for all test files.
- Group tests by purpose:
  - `tests/unit` for contract-style checks
  - `tests/system` for render and geometry-oriented checks
  - `tests/fixtures` for golden artifacts and reusable inputs
- Keep each test file focused on one behavior or one module.
- Prefer naming tests by behavior, not by implementation detail.

---

## Incremental Adoption Plan

### Phase 1 — Establish the baseline

Focus on the parts of the library that are easiest to test and most central to correctness.

Tasks:
- Create a simple test runner that executes OpenSCAD test scripts.
- Add contract tests for helper functions in the utility module.
- Add one render smoke test for each main module file.
- Add a single documented workflow for running tests locally.

Success criteria:
- A developer can run one command and get a clear pass/fail report.
- The suite is fast and easy to understand.

### Phase 2 — Cover the public API

Add tests for the public modules that developers are most likely to use directly.

Priority order:
1. utility functions and shared helpers
2. simple primitives like cube and cylinder wrappers
3. box and tube-style modules
4. more complex composition modules

For each module, define a small set of representative scenarios:
- default settings
- centered vs non-centered behavior
- explicit size parameters
- edge cases such as zero or very small values

Success criteria:
- The test suite covers the primary public entry points.
- Refactoring a module is unlikely to go unnoticed.

### Phase 3 — Add geometric invariants

Move from “does it render?” to “does it still behave correctly?”

Examples:
- verify bounding box dimensions
- verify whether the object is centered at the expected location
- verify approximate volume
- verify that a chamfered shape still preserves its intended overall size

This phase is important because it makes the tests more meaningful than simple rendering checks.

Success criteria:
- A change that preserves renderability but alters semantics is caught.

### Phase 4 — Add a small golden-file suite

Introduce golden comparison selectively.

Recommended approach:
- Begin with 3 to 5 curated examples only.
- Store the expected artifact in the repository.
- Compare against new output using a normalized comparison strategy if possible.

Success criteria:
- The library has a small but meaningful regression snapshot suite.
- Golden files are easy to update when the behavior intentionally changes.

### Phase 5 — Strengthen and document maintenance practices

At this stage, the test infrastructure becomes part of the development workflow rather than a one-time addition.

Tasks:
- Document how to add a new test
- Document how to update a golden file intentionally
- Encourage TDD for new features and bug fixes
- Add a short “what to test” guide for contributors

Success criteria:
- New contributors can add tests without needing deep knowledge of the harness.

---

## Suggested Test Cases by File

### Utility helpers

For files such as `mutil.scad`:
- test scalar/list expansion
- test numeric rounding behavior
- test unit conversion behavior
- test invalid input handling where relevant

### Primitive wrappers

For files such as `mcube.scad` and `mcylinder.scad`:
- test default rendering
- test centered placement
- test explicit size behavior
- test chamfer behavior
- test invalid parameter combinations

### Composite modules

For files such as `mbox.scad` and `mtube.scad`:
- test default assembly behavior
- test open/closed side options
- test overlap/underlap behavior if relevant
- test center semantics
- test renderability under common parameter sets

---

## Suggested Test Design Patterns

### Pattern A — Assertion-based tests

Use this for pure helpers and simple contracts.

Example idea:
- if a helper converts a scalar into a three-element vector, assert the result shape and values.

### Pattern B — Invariant-based tests

Use this for geometry modules.

Example idea:
- after rendering a box, assert that the bounding box dimensions equal the requested dimensions.

### Pattern C — Smoke tests

Use this to ensure the file still compiles and renders.

Example idea:
- invoke the module with a representative set of arguments and ensure the OpenSCAD process exits successfully.

### Pattern D — Golden comparison

Use this sparingly for selected public examples.

Example idea:
- compare a stored STL or normalized mesh to the newly generated output for a known case.

---

## What to Avoid

1. Avoid making every test a full golden-file comparison.
2. Avoid overfitting tests to the exact mesh exporter output.
3. Avoid writing tests that are too implementation-specific.
4. Avoid large, monolithic test files that cover too many behaviors at once.
5. Avoid requiring special knowledge to add a simple regression test.

---

## Recommended Rollout Order

1. utility function contract tests
2. smoke tests for each module file
3. invariants for the main public modules
4. a small, curated golden-file set
5. contributor documentation and maintenance guidance

This order gives the best return on effort early and keeps the process understandable.

---

## Example Definition of Done

The testing approach can be considered mature when:

- every core module file has at least one smoke test
- every helper function with meaningful logic has at least one contract test
- at least one geometric invariant is tested for each major module
- there is a small golden-file regression layer for critical public cases
- running the tests is a normal part of local development and CI

---

## Final Recommendation

Adopt the testing strategy incrementally, starting with the simplest and most valuable tests first. The first milestone should be: “a developer can run one command and get confidence that the core library still behaves as expected after a refactor.”

That is a strong foundation for eventual production use without creating unnecessary complexity.
