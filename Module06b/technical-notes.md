# Engine notes and provisional decision record

JSON experiment inserts the exact three course devices, rejects invalid JSON in STRICT storage, runs json_extract, ->> and json_each, and verifies equivalent Fanuc results. The expression index matches json_extract(meta,'$.vendor'); ->> uses a different expression. Actual plans are saved, so a future optimizer change need not be hidden.

The session workload precomputes the same 50,000 key/value pairs and validates every read. Three fresh stores are used per system. SQLite commits one batch; shelve syncs after its loop. Writes/reads are warm in the same process. Backend: dbm.sqlite3._Database. File sizes include every backend file. These timings compare APIs, not equivalent transaction/crash semantics: shelve uses pickled values and backend-specific durability, and untrusted shelf files must never be loaded. SQLite naturally returns the 12,500 sessions matching city 1 with a WHERE query; shelve would require a Python scan or a separately maintained index. No timestamps are stored, so “last week” cannot be inferred from this fixture.

| Workload | Provisional engine | Evidence | Cost accepted / stale copy |
|---|---|---|---|
| Sensor/job ingest | SQLite | Module04 rejection/replay tests; 6a boundary | One writer; keep authoritative data current; backup and durability policy needed |
| Historical report | DuckDB over Parquet | Module06a actual medians/plans | Snapshot refresh and stale-report risk |
| Evolving metadata | SQLite JSON | Current JSON validity, results and expression plans | Application validates business fields; different path expressions may miss index |
| Dashboard sessions | SQLite provisionally | Four session timings in results.json, cross-session query | Indexed keys, transaction batch; capacity/expiry requirements still needed |
| Concurrent network clients (optional) | PostgreSQL candidate | Not observed | BLOCKED BY MISSING INFRASTRUCTURE; no performance claim |

**If Kortmann could run only one engine, which would it be — and what would break first?** Provisional engineering recommendation: SQLite preserves transactional truth and JSON flexibility; the full-history analytical latency would be the first measured compromise. This is AI-prepared technical advice, not the student's defended choice. [STUDENT INPUT REQUIRED: Your choice, defence, peer challenge, changed row and reason.]

ACID means atomicity (all or none), consistency (declared invariants maintained), isolation (controlled interleavings), durability (acknowledged commits survive within configured storage guarantees). Our rollback/replay/constraint tests demonstrate some of these behaviours, not power-loss durability. BASE describes designs accepting soft state/eventual convergence for availability; shelve is not evidence of eventual consistency merely because it is key-value. CAP concerns linearizable consistency versus availability during a network partition in a distributed service; “pick two” without that condition is misleading. A single local database does not experience a distributed replica partition, but can still fail and contend. PostgreSQL alone is not automatically a CP/AP replicated deployment.

Server procedure: use the instructor browser URL and assigned role/database; confirm host, port, user, database and TLS requirements. Execute [server.sql](server.sql) once in a fresh assigned schema; coordinate two sessions as annotated, rolling back afterward. Record blocking/timeout and the instructor shutdown's actual error. Do not store credentials. [STUDENT INPUT REQUIRED: What became easier? What became harder? Which new failure occurred?] This SQL is prepared but not executed; no PostgreSQL installation/credentials were available and no server observation is claimed.
