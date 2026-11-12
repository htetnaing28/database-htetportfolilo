# Task 7 — LLM-Assisted SQL Profiling

## 1. Prompt given to ChatGPT

Here is my SQLite table: `readings(ts TEXT, machine TEXT, temp_c REAL, vib_rms REAL, spindle_load REAL)`. Write a query that returns, for each machine, the average spindle load for readings taken overnight (after 18:00), ordered by average load descending.

## 2. AI-generated SQL

```sql
SELECT
    machine,
    AVG(spindle_load) AS avg_spindle_load
FROM readings
WHERE time(ts) > '18:00:00'
GROUP BY machine
ORDER BY avg_spindle_load DESC;
```

## 3. Execution results

The SQL executed successfully in Datasette without errors.

| Machine | Average spindle load |
|---|---:|
| cnc-03 | 60.4340 |
| cnc-01 | 60.3685 |
| cnc-02 | 60.3572 |

Execution time: 69.425 ms.

## 4. EXPLAIN QUERY PLAN

```sql
EXPLAIN QUERY PLAN
SELECT
    machine,
    AVG(spindle_load) AS avg_spindle_load
FROM readings
WHERE time(ts) > '18:00:00'
GROUP BY machine
ORDER BY avg_spindle_load DESC;
```

Results:

- `SCAN readings`
- `USE TEMP B-TREE FOR GROUP BY`
- `USE TEMP B-TREE FOR ORDER BY`

SQLite performed a full-table scan and used temporary B-trees for grouping and sorting.

## 5. Testing the query

I tested the meaning of overnight by changing the time condition to include readings after midnight.

```sql
SELECT
    machine,
    AVG(spindle_load) AS avg_spindle_load
FROM readings
WHERE time(ts) > '18:00:00'
   OR time(ts) < '06:00:00'
GROUP BY machine
ORDER BY avg_spindle_load DESC;
```

Corrected results:

| Machine | Average spindle load |
|---|---:|
| cnc-02 | 60.2060 |
| cnc-03 | 60.2029 |
| cnc-01 | 60.1856 |

Execution time: 123.316 ms.

## 6. Verification reflection

ChatGPT generated a valid SQL query using `AVG()`, `GROUP BY`, `ORDER BY`, and a time filter. The query ran successfully and returned three machine averages. However, I found that it only selected readings after 18:00 and excluded readings after midnight. This followed the literal prompt but did not fully represent an overnight shift. I tested a revised query that also included readings before 06:00 and found that both the average values and the machine ranking changed. I also used `EXPLAIN QUERY PLAN` and confirmed that SQLite scanned the readings table and used temporary B-trees. This taught me to check both the correctness and the meaning of AI-generated SQL.
