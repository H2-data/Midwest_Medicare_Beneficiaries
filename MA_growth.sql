-- Active: 1780043201174@@127.0.0.1@3306@beneficiaries

-- Here, I will record some growth metrics to see the fastest growing states in regards to beneficiaries.
-- First, I'll take a look at Medicare Advantage growth statistics from 2020-2024
-- Rename the indices with table key + id (eg GeographyID, MedinfoID)

-- What I need to do here is collect the average number of items

WITH cte_growth_avg AS (
SELECT
    BENE_COUNTY_DESC,
    BENE_STATE_DESC,
    AVG(CASE WHEN YEAR = 2020 THEN A_B_MA_AND_OTH_BENES END) AS avg_2020,
    AVG(CASE WHEN YEAR = 2024 THEN A_B_MA_AND_OTH_BENES END) AS avg_2024
FROM medicare_info
GROUP BY BENE_STATE_DESC, BENE_COUNTY_DESC
)
SELECT
    BENE_STATE_DESC,
    (SUM(avg_2024) - SUM(avg_2020)) / SUM(avg_2020) * 100 AS growth_pct
FROM cte_growth_avg
GROUP BY BENE_STATE_DESC;

-- Sanity Check:

-- According to the Common Table Expression below, Boone County in Illinois has a 2024 average of 5406.083333333333.
SELECT
    BENE_COUNTY_DESC,
    BENE_STATE_DESC,
    AVG(CASE WHEN YEAR = 2020 THEN A_B_MA_AND_OTH_BENES END) AS avg_2020,
    AVG(CASE WHEN YEAR = 2024 THEN A_B_MA_AND_OTH_BENES END) AS avg_2024
FROM medicare_info
GROUP BY BENE_STATE_DESC, BENE_COUNTY_DESC;

-- If I pull the raw data and manually calculate the average of the results for Boone County in 2024, I get a match.

SELECT
    BENE_COUNTY_DESC,
    BENE_STATE_DESC,
    A_B_MA_AND_OTH_BENES,
    YEAR
FROM medicare_info
WHERE BENE_COUNTY_DESC = 'Boone County'
AND BENE_STATE_DESC = 'Illinois'
AND YEAR = '2024';

-- From the growth query, we learn the fastest growing states for MA acquistion are:

-- North Dakota
-- Nebraska
-- South Daokta
-- Kansas
-- Iowa
