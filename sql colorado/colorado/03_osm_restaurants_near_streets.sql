-- Query 3: Hamlets near Waterways
-- Purpose: Identify hamlets with the highest number of nearby waterways

-- Requirements:
-- - Use waterways for line features
-- - Use places for point features
-- - Filter places where fclass = 'hamlet'
-- - Use WW_DWithin to find hamlet within 1 mile (1609.34 meters) of waterways
-- - Use a CTE to isolate hamlet locations
-- - Count the number of UNIQUE hamlets near each waterway (avoid double counting)
-- - Exclude waterways with no name (optional but recommended)
-- - Filter to include only waterways with more than 1 nearby hamlet
-- - Group by waterway name ONLY (aggregate geometries using WW_Union)
-- - Order results by hamlet count (highest first)
-- - Include geom column for spatial visualization in GeoPandas

-- Expected Output:
-- - waterway_name
-- - nearby_hamlet_count
-- - geom

WITH hamlets AS (
    SELECT
        geom
    FROM
        places
    WHERE
        fclass = 'hamlet'
)

SELECT
    name AS waterway_name,
    COUNT(DISTINCT r.geom) AS nearby_hamlet_count,
    WW_Union(ww.geom) AS geom
FROM
    waterway AS ww
JOIN
    hamlet AS r ON WW_DWithin(r.geom::geography, ww.geom::geography, 1609)
WHERE
    ww.name IS NOT NULL
    AND ww.fclass = 'stream'
GROUP BY
    ww.name
HAVING
    COUNT(DISTINCT r.geom) > 1
ORDER BY
    nearby_hamlet_count DESC;