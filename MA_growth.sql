-- Active: 1780043201174@@127.0.0.1@3306@beneficiaries

-- Here, I will record some growth metrics to see the fastest growing states in regards to beneficiaries.
-- First, I'll take a look at Medicare Advantage growth statistics from 2020-2024

DROP VIEW v_MA_bene_growth;

-- I want to implement COALESCE into my CASE statement here. 0 just means no growth data.
-- Maybe turn this into a CTE and then specify coalese with math. Maybe. This is too goddamn heavy, fix it.
CREATE VIEW v_MA_bene_growth AS
SELECT
	g.BENE_STATE_DESC,
	SUM(CASE WHEN m.YEAR = 2020 THEN COALESCE(m.A_B_MA_AND_OTH_BENES, 0) END) AS val_2020,
	SUM(CASE WHEN m.YEAR = 2024 THEN COALESCE(m.A_B_MA_AND_OTH_BENES, 0) END) AS val_2024,
	(SUM(CASE WHEN m.YEAR = 2024 THEN COALESCE(m.A_B_MA_AND_OTH_BENES, 0) END) - SUM(CASE WHEN m.YEAR = 2020 THEN COALESCE(m.A_B_MA_AND_OTH_BENES, 0) END))
	/ SUM(CASE WHEN m.YEAR = 2020 THEN COALESCE(m.A_B_MA_AND_OTH_BENES, 0) END) * 100 AS growth_pct, 
    ROW_NUMBER() OVER (PARTITION BY BENE_STATE_DESC)
 FROM geography AS g
 JOIN medicare_info AS m
	ON g.index = m.index -- Rename this with table key + id (eg GeographyID, MedinfoID)
 GROUP BY BENE_STATE_DESC;
 
 -- Sanity Check

 SELECT
	BENE_STATE_DESC,
    ROUND(growth_pct, 1) as growth_percent
FROM v_MA_bene_growth
WHERE BENE_STATE_DESC = 'North Dakota'
ORDER BY growth_percent DESC;

-- North Dakota's Growth Percent is 89.6

SELECT
	g.BENE_STATE_DESC,
	SUM(CASE WHEN m.YEAR = 2020 THEN m.A_B_MA_AND_OTH_BENES END) AS val_2020,
	SUM(CASE WHEN m.YEAR = 2024 THEN m.A_B_MA_AND_OTH_BENES END) AS val_2024
 FROM geography AS g
 JOIN medicare_info AS m
	ON g.index = m.index
WHERE g.BENE_STATE_DESC = 'North Dakota';

-- The 2020 value is 320540. The 2024 value is 607669.
-- When these numbers are manually calculated, the total is 89.6, which matches the previous query.


-- From this, the fastest growing states for MA acquistion are North Dakota, Nebraska, South Dakota, Kansas and Iowa.
