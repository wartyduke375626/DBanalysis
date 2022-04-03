/* This script contains queries used in analysis of table structure. */

/* Count number of rows: */
SELECT count(*) FROM hosts;
SELECT count(*) FROM h_types;
SELECT count(*) FROM source;
SELECT count(*) FROM source_types;
SELECT count(*) FROM ping;
SELECT count(*) FROM topology;

/* Random sample of 10 rows - randomly filters 1% of rows and selects the first 10: */
SELECT * FROM hosts WHERE random() <= 0.01 LIMIT 10;
SELECT * FROM source WHERE random() <= 0.01 LIMIT 10;
SELECT * FROM ping WHERE random() <= 0.01 LIMIT 10;
SELECT * FROM topology WHERE t_hops <= 3 AND random() <= 0.01 LIMIT 10;

/* Select all rows: */
SELECT * FROM h_types ORDER BY rank_code;
SELECT * FROM source_types ORDER BY source_code;
