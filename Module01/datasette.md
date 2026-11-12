
# Task 10 — Datasette: Filters, Facets, and JSON API

## 1. Introduction

In this task, I explored my SQLite telemetry database using Datasette.

- Database: `Module01/telemetry.db`
- Table: `readings`
- Total rows: 172,800
- Machines: cnc-01, cnc-02, cnc-03

I started Datasette using:

```powershell
uvx datasette Module01/telemetry.db -p 8002
```

## 2. Filtering Data

I filtered the readings table to display only cnc-02.

URL:

http://127.0.0.1:8002/telemetry/readings?machine=cnc-02

Result: 57,600 rows.

I learned that Datasette uses URL query parameters to filter records.

## 3. Faceting Data

I used a machine facet to count readings for each machine.

URL:

http://127.0.0.1:8002/telemetry/readings?_facet=machine

| Machine | Readings |
|---|---:|
| cnc-01 | 57,600 |
| cnc-02 | 57,600 |
| cnc-03 | 57,600 |

I discovered that all three machines have equal numbers of readings.

## 4. Running SQL Queries

I executed this SQL query in Datasette:

```sql
SELECT
    machine,
    ROUND(AVG(temp_c), 2) AS avg_temperature
FROM readings
GROUP BY machine
ORDER BY machine;
```

Results:

| Machine | Average temperature |
|---|---:|
| cnc-01 | 42.04 °C |
| cnc-02 | 42.04 °C |
| cnc-03 | 42.04 °C |

All three machines have the same average temperature when rounded to two decimal places.

## 5. JSON API

I accessed the readings table through Datasette's JSON API.

Table API:

http://127.0.0.1:8002/telemetry/readings.json?_size=5

I also accessed my SQL query results as JSON.

Query API:

http://127.0.0.1:8002/telemetry.json?sql=SELECT%20machine%2C%20ROUND%28AVG%28temp_c%29%2C%202%29%20AS%20avg_temperature%20FROM%20readings%20GROUP%20BY%20machine%20ORDER%20BY%20machine

These URLs work while my local Datasette server is running.

## 6. Exporting Data

I exported my SQL query results in two formats:

- [CSV query results](./datasette-query.csv)
- [JSON query results](./datasette-query.json)

CSV is useful for spreadsheets and data analysis.

JSON is useful for APIs and applications.

## 7. What I Learned

- Datasette provides a web interface for SQLite databases.
- Filters allow me to select specific records.
- Facets show counts for different values.
- SQL queries can be executed directly in the browser.
- Query results can be exported as CSV or JSON.
- Datasette provides a JSON API without requiring me to write a separate API server.

## 8. Reflection

I found Datasette easier for visually exploring data than using only the SQLite command-line interface.

The most interesting feature was the JSON API because the same database information can be accessed by both humans and computer programs.
