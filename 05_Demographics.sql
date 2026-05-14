
-- Here, I'll get percentage distributions for ethnicity, gender and dual status.

-- First, ethnicity:

DROP VIEW eth_dist;

CREATE VIEW eth_dist AS
SELECT
	BENE_STATE_DESC,
    SUM(WHITE_TOT_BENES) / SUM(TOT_BENES) * 100 AS white_demo_pct, 
    SUM(BLACK_TOT_BENES) / SUM(TOT_BENES) * 100 AS black_demo_pct, 
    SUM(NATIND_TOT_BENES) / SUM(TOT_BENES) * 100 AS natind_demo_pct, 
    SUM(API_TOT_BENES) / SUM(TOT_BENES) * 100 AS api_demo_pct, 
    SUM(HSPNC_TOT_BENES) / SUM(TOT_BENES) * 100 AS hsp_demo_pct, 
    SUM(OTHR_TOT_BENES) / SUM(TOT_BENES) * 100 AS oth_demo_pct,
	ROW_NUMBER() OVER (PARTITION BY BENE_STATE_DESC)
FROM beneficiaries
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

SELECT 
	BENE_STATE_DESC,
    ROUND(white_demo_pct, 1) AS White, 
    ROUND(black_demo_pct, 1) AS Black, 
    ROUND(natind_demo_pct, 1) AS Native_American,
    ROUND(api_demo_pct, 1) AS Asian_PI, 
    ROUND(hsp_demo_pct, 1) AS Hispanic, 
    ROUND(oth_demo_pct, 1) AS Other
FROM eth_dist;

-- Next, I'll repeat the process for gender. It's the same code, juse different columns:

DROP VIEW gender_dist;

CREATE VIEW gender_dist AS
SELECT
	BENE_STATE_DESC,
    SUM(MALE_TOT_BENES) / SUM(TOT_BENES) * 100 AS male_pct, 
    SUM(FEMALE_TOT_BENES) / SUM(TOT_BENES) * 100 AS female_pct,
	ROW_NUMBER() OVER (PARTITION BY BENE_STATE_DESC)
FROM beneficiaries
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

SELECT 
	BENE_STATE_DESC,
    ROUND(male_pct, 1) AS Male, 
    ROUND(female_pct, 1) AS Female
FROM gender_dist;

-- Lastly, I'll take dual coverage distributions.

DROP VIEW dual_dist;

CREATE VIEW dual_dist AS
SELECT
	BENE_STATE_DESC,
    SUM(DUAL_TOT_BENES) / SUM(TOT_BENES) * 100 AS dual_pct, 
    SUM(NODUAL_TOT_BENES) / SUM(TOT_BENES) * 100 AS nodual_pct,
	ROW_NUMBER() OVER (PARTITION BY BENE_STATE_DESC)
FROM beneficiaries
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

SELECT 
	BENE_STATE_DESC,
    ROUND(dual_pct, 1) AS Dual_Coverage,
    ROUND(nodual_pct, 1) AS No_Dual_Coverage
FROM dual_dist;