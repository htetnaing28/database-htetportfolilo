"""Run the Module 03 reproducible local experiments."""
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
from portfolio import run
if __name__ == "__main__":
    run("03")
