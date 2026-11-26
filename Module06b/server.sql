-- Run only in your instructor-assigned PostgreSQL database, using the browser UI.
-- No credentials are stored here. Use a fresh diagnostic table name.
CREATE TABLE portfolio_device (
    device_id integer PRIMARY KEY,
    name text NOT NULL UNIQUE,
    meta jsonb NOT NULL
);
INSERT INTO portfolio_device VALUES
 (1,'cnc-01','{"vendor":"Siemens","firmware":"4.2"}'),
 (2,'cnc-02','{"vendor":"Fanuc","firmware":"3.9"}'),
 (3,'molder-07','{"vendor":"Arburg","firmware":"8.1"}');
SELECT device_id,name FROM portfolio_device ORDER BY device_id;
-- Session A: BEGIN; UPDATE portfolio_device SET name='cnc-01-A' WHERE device_id=1;
-- Leave A open. Session B: BEGIN; SET LOCAL lock_timeout='5s';
-- UPDATE portfolio_device SET name='cnc-01-B' WHERE device_id=1;
-- Observe blocking/timeout. Then ROLLBACK in both sessions; record actual behaviour.
-- Ask instructor to stop the server; record actual connection error, not a prediction.
