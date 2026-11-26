# Module 05 — Normalization versus Denormalization: verified technical work

Authority: [local specification](../Course_Materials/Course_Materials/05-normalization-vs-denormalization.md); [syllabus](../Course_Materials/Course_Materials/syllabus.md). Learning goals are the assessment contract; lab text below each draft boundary is provisional. Optional stretchers are not mandatory. This supplement was prepared with AI and verified through local execution; it does not claim student participation.

Run from the repository root in PowerShell:

```powershell
.\.venv\Scripts\python.exe -B Module05/run.py
```

With uv available, the equivalent is `uv run --frozen python Module05/run.py`. The checked existing environment has Python 3.14.10 and SQLite 3.53.1. Dependencies remain as locked in pyproject.toml/uv.lock; no installation or lock changes were needed. Paths resolve relative to the source files, independently of the working directory. Each run creates a fresh ignored artifacts/run-* directory and publishes evidence only after assertions pass. Repeated runs preserve previous databases.

Outputs: [actual results and raw samples](evidence/results.json), [latest artifact location](evidence/latest.json), and [technical notes](technical-notes.md). Result JSON contains actual SQL, parameters, query plans, errors and measurements as applicable. Small evidence files are intended for review; large generated data is ignored. Timings are machine/cache/workload dependent, not production guarantees.

Validation: the runner asserts row counts and experiment-specific correctness and runs SQLite integrity/foreign-key checks. Regression suite: `.\.venv\Scripts\python.exe -B -m unittest discover -s tests -v`.

Student work: [logbook](../Reflections/ref05.md). [STUDENT INPUT REQUIRED: Enter actual participation, personal reasoning, difficulties, learning-goal self-assessment, harvest questions, feedback and peer defence.] Technical notes describe experiments, not your experience.
