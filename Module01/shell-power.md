
# Task 9 — SQLite Shell Power Moves

## 1. Introduction

In this task, I explored the SQLite command-line interface (CLI) using my telemetry database.

Database: `Module01/telemetry.db`

## 2. SQLite Shell Commands

I used the following commands:

| Command | Purpose |
|---|---|
| `.tables` | Show all tables in the database |
| `.schema readings` | Display the structure of the readings table |
| `.mode box` | Display results as a formatted table |
| `.mode json` | Display results in JSON format |
| `.mode markdown` | Display results as a Markdown table |
| `.mode insert readings` | Generate SQL INSERT statements |
| `.once Module01/result.json` | Save the next query result to a JSON file |

## 3. SQL Query

I tested the following query:

```sql
SELECT * FROM readings LIMIT 5;
```

This query displays the first five rows from the readings table.

## 4. Exporting Results

I used `.mode json` and `.once` to export five rows from the telemetry database.

[View exported JSON](./result.json)

## 5. What I Learned

- SQLite supports several output formats.
- Box mode makes SQL results easier to read.
- JSON mode is useful for exchanging data with applications.
- Markdown mode is useful for GitHub documentation.
- INSERT mode generates SQL statements from query results.
- The `.once` command saves the next query result to a file.

## 6. Interesting Finding

I discovered that SQLite can turn existing database rows into SQL INSERT statements without manually writing them.

I also learned that the same SQL query can produce different output formats without changing the underlying data.
