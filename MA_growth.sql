-- Active: 1780043201174@@127.0.0.1@3306@beneficiaries

-- Here, I will record some growth metrics to see the fastest growing states in regards to beneficiaries.
-- First, I'll take a look at Medicare Advantage growth statistics from 2020-2024

DROP VIEW v_MA_bene_growth;

CREATE VIEW v_MA_bene_growth AS
SELECT
	g.BENE_STATE_DESC,
	SUM(CASE WHEN m.YEAR = 2020 THEN m.A_B_MA_AND_OTH_BENES END) AS val_2020,
	SUM(CASE WHEN m.YEAR = 2024 THEN m.A_B_MA_AND_OTH_BENES END) AS val_2024,
	(SUM(CASE WHEN m.YEAR = 2024 THEN m.A_B_MA_AND_OTH_BENES END) - SUM(CASE WHEN m.YEAR = 2020 THEN m.A_B_MA_AND_OTH_BENES END))
	/ SUM(CASE WHEN m.YEAR = 2020 THEN m.A_B_MA_AND_OTH_BENES END) * 100 AS growth_pct, 
    ROW_NUMBER() OVER (PARTITION BY BENE_STATE_DESC)
 FROM geography AS g
 JOIN medicare_info AS m
	ON g.BENE_FIPS_CD = m.BENE_FIPS_CD
 GROUP BY BENE_STATE_DESC;
 
 SELECT
	BENE_STATE_DESC,
    ROUND(growth_pct, 1) as growth_percent
FROM v_MA_bene_growth
ORDER BY growth_percent DESC;


-- From this, the fastest growing states for MA acquistion are North Dakota, Nebraska, South Dakota, Kansas and Iowa.
