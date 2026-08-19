-- Database Creation

-- Using india_startup_master_dataset.csv

CREATE DATABASE indian_startup;


USE indian_startup;

CREATE TABLE india_startup (
    year INT,
    state VARCHAR(30),
    industry VARCHAR(30),
    startup_count INT,
    nsva INT,
    india_internet_penetration DECIMAL(10, 5),
    india_population INT,
    state_total_startups INT,
    sector_share DECIMAL(10, 5),
    sector_share_pct DECIMAL(10, 5),
    startup_growth_pct DECIMAL(10, 5),
    india_internet_growth_pp DECIMAL(10, 5),
    india_total_startups INT,
    industry_share_national DECIMAL(10, 5)
);

-- (Data was uploaded into the table using the Table Data Import Wizard in MySQL)

-- Data Validation

SELECT COUNT(*) AS total_records
FROM india_startup;

SELECT
    MIN(year) AS first_year,
    MAX(year) AS latest_year
FROM india_startup;

SELECT COUNT(DISTINCT state) AS number_of_states
FROM india_startup;

SELECT
    SUM(year IS NULL) AS missing_year,
    SUM(state IS NULL) AS missing_state,
    SUM(industry IS NULL) AS missing_industry,
    SUM(startup_count IS NULL) AS missing_startup_count,
    SUM(nsva IS NULL) AS missing_nsva
FROM india_startup;
