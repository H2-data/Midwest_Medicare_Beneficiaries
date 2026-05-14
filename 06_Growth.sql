
-- Here, I will record some growth metrics to see the fastest growing states in regards to beneficiaries.
-- First, I'll take a look at Medicare Advantage growth statistics from 2020-2024

DROP VIEW extra_growth;

CREATE VIEW extra_growth AS
SELECT
	BENE_STATE_DESC,
	SUM(CASE WHEN YEAR = 2020 THEN A_B_MA_AND_OTH_BENES END) AS val_2020,
	SUM(CASE WHEN YEAR = 2024 THEN A_B_MA_AND_OTH_BENES END) AS val_2024,
	(SUM(CASE WHEN YEAR = 2024 THEN A_B_MA_AND_OTH_BENES END) - SUM(CASE WHEN year = 2020 THEN A_B_MA_AND_OTH_BENES END))
	/ SUM(CASE WHEN year = 2020 THEN A_B_MA_AND_OTH_BENES END) * 100 AS growth_pct, 
    ROW_NUMBER() OVER (PARTITION BY BENE_STATE_DESC)
 FROM beneficiaries
 GROUP BY BENE_STATE_DESC;
 
 SELECT
	BENE_STATE_DESC,
    ROUND(growth_pct, 1) as growth_percent
FROM extra_growth
ORDER BY growth_percent DESC;

-- From this, the fastest growing states for MA acquistion are North Dakota, Nebraska, South Dakota, Kansas and Iowa.
