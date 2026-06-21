
-- Here, I'll get percentage distributions for ethnicity, gender and dual status.

-- First, ethnicity:

DROP VIEW v_bene_eth_dist;

CREATE VIEW v_bene_eth_dist AS
SELECT
	g.BENE_STATE_DESC,
    SUM(d.WHITE_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS white_demo_pct, 
    SUM(d.BLACK_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS black_demo_pct, 
    SUM(d.NATIND_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS natind_demo_pct, 
    SUM(d.API_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS api_demo_pct, 
    SUM(d.HSPNC_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS hsp_demo_pct, 
    SUM(d.OTHR_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS oth_demo_pct,
	ROW_NUMBER() OVER (PARTITION BY g.BENE_STATE_DESC)
FROM demographics AS d
    JOIN geography AS g ON d.BENE_FIPS_CD = g.BENE_FIPS_CD
    JOIN medicare_info AS m ON g.BENE_FIPS_CD = m.BENE_FIPS_CD
WHERE m.YEAR = 2024
GROUP BY BENE_STATE_DESC;

SELECT 
	BENE_STATE_DESC,
    ROUND(white_demo_pct, 1) AS White, 
    ROUND(black_demo_pct, 1) AS Black, 
    ROUND(natind_demo_pct, 1) AS Native_American,
    ROUND(api_demo_pct, 1) AS Asian_PI, 
    ROUND(hsp_demo_pct, 1) AS Hispanic, 
    ROUND(oth_demo_pct, 1) AS Other
FROM v_bene_eth_dist;

-- Next, I'll repeat the process for gender. It's the same code, juse different columns:

DROP VIEW v_bene_gender_dist;

CREATE VIEW v_bene_gender_dist AS
SELECT
	g.BENE_STATE_DESC,
    SUM(d.MALE_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS male_bene_pct, 
    SUM(d.FEMALE_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS female_bene_pct,
	ROW_NUMBER() OVER (PARTITION BY g.BENE_STATE_DESC)
FROM demographics AS d
    JOIN geography AS g ON d.BENE_FIPS_CD = g.BENE_FIPS_CD
    JOIN medicare_info AS m ON g.BENE_FIPS_CD = m.BENE_FIPS_CD
WHERE m.YEAR = 2024
GROUP BY BENE_STATE_DESC;

SELECT 
	BENE_STATE_DESC,
    ROUND(male_bene_pct, 1) AS Male, 
    ROUND(female_bene_pct, 1) AS Female
FROM v_bene_gender_dist;

-- Lastly, I'll take dual coverage distributions.

DROP VIEW v_dual_benes_dist;

CREATE VIEW v_dual_benes_dist AS
SELECT
	g.BENE_STATE_DESC,
    SUM(d.DUAL_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS dual_pct, 
    SUM(d.NODUAL_TOT_BENES) / SUM(m.TOT_BENES) * 100 AS nodual_pct,
	ROW_NUMBER() OVER (PARTITION BY g.BENE_STATE_DESC)
FROM dual_info AS d
    JOIN geography AS g ON d.BENE_FIPS_CD = g.BENE_FIPS_CD
    JOIN medicare_info AS m ON g.BENE_FIPS_CD = m.BENE_FIPS_CD
WHERE m.YEAR = 2024
GROUP BY BENE_STATE_DESC;

SELECT 
	BENE_STATE_DESC,
    ROUND(dual_pct, 1) AS Dual_Coverage,
    ROUND(nodual_pct, 1) AS No_Dual_Coverage
FROM v_dual_benes_dist;