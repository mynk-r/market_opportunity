-- Creating a SQL view for the future engine (Use it to get an idea of the cleaned data before entering into the deatils.)


CREATE OR REPLACE VIEW startup_state_industry_summary AS

SELECT
    year,
    state,
    industry,

    SUM(startup_count) AS startups,

    MAX(nsva) AS nsva,

    MAX(india_internet_penetration)
        AS india_internet_penetration,

    MAX(india_population)
        AS india_population

FROM india_startup

GROUP BY
    year,
    state,
    industry;
    
    
    
SELECT *
FROM startup_state_industry_summary;