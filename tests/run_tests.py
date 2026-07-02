#!/usr/bin/env python3
import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_TEST_DIRS = [ROOT / "tests" / "unit", ROOT / "tests" / "system"]


def discover_tests(test_dirs):
    test_files = []
    for test_dir in test_dirs:
        if test_dir.exists():
            test_files.extend(sorted(test_dir.glob("test_*.scad")))
    return test_files


def main():
    parser = argparse.ArgumentParser(description="Run libmose OpenSCAD tests")
    parser.add_argument("--openscad", default=os.environ.get("OPENSCAD", "openscad"))
    args = parser.parse_args()

    openscad = shutil.which(args.openscad) or args.openscad
    if not openscad:
        print("OpenSCAD executable not found", file=sys.stderr)
        return 2

    test_files = discover_tests(DEFAULT_TEST_DIRS)
    if not test_files:
        print("No test files found", file=sys.stderr)
        return 2

    failures = 0
    with tempfile.TemporaryDirectory(prefix="libmose-tests-", dir=str(ROOT / "tests")) as tmpdir:
        for test_file in test_files:
            output_path = Path(tmpdir) / f"{test_file.stem}.stl"
            command = [openscad, "-o", str(output_path), str(test_file)]
            result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True)
            status = "PASS" if result.returncode == 0 else "FAIL"
            rel_path = test_file.relative_to(ROOT)
            print(f"[{status}] {rel_path}")
            if result.stdout:
                print(result.stdout, end="")
            if result.stderr:
                print(result.stderr, end="", file=sys.stderr)
            if result.returncode != 0:
                failures += 1

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
