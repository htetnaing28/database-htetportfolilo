
# Module 01 — Task 6: Telemetry and SQLite

## 1. Introduction

In this task, I generated simulated telemetry data for three CNC machines and stored the readings in a SQLite database using Python.

The purpose was to learn how to generate data, load CSV files into a database, and use SQL queries to analyse machine performance.

## 2. Dataset Information

- Machines: cnc-01, cnc-02, cnc-03
- Duration: 2 days
- Measurement interval: 3 seconds per machine
- Total readings: 172,800
- CSV file: telemetry.csv
- SQLite database: telemetry.db
- Database size: 10,526,720 bytes (10.53 MB)

## 3. SQL Query 1 — Readings Per Machine

Question: How many readings were recorded for each machine?

```sql
SELECT machine, COUNT(*) AS n
FROM readings
GROUP BY machine;
```

### Results

| Machine | Readings |
|---|---:|
| cnc-01 | 57,600 |
| cnc-02 | 57,600 |
| cnc-03 | 57,600 |

Execution time: 102.935 ms

Explanation: Each machine recorded 57,600 readings over two days.

## 4. SQL Query 2 — Maximum Vibration

Question: What was the maximum vibration recorded for each machine?

```sql
SELECT machine, MAX(vib_rms) AS peak_vib
FROM readings
GROUP BY machine;
```

### Results

| Machine | Maximum vibration (mm/s) |
|---|---:|
| cnc-01 | 2.398 |
| cnc-02 | 3.168 |
| cnc-03 | 2.550 |

Execution time: 135.116 ms

Explanation: cnc-02 had the highest vibration, which is consistent with the simulated bearing wear.

## 5. SQL Query 3 — Vibration Alarms

Question: How many readings exceeded the vibration threshold of 2.0 mm/s?

```sql
SELECT COUNT(*) AS alarm_count
FROM readings
WHERE vib_rms > 2.0;
```

### Result

Alarm count: 11,714 readings

Execution time: 29.978 ms

Explanation: 11,714 readings exceeded the vibration alarm threshold.

## 6. Embedded Database vs Cloud

SQLite is an embedded database, which means it runs directly inside an application without requiring a separate database server.

For this task, the database stored 172,800 readings in approximately 10.53 MB.

Running this dataset locally has no cloud hosting cost. If it were hosted in the cloud, the cost would depend on the provider, storage, compute resources, and network usage. The organisation operating the system would normally pay those costs.

## 7. What I Learned

From this task, I learned how to:

- Generate machine telemetry using Python.
- Save data in CSV format.
- Load CSV data into a SQLite database.
- Use SELECT, COUNT, MAX, WHERE, and GROUP BY.
- Analyse machine vibration and identify alarm readings.
- Measure SQL query execution times using Datasette.
- Understand why an embedded database can be useful for small local applications.
