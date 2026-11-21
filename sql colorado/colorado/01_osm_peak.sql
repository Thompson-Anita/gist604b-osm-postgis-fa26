-- Query 1: Peak Locations
-- Purpose: Extract peak locations for spatial distribution analysis

-- Requirements:
-- - Use "natural" for point features
-- - Filter POIs where fclass = 'peak'
-- - Return raw point geometries
-- - (Optional) Clip to a specific region if needed

-- Expected Output:
-- - geom

SELECT
    geom
FROM
    "natural"
WHERE
    fclass = 'peak';
