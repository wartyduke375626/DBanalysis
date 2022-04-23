/* Select IP addresses of all hosts except those contained in reserved subnets according to: https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.xhtml */
SELECT h.ip_addr
FROM hosts h
WHERE NOT (
	h.ip_addr <<= '0.0.0.0/8' OR h.ip_addr <<= '0.0.0.0/32' OR h.ip_addr <<= '10.0.0.0/8'
	OR h.ip_addr <<= '100.64.0.0/10' OR h.ip_addr <<= '127.0.0.0/8' OR h.ip_addr <<= '169.254.0.0/16'
	OR h.ip_addr <<= '172.16.0.0/12' OR h.ip_addr <<= '192.0.2.0/24' OR h.ip_addr <<= '192.88.99.0/24'
	OR h.ip_addr <<= '192.88.99.2/32' OR h.ip_addr <<= '192.168.0.0/16' OR h.ip_addr <<= '192.0.0.0/24'
	OR h.ip_addr <<= '198.18.0.0/15' OR h.ip_addr <<= '198.51.100.0/24' OR h.ip_addr <<= '203.0.113.0/24'
	OR h.ip_addr <<= '255.255.255.255/32'
);

/* Complementary query: */
SELECT h.ip_addr
FROM hosts h
WHERE h.ip_addr <<= '0.0.0.0/8' OR h.ip_addr <<= '0.0.0.0/32' OR h.ip_addr <<= '10.0.0.0/8'
	OR h.ip_addr <<= '100.64.0.0/10' OR h.ip_addr <<= '127.0.0.0/8' OR h.ip_addr <<= '169.254.0.0/16'
	OR h.ip_addr <<= '172.16.0.0/12' OR h.ip_addr <<= '192.0.2.0/24' OR h.ip_addr <<= '192.88.99.0/24'
	OR h.ip_addr <<= '192.88.99.2/32' OR h.ip_addr <<= '192.168.0.0/16' OR h.ip_addr <<= '192.0.0.0/24'
	OR h.ip_addr <<= '198.18.0.0/15' OR h.ip_addr <<= '198.51.100.0/24' OR h.ip_addr <<= '203.0.113.0/24'
	OR h.ip_addr <<= '255.255.255.255/32';



/* Select IP addresses of all hosts with at least 1 successfull ping record in table ping or traceroute record in table topology: */	
SELECT h.ip_addr
FROM hosts h
WHERE EXISTS (
	SELECT *
	FROM ping p
	WHERE h.ip_addr = p.ip_addr AND p.ping_ploss >= 0 AND p.ping_ploss < 100
) OR EXISTS (
	SELECT *
	FROM topology t
	WHERE h.ip_addr = t.ip_addr AND t.t_status <> 'E'
);

/* Complementary querry: */
SELECT h.ip_addr
FROM hosts h
WHERE NOT EXISTS (
	SELECT *
	FROM ping p
	WHERE h.ip_addr = p.ip_addr AND p.ping_ploss >= 0 AND p.ping_ploss < 100
) AND NOT EXISTS (
	SELECT *
	FROM topology t
	WHERE h.ip_addr = t.ip_addr AND t.t_status <> 'E'
);



/* Conjunctio of both conditions: */
SELECT h.ip_addr
FROM hosts h
WHERE NOT (
	h.ip_addr <<= '0.0.0.0/8' OR h.ip_addr <<= '0.0.0.0/32' OR h.ip_addr <<= '10.0.0.0/8'
	OR h.ip_addr <<= '100.64.0.0/10' OR h.ip_addr <<= '127.0.0.0/8' OR h.ip_addr <<= '169.254.0.0/16'
	OR h.ip_addr <<= '172.16.0.0/12' OR h.ip_addr <<= '192.0.2.0/24' OR h.ip_addr <<= '192.88.99.0/24'
	OR h.ip_addr <<= '192.88.99.2/32' OR h.ip_addr <<= '192.168.0.0/16' OR h.ip_addr <<= '192.0.0.0/24'
	OR h.ip_addr <<= '198.18.0.0/15' OR h.ip_addr <<= '198.51.100.0/24' OR h.ip_addr <<= '203.0.113.0/24'
	OR h.ip_addr <<= '255.255.255.255/32'
) AND (
	EXISTS (
		SELECT *
		FROM ping p
		WHERE h.ip_addr = p.ip_addr AND p.ping_ploss >= 0 AND p.ping_ploss < 100
	) OR EXISTS (
		SELECT *
		FROM topology t
		WHERE h.ip_addr = t.ip_addr AND t.t_status <> 'E'
	)
);

