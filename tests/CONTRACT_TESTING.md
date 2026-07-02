# Contract Testing with Pytest

This directory contains pytest-based contract tests for validating OpenSCAD library interfaces.

## Why contract tests here?

Contract tests validate the "agreement" between the library and its consumers. They focus on:
- Input/output contracts (what do functions promise?)
- Behavioral invariants (do modules still produce expected results?)
- Data format consistency (are the schemas stable?)

Contract tests are **not** implementation tests — they don't care how you achieve the result, only that the contract is honored.

## Pattern: Bridge OpenSCAD to Pytest

Since OpenSCAD is not Python, the contract test pattern here:

1. **Define a test class** for each module or family of functions
2. **Use docstrings** to document the contract clearly
3. **Execute OpenSCAD code** via subprocess
4. **Parse echo() output** to validate the contract
5. **Assert behavior** in Python

Example:
```python
class TestMutil3Contract:
    """Contract: mlist3(v) converts scalars and lists to 3-element lists."""
    
    def test_mlist3_scalar_input(self):
        scad_code = 'include <mutil.scad>\necho(mlist3(5));'
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0
        values = extract_echo(stdout)
        assert "[5, 5, 5]" in values[0]
```

## Running the tests

```bash
# Run all pytest contract tests
pytest tests/test_contracts_*.py -v

# Run a specific contract test class
pytest tests/test_contracts_mutil.py::TestMutil3Contract -v

# Run one test
pytest tests/test_contracts_mutil.py::TestMutil3Contract::test_mlist3_scalar_input -v
```

## Adding a new contract test

1. Create a file `tests/test_contracts_<module>.py`
2. Define a test class for each logical group of functions
3. Use the class docstring to document the contract
4. Use test method docstrings to document individual cases
5. Follow this structure:
   - Use `execute_openscad_code()` to run OpenSCAD
   - Use `extract_echo()` to parse results
   - Assert on the parsed output

Example template:
```python
class TestMyFunctionContract:
    """
    Contract: myfunction(x) does X.
    - myfunction(input1) => expected1
    - myfunction(input2) => expected2
    """
    
    def test_basic_case(self):
        """Should handle basic input."""
        scad_code = 'include <mymodule.scad>\necho(myfunction(5));'
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"OpenSCAD failed: {stderr}"
        values = extract_echo(stdout)
        assert "expected_value" in values[0]
```

## What to test via contracts

Contract tests work best for:
- ✅ Pure functions with deterministic output
- ✅ Functions that return data you can inspect via `echo()`
- ✅ Functions with well-defined input/output formats
- ✅ Module parameters that affect output shape or dimensions

Contract tests are less suitable for:
- ❌ Geometric shapes that require visual inspection (use golden files instead)
- ❌ Module rendering (use smoke tests instead)
- ❌ Interactive behaviors

## Utilities in conftest.py

- `execute_openscad_code(scad_code)` — Run arbitrary OpenSCAD code
- `parse_echo_output(output)` — Extract ECHO values
- `OpenSCADContract` — Class helper for defining reusable contracts

## Integration with existing test harness

This pytest layer complements your existing OpenSCAD test harness:

| Test Type | Tool | When to use |
|-----------|------|------------|
| Contract tests (pure functions) | **pytest** (here) | Function input/output contracts |
| Module invariants | pytest or OpenSCAD | Module geometric properties |
| Render smoke tests | OpenSCAD (run_tests.py) | Syntax/parsing checks |
| Golden files | run_tests.py | Critical public cases |

