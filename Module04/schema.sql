PRAGMA foreign_keys = ON;        -- per-connection, and OFF by default: remember this.
DROP TABLE IF EXISTS audit;
DROP TABLE IF EXISTS alarm;
DROP TABLE IF EXISTS reading;
DROP TABLE IF EXISTS sensor;

CREATE TABLE sensor(
    sensor_id   INTEGER PRIMARY KEY,
    machine_id  TEXT    NOT NULL,
    metric      TEXT    NOT NULL CHECK (metric IN ('temp_c','vib_rms','spindle_load')),
    unit        TEXT    NOT NULL,
    UNIQUE (machine_id, metric)
) STRICT;

CREATE TABLE reading(
    reading_id  INTEGER PRIMARY KEY,
    sensor_id   INTEGER NOT NULL REFERENCES sensor(sensor_id),
    ts          TEXT    NOT NULL,
    value       REAL    NOT NULL,
    interval_s  INTEGER NOT NULL CHECK (interval_s > 0),
    energy_j    REAL    GENERATED ALWAYS AS (value * interval_s) VIRTUAL,
    CHECK (value >= -273.15 AND value <= 5000)        -- reject physically impossible values
) STRICT;
CREATE UNIQUE INDEX ux_reading_sensor_ts ON reading(sensor_id, ts);
CREATE TABLE alarm(
    alarm_id  INTEGER PRIMARY KEY,
    sensor_id INTEGER NOT NULL REFERENCES sensor(sensor_id),
    ts        TEXT NOT NULL,
    value     REAL NOT NULL,
    reason    TEXT NOT NULL
) STRICT;

CREATE TABLE audit(
    audit_id  INTEGER PRIMARY KEY,
    reading_id INTEGER NOT NULL,
    old_value REAL,
    new_value REAL,
    changed_at TEXT NOT NULL DEFAULT (datetime('now'))
) STRICT;

-- 1. Semantic rule enforced at write time: vibration above 2.0 mm/s raises an alarm.
CREATE TRIGGER trg_vib_alarm
AFTER INSERT ON reading
FOR EACH ROW
WHEN NEW.value > 2.0 AND (SELECT metric FROM sensor WHERE sensor_id = NEW.sensor_id) = 'vib_rms'
BEGIN
    INSERT INTO alarm(sensor_id, ts, value, reason)
    VALUES (NEW.sensor_id, NEW.ts, NEW.value, 'vibration over 2.0 mm/s');
END;

-- 2. Audit every update, automatically.
CREATE TRIGGER trg_reading_audit
AFTER UPDATE OF value ON reading
FOR EACH ROW
BEGIN
    INSERT INTO audit(reading_id, old_value, new_value)
    VALUES (NEW.reading_id, OLD.value, NEW.value);
END;

CREATE VIEW machine_health AS SELECT s.machine_id,s.metric,MAX(r.value) peak,COUNT(*) n FROM sensor s JOIN reading r USING(sensor_id) GROUP BY s.machine_id,s.metric;

-- Preserve the audit trail against ordinary DML. File owners can still alter DDL.
CREATE TRIGGER audit_no_update BEFORE UPDATE ON audit BEGIN
 SELECT RAISE(ABORT,'audit is append-only');
END;
CREATE TRIGGER audit_no_delete BEFORE DELETE ON audit BEGIN
 SELECT RAISE(ABORT,'audit is append-only');
END;
