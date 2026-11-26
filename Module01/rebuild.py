"""Rebuild telemetry in a fresh artifact directory, never the original DB/CSV."""
from pathlib import Path
from datetime import datetime, timezone
import runpy
import sqlite3
import sys
import csv


def rebuild():
    here = Path(__file__).resolve().parent
    out = here / 'artifacts' / ('rebuild-' + datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
    out.mkdir(parents=True)
    # Execute the unchanged original generator with __file__ directed into scratch.
    source = (here / 'generate_telemetry.py').read_text(encoding='utf-8-sig')
    exec(compile(source, str(here / 'generate_telemetry.py'), 'exec'), {'__file__':str(out / 'generate_telemetry.py'),'__name__':'__main__'})
    with sqlite3.connect(out / 'telemetry.db') as con:
        con.execute('CREATE TABLE readings(ts TEXT NOT NULL,machine TEXT NOT NULL,temp_c REAL NOT NULL,vib_rms REAL NOT NULL,spindle_load REAL NOT NULL)')
        with (out / 'telemetry.csv').open(newline='') as stream:
            rows=csv.reader(stream);next(rows)
            con.executemany('INSERT INTO readings VALUES(?,?,?,?,?)',rows)
        con.commit()
        assert con.execute('SELECT COUNT(*) FROM readings').fetchone()[0]==172800
        print(con.execute('SELECT COUNT(*) FROM readings WHERE vib_rms>?',(2.0,)).fetchone())
    print(out)


if __name__=='__main__':
    rebuild()
