"""
Contract tests for mutil.scad pure functions.

These tests verify that utility functions honor their documented contracts:
- Input/output types and formats are consistent
- Conversions are mathematically correct
- Edge cases are handled as documented

Contract tests use assertions within OpenSCAD itself.
OpenSCAD will fail with a non-zero exit code if any assert() fails.
"""
import pytest
from pathlib import Path
import subprocess
import tempfile
import os


ROOT = Path(__file__).resolve().parents[1]


def execute_openscad_code(scad_code):
    """
    Execute OpenSCAD code. Success means the script completed with exit code 0.
    Failure means OpenSCAD returned non-zero (assertions failed or parse error).
    
    We use assertions within OpenSCAD code rather than echo() parsing,
    which avoids GUI/display issues.
    
    Temp files are created in the tests directory to allow relative includes to work.
    """
    with tempfile.NamedTemporaryFile(
        mode='w', suffix='.scad', delete=False, dir=ROOT
    ) as f:
        f.write(scad_code)
        temp_file = f.name
    
    try:
        with tempfile.NamedTemporaryFile(
            suffix='.stl', delete=False, dir=ROOT
        ) as out:
            output_file = out.name
        
        env = os.environ.copy()
        # Try headless mode, but OpenSCAD 2019.05 may ignore it
        env["QT_QPA_PLATFORM"] = "offscreen"
        
        result = subprocess.run(
            ["openscad", "-o", output_file, temp_file],
            cwd=ROOT,
            capture_output=True,
            text=True,
            timeout=10,
            env=env
        )
        return result.stdout, result.stderr, result.returncode
    finally:
        Path(temp_file).unlink()
        if Path(output_file).exists():
            Path(output_file).unlink()


class TestMutil3Contract:
    """
    Contract: mlist3(v) converts a scalar or list to a 3-element list.
    
    - mlist3(5) => [5, 5, 5]
    - mlist3([1, 2, 3]) => [1, 2, 3]
    """
    
    def test_mlist3_scalar_input(self):
        """Scalar input should be replicated across all 3 dimensions."""
        scad_code = """
include <mutil.scad>
result = mlist3(5);
assert(result[0] == 5, "mlist3(5)[0] should be 5");
assert(result[1] == 5, "mlist3(5)[1] should be 5");
assert(result[2] == 5, "mlist3(5)[2] should be 5");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"mlist3 scalar contract failed:\n{stderr}"
    
    def test_mlist3_list_input(self):
        """List input should be passed through unchanged."""
        scad_code = """
include <mutil.scad>
result = mlist3([1, 2, 3]);
assert(result[0] == 1, "mlist3([1,2,3])[0] should be 1");
assert(result[1] == 2, "mlist3([1,2,3])[1] should be 2");
assert(result[2] == 3, "mlist3([1,2,3])[2] should be 3");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"mlist3 list contract failed:\n{stderr}"
    
    def test_mlist3_zero(self):
        """Zero should be replicated like any other scalar."""
        scad_code = """
include <mutil.scad>
result = mlist3(0);
assert(result[0] == 0, "mlist3(0)[0] should be 0");
assert(result[1] == 0, "mlist3(0)[1] should be 0");
assert(result[2] == 0, "mlist3(0)[2] should be 0");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"mlist3 zero contract failed:\n{stderr}"


class TestUnitConversionContract:
    """
    Contract: mm and inch conversions are inverses and mathematically correct.
    
    - mm2i(25.4) ≈ 1.0
    - i2mm(1.0) = 25.4
    - mm2i(i2mm(x)) ≈ x (within floating point precision)
    """
    
    def test_mm2i_standard(self):
        """25.4 mm should convert to 1 inch."""
        scad_code = """
include <mutil.scad>
result = mm2i(25.4);
assert(result > 0.99 && result < 1.01, "mm2i(25.4) should be approximately 1.0");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"mm2i standard contract failed:\n{stderr}"
    
    def test_i2mm_standard(self):
        """1 inch should convert to 25.4 mm."""
        scad_code = """
include <mutil.scad>
result = i2mm(1);
assert(result > 25.39 && result < 25.41, "i2mm(1) should be approximately 25.4");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"i2mm standard contract failed:\n{stderr}"
    
    def test_mm2i_i2mm_roundtrip(self):
        """Conversions should be reversible."""
        scad_code = """
include <mutil.scad>
original = 50;
roundtrip = mm2i(i2mm(original));
assert(roundtrip > 49.99 && roundtrip < 50.01, 
       "mm2i(i2mm(50)) should be approximately 50");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"roundtrip conversion failed:\n{stderr}"


class TestPrecisionContract:
    """
    Contract: mprecision(value, precision) rounds to N decimal places.
    
    - mprecision(3.14159, 2) ≈ 3.14
    - mprecision(3.5, 0) = 4 (standard rounding)
    """
    
    def test_mprecision_two_decimals(self):
        """Should round to 2 decimal places."""
        scad_code = """
include <mutil.scad>
result = mprecision(3.14159, 2);
assert(result > 3.139 && result < 3.141, 
       "mprecision(3.14159, 2) should be approximately 3.14");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"mprecision two-decimal contract failed:\n{stderr}"
    
    def test_mprecision_zero_decimals(self):
        """Should round to integer."""
        scad_code = """
include <mutil.scad>
result = mprecision(3.7, 0);
assert(result == 4, "mprecision(3.7, 0) should be 4 (rounded from 3.7)");
// Dummy object to ensure OpenSCAD generates output
cube([0.001, 0.001, 0.001]);
"""
        stdout, stderr, code = execute_openscad_code(scad_code)
        assert code == 0, f"mprecision zero-decimal contract failed:\n{stderr}"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
