
-- Here, I will use the opportunity equation (see README) in order to find:
-- -- The state ranking for highest MA demand.
-- -- The county rankings for MA demand and population per state.

-- First, I will order the states by MA demand.

-- SINCE IM USING ONE INFERENCE COLUMN, DO I EVEN NEED THIS DOCUMENT?????

DROP VIEW v_state_MA_demand;

-- HERE WE DO HAVE NULLS, HOWEVER there is no math being done, just querying. Best to leave them be?

CREATE VIEW v_state_MA_demand AS
SELECT
    g.BENE_STATE_DESC,
    m.YEAR,
    SUM(m.A_B_ORGNL_MDCR_BENES) AS MA_demand_benes
FROM medicare_info AS m
JOIN geography AS g
    ON m.index = g.index
GROUP BY
	BENE_STATE_DESC, 
    YEAR;
    
SELECT
	BENE_STATE_DESC,
    YEAR,
	ROUND(MA_demand_benes, 2) AS MA_demand_benes
 FROM v_state_MA_demand
 WHERE YEAR IN (2023, 2024)
 ORDER BY 
    MA_demand_benes DESC;

-- Quick sanity check

SELECT
    SUM(A_B_ORGNL_MDCR_BENES)
FROM medicare_info
WHERE BENE_STATE_DESC = 'Wisconsin'
AND YEAR = '2020';

-- The result was 6817737

SELECT
    SUM(demand_benes)
FROM v_county_ma_demand
WHERE BENE_STATE_DESC = 'Wisconsin'
AND YEAR = '2020';

-- The result was 6817737, matching the original table.

-- Next, I'll check the county rankings to see which counties have a high demand per state.

DROP VIEW v_county_MA_demand;

CREATE VIEW v_county_MA_demand AS
SELECT
    g.BENE_STATE_DESC,
    g.BENE_COUNTY_DESC,
    m.YEAR,
    SUM(m.A_B_ORGNL_MDCR_BENES) AS demand_benes
FROM medicare_info AS m
JOIN geography AS g
    ON m.index = g.index
GROUP BY
    BENE_STATE_DESC,
    BENE_COUNTY_DESC,
    YEAR;

SELECT
    YEAR,
    SUM(demand_benes) 
FROM v_county_MA_demand
WHERE YEAR = 2020
AND BENE_STATE_DESC = 'Wisconsin';

-- Quick sanity check

SELECT
    SUM(A_B_ORGNL_MDCR_BENES)
FROM medicare_info
WHERE BENE_COUNTY_DESC = 'Dupage County'
AND YEAR = '2020';

-- The result was 1167768

SELECT
    SUM(demand_benes)
FROM v_county_ma_demand
WHERE BENE_COUNTY_DESC = 'Dupage County'
AND YEAR = '2020';

-- The result was 1167768, matching the original table.

 

