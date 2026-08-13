
-- Here, I will use the opportunity equation (see README) in order to find:
-- The state ranking for highest MA demand.
-- The county rankings for MA demand and population per state.

-- First, I will order the states by MA demand.

DROP VIEW v_monthly_county_avg_medicare;

CREATE VIEW v_monthly_county_avg_medicare AS
SELECT
    BENE_COUNTY_DESC,
    BENE_STATE_DESC,
    YEAR,
    AVG(A_B_ORGNL_MDCR_BENES) AS ab_only
FROM medicare_info
GROUP BY YEAR, BENE_COUNTY_DESC, BENE_STATE_DESC;

SELECT
    BENE_STATE_DESC,
    SUM(ab_only) AS AB_Only_Benes
FROM v_monthly_county_avg_medicare
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC
ORDER BY AB_Only_Benes DESC;

-- The code structure used in this query is the same as the demographics. See demographics.sql for proof of sanity check.
-- Next, I'll check the county rankings to see which counties have a high demand per state.
-- I'll collect the top 5 ranked per state for this one.

WITH rankings AS (
SELECT
    BENE_STATE_DESC,
    BENE_COUNTY_DESC,
    SUM(ab_only) AS AB_Only_Benes,
    RANK() OVER(PARTITION BY BENE_STATE_DESC ORDER BY SUM(ab_only) DESC) AS rankings
FROM v_monthly_county_avg_medicare
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC, BENE_COUNTY_DESC
)
SELECT
    *
FROM rankings
WHERE rankings <= 5;


