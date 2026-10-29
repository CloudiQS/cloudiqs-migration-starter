-- T5 — Stage-1 / Stage-3 validation queries. Run against the SOURCE at the
-- write-stop moment (Stage 1), then against the TARGET after both CDC latency
-- metrics reach zero (Stage 3). Diff line by line. Columns are the `orders`
-- schema's actual columns (infrastructure/target-stack.yaml), not placeholders.
--
-- R7 criterion (amended): Stage-3 row counts, key-column sums, maximum
-- timestamps, and distinct primary-key counts must match the Stage-1 baseline
-- exactly for every in-scope table; every discrepancy and every suspended
-- validation row needs an owner-approved disposition.
--
-- Disposition (owner-approved, Applications Lead, per R7's "every suspended
-- validation row has an owner-approved disposition" clause): the max-timestamp
-- sub-check is N/A for `products` and `order_items` because no timestamp
-- column exists in the schema (infrastructure/target-stack.yaml) — this is
-- recorded as a disposition, not a pass. Row count, key-column sum, and
-- distinct-PK still apply, and run, for all four tables.

-- ============================== customers ==============================
SELECT 'customers' AS tbl, 'row_count' AS metric, COUNT(*) AS value FROM customers;
SELECT 'customers', 'sum_id', SUM(id) FROM customers;
SELECT 'customers', 'max_created_at', MAX(created_at) FROM customers;
SELECT 'customers', 'distinct_pk', COUNT(DISTINCT id) FROM customers;

-- ============================== products ==============================
SELECT 'products', 'row_count', COUNT(*) FROM products;
SELECT 'products', 'sum_price', SUM(price) FROM products;
-- max_<TS_COL>: N/A — products has no timestamp column.
SELECT 'products', 'distinct_pk', COUNT(DISTINCT id) FROM products;

-- ============================== orders ==============================
SELECT 'orders', 'row_count', COUNT(*) FROM orders;
SELECT 'orders', 'sum_total', SUM(total) FROM orders;
SELECT 'orders', 'max_created_at', MAX(created_at) FROM orders;
SELECT 'orders', 'distinct_pk', COUNT(DISTINCT id) FROM orders;

-- ============================== order_items ==============================
SELECT 'order_items', 'row_count', COUNT(*) FROM order_items;
SELECT 'order_items', 'sum_price', SUM(price) FROM order_items;
-- max_<TS_COL>: N/A — order_items has no timestamp column.
SELECT 'order_items', 'distinct_pk', COUNT(DISTINCT id) FROM order_items;
