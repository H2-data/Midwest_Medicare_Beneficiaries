-- Active: 1780043201174@@127.0.0.1@3306@beneficiaries
-- Active: 1780043201174@@127.0.0.1@3306@medidrugs

-- Here, I'll get percentage distributions for ethnicity, gender and dual status.

-- First, ethnicity:

DROP VIEW v_bene_eth_dist;

CREATE VIEW v_bene_eth_dist AS
SELECT
	g.BENE_STATE_DESC,
    m.YEAR,
    SUM(COALESCE(d.WHITE_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS white_demo_pct, 
    SUM(COALESCE(d.BLACK_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS black_demo_pct, 
    SUM(COALESCE(d.NATIND_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS natind_demo_pct, 
    SUM(COALESCE(d.API_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS api_demo_pct, 
    SUM(COALESCE(d.HSPNC_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS hsp_demo_pct, 
    SUM(COALESCE(d.OTHR_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS oth_demo_pct,
	ROW_NUMBER() OVER (PARTITION BY g.BENE_STATE_DESC)
FROM demographics AS d
    JOIN geography AS g ON d.index = g.index
    JOIN medicare_info AS m ON g.index = m.index
GROUP BY g.BENE_STATE_DESC, m.YEAR;

SELECT 
	BENE_STATE_DESC,
    ROUND(white_demo_pct, 1) AS White, 
    ROUND(black_demo_pct, 1) AS Black, 
    ROUND(natind_demo_pct, 1) AS Native_American,
    ROUND(api_demo_pct, 1) AS Asian_PI, 
    ROUND(hsp_demo_pct, 1) AS Hispanic, 
    ROUND(oth_demo_pct, 1) AS Other
FROM v_bene_eth_dist
WHERE BENE_STATE_DESC = 'South Dakota' AND
YEAR = '2024';

SELECT
    g.BENE_STATE_DESC,
    SUM(COALESCE(m.TOT_BENES, 0)) AS total_benes,
    SUM(COALESCE(d.WHITE_TOT_BENES
    + d.BLACK_TOT_BENES 
    + d.NATIND_TOT_BENES 
    + d.API_TOT_BENES 
    + d.HSPNC_TOT_BENES 
    + d.OTHR_TOT_BENES, 0)) AS total_eths
FROM medicare_info AS m
JOIN demographics AS d
    ON m.index = d.index
JOIN geography AS g
    ON m.index = g.index
WHERE m.YEAR = 2024 AND
g.BENE_STATE_DESC = 'Wisconsin'
GROUP BY BENE_STATE_DESC;

SELECT * FROM demographics;


-- Next, I'll repeat the process for gender. It's the same code, juse different columns:

DROP VIEW v_bene_gender_dist;

CREATE VIEW v_bene_gender_dist AS
SELECT
	g.BENE_STATE_DESC,
    m.YEAR,
    SUM(COALESCE(d.MALE_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS male_bene_pct, 
    SUM(COALESCE(d.FEMALE_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS female_bene_pct,
	ROW_NUMBER() OVER (PARTITION BY g.BENE_STATE_DESC)
FROM demographics AS d
    JOIN geography AS g ON d.index = g.index
    JOIN medicare_info AS m ON g.index = m.index
GROUP BY BENE_STATE_DESC, YEAR;

SELECT 
	BENE_STATE_DESC,
    ROUND(male_bene_pct, 1) AS Male, 
    ROUND(female_bene_pct, 1) AS Female
FROM v_bene_gender_dist
WHERE YEAR = '2024' AND
BENE_STATE_DESC = 'Michigan';

-- Lastly, I'll take dual coverage distributions.

DROP VIEW v_dual_benes_dist;

CREATE VIEW v_dual_benes_dist AS
SELECT
	g.BENE_STATE_DESC,
    m.YEAR,
    SUM(COALESCE(d.DUAL_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS dual_pct, 
    SUM(COALESCE(d.NODUAL_TOT_BENES, 0)) / SUM(COALESCE(m.TOT_BENES, 0)) * 100 AS nodual_pct,
	ROW_NUMBER() OVER (PARTITION BY g.BENE_STATE_DESC)
FROM dual_info AS d
    JOIN geography AS g ON d.index = g.index
    JOIN medicare_info AS m ON g.index = m.index
GROUP BY BENE_STATE_DESC, YEAR;

SELECT 
	BENE_STATE_DESC,
    ROUND(dual_pct, 1) AS Dual_Coverage,
    ROUND(nodual_pct, 1) AS No_Dual_Coverage
FROM v_dual_benes_dist
WHERE YEAR = '2024'
AND BENE_STATE_DESC = 'Illinois';

-- To sanity check each one, I added up all the numbers in the output. 
-- Each time, they ended up between 99.8-100 to account for rounding.