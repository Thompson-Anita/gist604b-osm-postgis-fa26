-- Q
-- Query 4: Stream Density by Nature Reserve
-- Purpose: Calculate stream density (km per sq km)
-- within each Colorado nature reserve.

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
        AND geom IS NOT NULL
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
    waterways AS s
    ON ST_Intersects(s.geom, nr.geom)

WHERE
    s.fclass = 'stream'
    AND s.geom IS NOT NULL

    GROUP BY
        nr.nat_area_name,
        nr.nat_area_sq_km,
        nr.geom
)

SELECT
    nat_area_name,
    total_stream_length_km,
    nat_area_sq_km,

    total_stream_length_km /
        NULLIF(nat_area_sq_km, 0)
        AS stream_density_km_per_sq_km,

    geom

FROM
    stream_metrics

ORDER BY
    stream_density_km_per_sq_km DESC;
