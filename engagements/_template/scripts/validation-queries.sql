-- Validation queries — run twice, diff the results.
-- Stage 1: against the SOURCE, before any transfer (for quiesce sources: at the
--          exact moment writes stop). Stage 3: against the TARGET, after CDC
--          latency reaches zero (or after full load for quiesce sources).
-- One block per in-scope table. Record every value in the validation register
-- with a capture timestamp.

-- ============================== <TABLE> ==============================
-- Row count: the total the target must match exactly or within agreed tolerance.
SELECT '<TABLE>' AS tbl, 'row_count' AS metric, COUNT(*) AS value FROM <TABLE>;

-- Key-column sums: surfaces missing rows even when counts collide.
SELECT '<TABLE>', 'sum_<NUMERIC_COL>', SUM(<NUMERIC_COL>) FROM <TABLE>;

-- Max timestamps: confirms the most recent rows arrived.
SELECT '<TABLE>', 'max_<TS_COL>', MAX(<TS_COL>) FROM <TABLE>;

-- Distinct primary keys: detects duplicate-key anomalies before they replay.
SELECT '<TABLE>', 'distinct_pk', COUNT(DISTINCT <PK_COL>) FROM <TABLE>;

-- Repeat the block per table. Keep the metric names stable: the register and any
-- diff tooling key on them.
