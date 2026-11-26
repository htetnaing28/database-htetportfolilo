# Verification and reproducibility

Existing telemetry, SQL reports, shell output and Datasette screenshots were preserved. Read-only re-execution verifies three machines × 57,600 rows, peaks and 11,714 alarms above 2 mm/s. Evidence records new timings separately from the student's earlier timings; these are not interchangeable measurements.

`rebuild.py` executes the unchanged deterministic generator into a new artifact directory, creates a separate SQLite database and checks 172,800 rows. Run `.\.venv\Scripts\python.exe -B Module01/rebuild.py`. The original load_telemetry.py drops its readings table: use the safe rebuild for reproduction instead. The generated data is simulated, as the specification permits.

The existing AI query selected strictly after 18:00; it omitted after-midnight rows. The comparison reproduces both versions; the boundary regression test makes the strict inequalities explicit. A shift including 18:00 needs >= instead. All dynamic alarm thresholds use parameters. An embedded file removes the network service dependency, but filesystem failure, corruption and writer contention still exist.

Core setup/queries are verified locally. Prior UI screenshots are preserved, not newly recreated. SQL Island, profile/expectations, collaborator invitations and pod/Git demonstrations require actual student action; no Git operations were performed. Optional Datasette tasks remain existing evidence, not freshly observed UI sessions.
