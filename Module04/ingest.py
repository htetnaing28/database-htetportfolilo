"""Replay the supplied CSV into an explicitly selected generated edge database."""
from pathlib import Path
import argparse
import sqlite3
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from portfolio import ingest, ROOT

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('database',type=Path)
    parser.add_argument('--csv',type=Path,default=Path(__file__).with_name('readings.csv'))
    args=parser.parse_args()
    path=args.database.resolve()
    if not path.is_relative_to(ROOT/'Module04/artifacts') or not path.is_file():
        parser.error('Choose an existing edge.db under Module04/artifacts; run run.py first.')
    with sqlite3.connect(path) as con:
        con.execute('PRAGMA foreign_keys=ON')
        ingest(con,args.csv)
        print('Rows:',con.execute('SELECT COUNT(*) FROM reading').fetchone()[0])
