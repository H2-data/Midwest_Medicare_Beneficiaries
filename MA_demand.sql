
-- Here, I will use the opportunity equation (see README) in order to find:
-- -- The state ranking for highest MA demand.
-- -- The county rankings for MA demand and population per state.

-- First, I will order the states by MA demand.

DROP VIEW v_state_MA_demand;

CREATE VIEW v_state_MA_demand AS
SELECT
    g.BENE_STATE_DESC,
    m.YEAR,
    SUM(m.TOT_BENES) as tot_benes,
    SUM(m.A_B_TOT_BENES) * (1 - SUM(m.A_B_MA_AND_OTH_BENES) / SUM(m.TOT_BENES)) AS MA_demand_benes
FROM medicare_info AS m
JOIN geography AS g
    ON m.BENE_FIPS_CD = g.BENE_FIPS_CD
WHERE m.YEAR = 2024
GROUP BY
	BENE_STATE_DESC;
    
SELECT
	BENE_STATE_DESC,
    TOT_BENES,
	ROUND(MA_demand_benes, 2) AS MA_demand_benes
 FROM v_state_MA_demand
 ORDER BY 
    MA_demand_benes DESC;

-- Next, I'll check the county rankings to see which counties have a high demand per state.

DROP VIEW v_county_MA_demand;

CREATE VIEW v_county_MA_demand AS
SELECT
    g.BENE_STATE_DESC,
    g.BENE_COUNTY_DESC,
    m.BENE_FIPS_CD,
    SUM(m.TOT_BENES) AS tot_benes,
    SUM(m.A_B_TOT_BENES) * (1 - SUM(m.A_B_MA_AND_OTH_BENES) / SUM(m.TOT_BENES)) AS demand_benes
FROM medicare_info AS m
JOIN geography AS g
    ON m.BENE_FIPS_CD = g.BENE_FIPS_CD
WHERE m.YEAR = 2024
GROUP BY
    BENE_STATE_DESC,
    BENE_FIPS_CD,
    BENE_COUNTY_DESC;

SELECT
    BENE_STATE_DESC,
    BENE_COUNTY_DESC,
    BENE_FIPS_CD,
    demand_benes,
    ROW_NUMBER() OVER (
        PARTITION BY BENE_STATE_DESC
        ORDER BY demand_benes DESC) AS county_demand_rank 
FROM v_county_MA_demand
ORDER BY 
    BENE_STATE_DESC,
    demand_benes DESC;


 