/* Complementary query: */
SELECT h.ip_addr
FROM hosts h
WHERE h.ip_addr <<= '0.0.0.0/8' OR h.ip_addr <<= '0.0.0.0/32' OR h.ip_addr <<= '10.0.0.0/8'
	OR h.ip_addr <<= '100.64.0.0/10' OR h.ip_addr <<= '127.0.0.0/8' OR h.ip_addr <<= '169.254.0.0/16'
	OR h.ip_addr <<= '172.16.0.0/12' OR h.ip_addr <<= '192.0.2.0/24' OR h.ip_addr <<= '192.88.99.0/24'
	OR h.ip_addr <<= '192.88.99.2/32' OR h.ip_addr <<= '192.168.0.0/16' OR h.ip_addr <<= '192.0.0.0/24'
	OR h.ip_addr <<= '198.18.0.0/15' OR h.ip_addr <<= '198.51.100.0/24' OR h.ip_addr <<= '203.0.113.0/24'
	OR h.ip_addr <<= '255.255.255.255/32'
UNION
SELECT h.ip_addr
FROM hosts h
WHERE NOT EXISTS (
	SELECT *
	FROM ping p
	WHERE h.ip_addr = p.ip_addr AND p.ping_ploss >= 0 AND p.ping_ploss < 100
) AND NOT EXISTS (
	SELECT *
	FROM topology t
	WHERE h.ip_addr = t.ip_addr AND t.t_status <> 'E'
);



/* % of valid hosts: */
CREATE TEMPORARY TABLE valid_hosts AS (
	SELECT h.ip_addr
	FROM hosts h
	WHERE NOT (
		h.ip_addr <<= '0.0.0.0/8' OR h.ip_addr <<= '0.0.0.0/32' OR h.ip_addr <<= '10.0.0.0/8'
		OR h.ip_addr <<= '100.64.0.0/10' OR h.ip_addr <<= '127.0.0.0/8' OR h.ip_addr <<= '169.254.0.0/16'
		OR h.ip_addr <<= '172.16.0.0/12' OR h.ip_addr <<= '192.0.2.0/24' OR h.ip_addr <<= '192.88.99.0/24'
		OR h.ip_addr <<= '192.88.99.2/32' OR h.ip_addr <<= '192.168.0.0/16' OR h.ip_addr <<= '192.0.0.0/24'
		OR h.ip_addr <<= '198.18.0.0/15' OR h.ip_addr <<= '198.51.100.0/24' OR h.ip_addr <<= '203.0.113.0/24'
		OR h.ip_addr <<= '255.255.255.255/32'
	) AND (
		EXISTS (
			SELECT *
			FROM ping p
			WHERE h.ip_addr = p.ip_addr AND p.ping_ploss >= 0 AND p.ping_ploss < 100
		) OR EXISTS (
			SELECT *
			FROM topology t
			WHERE h.ip_addr = t.ip_addr AND t.t_status <> 'E'
		)
	)
);
SELECT (SELECT count(*) FROM valid_hosts)::float / (SELECT count(*) FROM hosts) * 100 AS p_of_valid_hosts;



/* IP addresses of hosts that responded to all ping requests: */
SELECT h.ip_addr
FROM hosts h
WHERE NOT EXISTS (
	SELECT *
	FROM ping p
	WHERE h.ip_addr = p.ip_addr AND (p.ping_ploss < 0 OR p.ping_ploss == 100)
);

/* Complementary query:  */
SELECT h.ip_addr
FROM hosts h
WHERE EXISTS (
	SELECT *
	FROM ping p
	WHERE h.ip_addr = p.ip_addr AND (p.ping_ploss < 0 OR p.ping_ploss == 100)
);
