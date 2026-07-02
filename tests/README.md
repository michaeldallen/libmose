# Test strategy

This project uses OpenSCAD itself as the execution engine for tests.

## Conventions

- Put pure logic and parameter-contract checks in tests/unit with names matching test_*.scad.
- Put render/smoke coverage in tests/system with names matching test_*.scad.
- Prefer small, explicit assertions over large end-to-end examples.
- Keep each test file focused on one behavior or one module.

## Running tests

```bash
python3 tests/run_tests.py
```

A test passes when the OpenSCAD file exits successfully. A failure is surfaced immediately with the OpenSCAD error output.
