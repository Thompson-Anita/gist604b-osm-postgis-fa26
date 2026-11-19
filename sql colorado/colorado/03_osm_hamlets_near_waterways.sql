
-- Query 3: Hamlets Near Waterways
-- Purpose: Identify waterways with the highest number
-- of nearby hamlets within one mile (1609.34 meters).

WITH hamlets AS (
    SELECT
        geom
    FROM
        places
    WHERE
        fclass = 'hamlet'
)

SELECT
    ww.name AS waterway_name,
    COUNT(DISTINCT h.geom) AS nearby_hamlet_count,
    ST_Union(ww.geom) AS geom

FROM
    waterways AS ww

JOIN
    hamlets AS h
    ON ST_DWithin(
        h.geom::geography,
        ww.geom::geography,
        1609.34
    )

WHERE
    ww.name IS NOT NULL

GROUP BY
    ww.name

HAVING
    COUNT(DISTINCT h.geom) > 1

ORDER BY
    nearby_hamlet_count DESC;
-- 

