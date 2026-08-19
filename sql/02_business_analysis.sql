-- This is the heart of our analysis wherein we ask business questions like:
-- Which states/ industries have strong economic output but relatively low startup activity, indicating potential whitespace and many more that came in our mind while doing the analysis?



-- 1. STARTUP ECOSYSTEM OVERVIEW

-- Total Startups by Year

SELECT
    year,
    SUM(startup_count) AS total_startups
FROM india_startup
GROUP BY year
ORDER BY year;

-- Year-on-year growth

WITH yearly AS (
    SELECT
        year,
        SUM(startup_count) AS total_startups
    FROM india_startup
    GROUP BY year
)

SELECT
    year,
    total_startups,
    LAG(total_startups) OVER (
        ORDER BY year
    ) AS previous_year_startups,

    ROUND(
        (
            total_startups -
            LAG(total_startups) OVER (
                ORDER BY year
            )
        )
        /
        NULLIF(
            LAG(total_startups) OVER (
                ORDER BY year
            ), 0
        ) * 100,
        2
    ) AS yoy_growth_pct

FROM yearly
ORDER BY year;

-- 2. STATE ANALYSIS

-- States by total startup activity

SELECT
    state,
    SUM(startup_count) AS total_startups
FROM india_startup
GROUP BY state
ORDER BY total_startups DESC;

-- Latest-year state ranking

SELECT
    state,
    SUM(startup_count) AS startups
FROM india_startup
WHERE year = (
    SELECT MAX(year)
    FROM india_startup
)
GROUP BY state
ORDER BY startups DESC;

-- 3. Industry Analysis

-- Top Industries

SELECT
    industry,
    SUM(startup_count) AS total_startups
FROM india_startup
GROUP BY industry
ORDER BY total_startups DESC;

-- Latest Year Top Industries 

SELECT
    industry,
    SUM(startup_count) AS startups
FROM india_startup
WHERE year = (
    SELECT MAX(year)
    FROM india_startup
)
GROUP BY industry
ORDER BY startups DESC;


-- 4. State x Industry Analysis

SELECT
    state,
    industry,
    SUM(startup_count) AS startups
FROM india_startup
GROUP BY
    state,
    industry
ORDER BY startups DESC;

-- Which industries dominate each state?


WITH state_industry AS (

    SELECT
        state,
        industry,
        SUM(startup_count) AS startups

    FROM india_startup

    GROUP BY
        state,
        industry
),

ranked AS (

    SELECT
        state,
        industry,
        startups,

        RANK() OVER (
            PARTITION BY state
            ORDER BY startups DESC
        ) AS industry_rank

    FROM state_industry
)

SELECT
    state,
    industry,
    startups
FROM ranked
WHERE industry_rank <= 5
ORDER BY
    state,
    industry_rank;
    
    
-- Industry growth over time


WITH yearly_industry AS (

    SELECT
        year,
        industry,
        SUM(startup_count) AS startups

    FROM india_startup

    GROUP BY
        year,
        industry
),

growth AS (

    SELECT
        year,
        industry,
        startups,

        LAG(startups) OVER (
            PARTITION BY industry
            ORDER BY year
        ) AS previous_year

    FROM yearly_industry
)

SELECT
    year,
    industry,
    startups,
    previous_year,

    ROUND(
        (startups - previous_year)
        / NULLIF(previous_year, 0) * 100,
        2
    ) AS yoy_growth_pct

FROM growth
ORDER BY
    industry,
    year;


-- Fastest-growing industries

    
WITH yearly_industry AS (

    SELECT
        year,
        industry,
        SUM(startup_count) AS startups

    FROM india_startup

    GROUP BY year, industry
),

growth AS (

    SELECT
        year,
        industry,
        startups,

        LAG(startups) OVER (
            PARTITION BY industry
            ORDER BY year
        ) AS previous_year

    FROM yearly_industry
)

SELECT
    industry,
    startups,
    previous_year,

    ROUND(
        (startups - previous_year)
        / NULLIF(previous_year, 0) * 100,
        2
    ) AS yoy_growth_pct

FROM growth

WHERE year = (
    SELECT MAX(year)
    FROM india_startup
)

AND previous_year > 0

ORDER BY yoy_growth_pct DESC;



-- Top-growing states in the latest year


WITH state_year AS (

    SELECT
        year,
        state,
        SUM(startup_count) AS startups

    FROM india_startup

    GROUP BY year, state
),

growth AS (

    SELECT
        year,
        state,
        startups,

        LAG(startups) OVER (
            PARTITION BY state
            ORDER BY year
        ) AS previous_year

    FROM state_year
)

SELECT
    state,
    startups,
    previous_year,

    ROUND(
        (startups - previous_year)
        / NULLIF(previous_year, 0) * 100,
        2
    ) AS yoy_growth_pct

FROM growth

WHERE year = (
    SELECT MAX(year)
    FROM india_startup
)

AND previous_year > 0

ORDER BY yoy_growth_pct DESC;


-- 5. NSVA vs startup ecosystem


SELECT
    state,
    year,
    MAX(nsva) AS nsva,
    SUM(startup_count) AS startups
FROM india_startup
GROUP BY
    state,
    year
ORDER BY
    year,
    nsva DESC;



-- Startup Activity Relative to NSVA



SELECT
    state,
    year,

    SUM(startup_count) AS startups,

    MAX(nsva) AS nsva,

    ROUND(
        SUM(startup_count) /
        NULLIF(MAX(nsva), 0) * 100000,
        4
    ) AS startups_per_nsva_unit

FROM india_startup

GROUP BY
    state,
    year

ORDER BY
    startups_per_nsva_unit DESC;
    
    

--  State economic size vs startup growth



WITH state_year AS (

    SELECT
        state,
        year,
        SUM(startup_count) AS startups,
        MAX(nsva) AS nsva

    FROM india_startup

    GROUP BY
        state,
        year
),

growth AS (

    SELECT
        state,
        year,
        startups,
        nsva,

        LAG(startups) OVER (
            PARTITION BY state
            ORDER BY year
        ) AS previous_startups

    FROM state_year
)

SELECT
    state,
    year,
    startups,
    nsva,

    ROUND(
        (startups - previous_startups)
        / NULLIF(previous_startups, 0) * 100,
        2
    ) AS startup_growth_pct

FROM growth

WHERE year = (
    SELECT MAX(year)
    FROM state_year
)

ORDER BY startup_growth_pct DESC;



-- 6. Identify "large but underrepresented" states


WITH state_metrics AS (

    SELECT
        state,
        SUM(startup_count) AS startups,
        MAX(nsva) AS nsva

    FROM india_startup

    WHERE year = (
        SELECT MAX(year)
        FROM india_startup
    )

    GROUP BY state
),

ranked AS (

    SELECT
        *,
        PERCENT_RANK() OVER (
            ORDER BY startups
        ) AS startup_percentile,

        PERCENT_RANK() OVER (
            ORDER BY nsva
        ) AS nsva_percentile

    FROM state_metrics
)

SELECT
    state,
    startups,
    nsva,

    ROUND(startup_percentile * 100, 2)
        AS startup_percentile,

    ROUND(nsva_percentile * 100, 2)
        AS economic_percentile

FROM ranked

WHERE nsva_percentile >= 0.50
AND startup_percentile <= 0.50

ORDER BY nsva DESC;


