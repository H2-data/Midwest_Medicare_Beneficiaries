
-- Here, I will use the opportunity equation (see README) in order to find:
-- -- The state ranking for highest MA demand.
-- -- The top 10 counties with the highest MA demand per state.

-- First, I will order the states by MA demand.

DROP VIEW demand_ranking;

CREATE VIEW demand_ranking AS
SELECT
    BENE_STATE_DESC,
    SUM(TOT_BENES) as tot_benes,
    SUM(A_B_TOT_BENES) * (1 - SUM(A_B_MA_AND_OTH_BENES) / SUM(TOT_BENES)) AS opportunity
FROM beneficiaries
WHERE YEAR = 2024
GROUP BY
	BENE_STATE_DESC;
    
SELECT
	BENE_STATE_DESC,
    TOT_BENES,
	ROUND(opportunity, 2) AS opportunity
 FROM demand_ranking
 ORDER BY opportunity DESC;

-- Based on this, It appears that the top 5 states in regards to demand are Illinois, Indiana, Iowa, Kansas and Michigan.

-- Next, I'll do the top 10 counties per state. It's a little more complicated because I need to:
-- -- Assign row numbers for filtration
-- -- Partition the row number procedure by state

DROP VIEW AB_numbering;

CREATE VIEW AB_numbering AS
SELECT
    BENE_STATE_DESC,
    BENE_COUNTY_DESC,
    BENE_FIPS_CD,
    SUM(TOT_BENES) AS tot_benes,
    SUM(A_B_TOT_BENES) * (1 - SUM(A_B_MA_AND_OTH_BENES) / SUM(TOT_BENES)) AS opportunity,
    ROW_NUMBER() OVER (
        PARTITION BY BENE_STATE_DESC
        ORDER BY SUM(A_B_TOT_BENES) * (1 - SUM(A_B_MA_AND_OTH_BENES) / SUM(TOT_BENES)) DESC
    ) AS AB_county_rank
FROM beneficiaries
WHERE YEAR = 2024
GROUP BY 
    BENE_STATE_DESC,
    BENE_FIPS_CD,
    BENE_COUNTY_DESC;

SELECT * FROM AB_numbering;

-- Now each county has been given a numeric ranking for each state. Now I just need to collect
-- the top 10 counties for each state aka, anything <= 10.

DROP VIEW top10_counties_AB;

CREATE VIEW top10_counties_AB AS
SELECT 
	BENE_STATE_DESC,
	BENE_COUNTY_DESC,
    ROUND(opportunity, 1) as opportunity,
    AB_county_rank
FROM AB_numbering
WHERE AB_county_rank <= 10
ORDER BY BENE_STATE_DESC;

SELECT * FROM top10_counties_AB;