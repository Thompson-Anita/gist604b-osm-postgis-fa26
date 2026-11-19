-- Query 1: Hamlet Locations
-- Purpose: Extract hamlet locations for spatial distribution analysis

-- Requirements:
-- - Use places for point features
-- - Filter places where fclass = 'hamlet'
-- - Return raw point geometries
-- - (Optional) Clip to a specific region if needed

-- Expected Output:
-- - geom

SELECT
    geom
FROM
    places
WHERE
    fclass = 'hamlet';