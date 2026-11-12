
"""Load telemetry.csv into a SQLite database."""

import csv
import sqlite3
from pathlib import Path

# Find the CSV file and database location
here = Path(__file__).parent
csv_path = here / "telemetry.csv"
db_path = here / "telemetry.db"

# Connect to SQLite database
conn = sqlite3.connect(db_path)

# Create a table to store machine readings
conn.executescript("""
    DROP TABLE IF EXISTS readings;

    CREATE TABLE readings (
        ts           TEXT NOT NULL,
        machine      TEXT NOT NULL,
        temp_c       REAL NOT NULL,
        vib_rms      REAL NOT NULL,
        spindle_load REAL NOT NULL
    );
""")

# Read the CSV file and insert data into SQLite
with csv_path.open(newline="") as f:
    rows = csv.reader(f)
    next(rows)  # Skip the CSV header

    conn.executemany(
        "INSERT INTO readings VALUES (?, ?, ?, ?, ?)",
        rows
    )

# Save the changes
conn.commit()

# Count the inserted readings
n = conn.execute(
    "SELECT COUNT(*) FROM readings"
).fetchone()[0]

print(f"loaded {n} rows into {db_path}")

# Close the database connection
conn.close()
