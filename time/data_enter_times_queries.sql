/* This script contains queries used to determine time intervals in which no entry was registered. Since th eserver runs PostgreSQL version 8.1.9 which does not support function generate_series(timestamp), generate_series(integer) is used instead (interpreted as UNIX timestamp) and then converted to timestamp. */

/* Dates of first entry for tables hosts, ping and topology: */
SELECT min(enter_date) FROM hosts; /* 2007-05-28 19:00:23 = 1180371623 (UNIX) */
SELECT min(ping_date) FROM ping; /* 2001-01-01 05:27:23 = 978323243 (UNIX) */
SELECT min(t_date) FROM topology; /* 2009-06-16 03:23:46 = 1245115426 (UNIX) */

/* Dates of last entry for tables hosts, ping and topology: */
SELECT max(enter_date) FROM hosts; /* 2013-07-01 03:57:53 = 1372651073 (UNIX) */
SELECT max(ping_date) FROM ping; /* 2013-07-01 04:51:03 = 1372647063 (UNIX) */
SELECT max(t_date) FROM topology; /* 2013-07-01 08:40:02 = 1372660802 (UNIX) */


/* Days when no host was recorded. */
CREATE TEMPORARY TABLE all_days_hosts AS (
    SELECT to_timestamp(generate_series)::date AS day
    FROM generate_series(1180371623, 1372651073, 86400) /* 86400 = day length in seconds */
);

/* Note: generate_series() generates timestamps inbetween min and max time found out in previous queries. The generation step is of 86400 seconds which is the exact day length in seconds.
  This means it will generate all days contained within the [min, max] interval, inclusive. This attribute is then cast to date type which will extract the day part of the timestamp. */

SELECT a.day
FROM all_days_hosts a
WHERE NOT EXISTS (
    SELECT *
    FROM hosts h
    WHERE h.enter_date::date = a.day
);

/* Complementary query. */
SELECT a.day
FROM all_days_hosts a
WHERE EXISTS (
    SELECT *
    FROM hosts h
    WHERE h.enter_date::date = a.day
);



/* Days when no ping entry was registered. */
CREATE TEMPORARY TABLE all_days_ping AS (
    SELECT to_timestamp(generate_series)::date AS day
    FROM generate_series(978323243, 1372647063, 86400) /* 86400 = day length in seconds */
);

SELECT a.day
FROM all_days_ping a
WHERE NOT EXISTS (
    SELECT *
    FROM ping p
    WHERE p.ping_date::date = a.day
);

/* Complementary query. */
SELECT a.day
FROM all_days_ping a
WHERE EXISTS (
    SELECT *
    FROM ping p
    WHERE p.ping_date::date = a.day
);


/* Days when no topology entry was registered. */
CREATE TEMPORARY TABLE all_days_t AS (
    SELECT to_timestamp(generate_series)::date AS day
    FROM generate_series(1245115426, 1372660802, 86400) /* 86400 = day length in seconds */
);

SELECT a.day
FROM all_days_t a
WHERE NOT EXISTS (
    SELECT *
    FROM topology t
    WHERE t.t_date::date = a.day
);

/* Complementary query. */
SELECT a.day
FROM all_days_t a
WHERE EXISTS (
    SELECT *
    FROM topology t
    WHERE t.t_date::date = a.day
);
