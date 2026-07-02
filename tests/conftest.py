"""
Shared pytest fixtures and utilities for contract testing.
"""
import subprocess
import tempfile
from pathlib import Path
import json
import os


ROOT = Path(__file__).resolve().parents[1]


def execute_openscad_snippet(scad_code, openscad_exe="openscad"):
    """
    Execute a snippet of OpenSCAD code and return stdout.
    
    The code should use echo() to output values that will be captured.
    Runs in headless mode (no GUI/display server needed).
    """
    with tempfile.NamedTemporaryFile(mode='w', suffix='.scad', delete=False) as f:
        f.write(scad_code)
        temp_file = f.name
    
    try:
        env = os.environ.copy()
        env["QT_QPA_PLATFORM"] = "offscreen"
        result = subprocess.run(
            [openscad_exe, temp_file],
            cwd=ROOT,
            capture_output=True,
            text=True,
            timeout=10,
            env=env
        )
        return result.stdout, result.stderr, result.returncode
    finally:
        Path(temp_file).unlink()


def parse_echo_output(output):
    """
    Parse OpenSCAD echo() output into Python values.
    
    OpenSCAD echo format: "ECHO: [value]"
    """
    lines = output.strip().split('\n')
    values = []
    for line in lines:
        if line.startswith('ECHO:'):
            # Extract the value after "ECHO: "
            value_str = line[6:].strip()
            values.append(value_str)
    return values


class OpenSCADContract:
    """
    Helper class to define and test a contract for an OpenSCAD function.
    """
    
    def __init__(self, function_name, function_source):
        self.function_name = function_name
        self.function_source = function_source
    
    def test_case(self, input_args, expected_output):
        """
        Define a single test case for this function.
        
        Returns a pytest-compatible test function.
        """
        def test_func():
            scad_code = f"""
include <{self.function_source}>
echo({self.function_name}({input_args}));
"""
            stdout, stderr, returncode = execute_openscad_snippet(scad_code)
            assert returncode == 0, f"OpenSCAD execution failed: {stderr}"
            
            values = parse_echo_output(stdout)
            assert len(values) > 0, f"No output captured from OpenSCAD"
            
            # Parse the output value
            actual = values[0]
            assert actual == str(expected_output), \
                f"Expected {expected_output}, got {actual}"
        
        return test_func
