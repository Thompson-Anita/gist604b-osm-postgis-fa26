-- Query 3: Streams Near Hamlets
-- Purpose: Identify streams within one mile of hamlets.
-- Distance: 1609.34 meters.

WITH hamlets AS (
    SELECT
        geom
    FROM
        places
    WHERE
        fclass = 'hamlet'
        AND geom IS NOT NULL
),

streams AS (
    SELECT
        name,
        geom
    FROM
        waterways
    WHERE
        fclass = 'stream'
        AND geom IS NOT NULL
        AND name IS NOT NULL
)

SELECT
    s.name AS stream_name,
    COUNT(DISTINCT ST_AsEWKB(h.geom)) AS nearby_hamlet_count,
    ST_Union(s.geom) AS geom

FROM
    streams AS s

JOIN
    hamlets AS h
    ON ST_DWithin(
        h.geom::geography,
        s.geom::geography,
        1609.34
    )

GROUP BY
    s.name

HAVING
    COUNT(DISTINCT ST_AsEWKB(h.geom)) > 1

ORDER BY
    nearby_hamlet_count DESC;
