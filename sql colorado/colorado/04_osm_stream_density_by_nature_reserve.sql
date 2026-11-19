-- Query 4: Stream Density by Nature Reserve
-- Purpose: Calculate stream density (km per sq km) in each nature reserve

-- Requirements:
-- - Use protected_areas_a for nature reserves (fclass = 'nature_reserve')
-- - Use stream for line features
-- - Use ST_Intersects to match stream to nature reserves
-- - Use ST_Intersection to clip stream segments to nature reserve boundaries
-- - Use ST_Length(geom::geography) for accurate stream lengths
-- - Convert meters to kilometers (divide by 1,000)
-- - Use ST_Area(geom::geography) for nature reserve area
-- - Convert square meters to square kilometers (divide by 1,000,000)
-- - Use a CTE to calculate intermediate metrics
-- - Calculate stream density = total_stream_length_km / nat_area_sq_km
-- - Order results by stream density (highest first)


-- Query 4: Stream Density by Nature Reserve
-- Purpose: Calculate stream density (km per sq km)
-- within each nature reserve.

WITH nature_reserves AS (
    SELECT
        name AS nat_area_name,
        geom,
        ST_Area(geom::geography) / 1000000.0
            AS nat_area_sq_km
    FROM
        protected_areas_a
    WHERE
        fclass = 'nature_reserve'
),

stream_metrics AS (
    SELECT
        nr.nat_area_name,
        nr.nat_area_sq_km,
        SUM(
            ST_Length(
                ST_Intersection(s.geom, nr.geom)::geography
            )
        ) / 1000.0 AS total_stream_length_km,
        nr.geom
    FROM
        nature_reserves AS nr

    JOIN
        stream AS s
        ON ST_Intersects(s.geom, nr.geom)

    GROUP BY
        nr.nat_area_name,
        nr.nat_area_sq_km,
        nr.geom
)

SELECT
    nat_area_name,
    total_stream_length_km,
    nat_area_sq_km,
    total_stream_length_km / NULLIF(nat_area_sq_km, 0)
        AS stream_density_km_per_sq_km,
    geom
FROM
    stream_metrics

ORDER BY
    stream_density_km_per_sq_km DESC;
