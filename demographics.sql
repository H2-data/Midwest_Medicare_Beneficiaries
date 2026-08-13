-- Active: 1780043201174@@127.0.0.1@3306@beneficiaries
-- Active: 1780043201174@@127.0.0.1@3306@medidrugs

-- Here, I'll get percentage distributions for ethnicity, gender and dual status.

-- First, I will create a view that contains the proper metrics for this dataset.
-- This dataset features snapshot data, so I'll need to:
-- Aggregate AVERAGE benes for each category by year, month and county.
-- SUM the values for each county and then group by state.
DROP VIEW v_monthly_county_avg_demo;
CREATE VIEW v_monthly_county_avg_demo AS
SELECT
    d.BENE_COUNTY_DESC,
    d.BENE_STATE_DESC,
    d.YEAR,
    AVG(d.WHITE_TOT_BENES) AS white,
    AVG(d.BLACK_TOT_BENES) AS black,
    AVG(d.NATIND_TOT_BENES) AS natind,
    AVG(d.API_TOT_BENES) AS api,
    AVG(d.HSPNC_TOT_BENES) AS hspnc,
    AVG(d.OTHR_TOT_BENES) AS other,
    AVG(d.MALE_TOT_BENES) AS male,
    AVG(d.FEMALE_TOT_BENES) AS female,
    AVG(du.DUAL_TOT_BENES) AS _dual,
    AVG(du.NODUAL_TOT_BENES) AS nodual,
    AVG(m.TOT_BENES) AS total
FROM demographics AS d
JOIN medicare_info AS m
    ON d.index = m.index
JOIN dual_info AS du
    ON du.index = m.index
GROUP BY d.YEAR, d.BENE_COUNTY_DESC, d.BENE_STATE_DESC;

SELECT * FROM v_monthly_county_avg_demo;

-- Next, I'll start by using this view to collect state by state ethnicity metrics.

SELECT
    BENE_STATE_DESC,
    ROUND(SUM(white) / SUM(total) *  100, 2) AS White_Pct,
    ROUND(SUM(black) / SUM(total) *  100, 2) AS Black_Pct,
    ROUND(SUM(natind) / SUM(total) *  100, 2) AS Natind_Pct,
    ROUND(SUM(api) / SUM(total) *  100, 2) AS API_Pct,
    ROUND(SUM(hspnc) / SUM(total) *  100, 2) AS Hspnc_Pct,
    ROUND(SUM(other) / SUM(total) *  100, 2) AS Other_Pct
FROM v_monthly_county_avg_demo
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

-- Sanity Checks

SELECT
    BENE_STATE_DESC,
    SUM(white),
    SUM(black),
    SUM(natind),
    SUM(api),
    SUM(hspnc),
    SUM(other)
FROM v_monthly_county_avg_demo
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

-- The numbers appear correct, they aren't over-inflated and they match the percentages.

SELECT
    d.BENE_COUNTY_DESC,
    d.BENE_STATE_DESC,
    d.YEAR,
    d.MONTH,
    m.TOT_BENES
FROM demographics AS d
JOIN medicare_info AS m
    ON d.index = m.index
WHERE d.BENE_COUNTY_DESC = 'Adams County'
AND d.BENE_STATE_DESC = 'Illinois' 
AND d.YEAR = 2024;

-- When manually adding the filtered numbers from this query, the answer is 15045.91
-- This matches the number for this year in the original subquery when 'Month' is removed.
-- Furthermore, when manually adding the percentages together in the original subquery, it's easy to get 99 across the board.
-- Since the data structure and code structure will be identical across the remaining demographics, I will skip checks henceforth
-- UNLESS something in the output seems very very off.

-- Next, I'll repeat the process for gender. 

SELECT
    BENE_STATE_DESC,
    ROUND(SUM(male) / SUM(total) *  100, 2) AS Male_Pct,
    ROUND(SUM(female) / SUM(total) *  100, 2) AS Female_Pct
FROM v_monthly_county_avg_demo
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

-- Lastly, I'll take dual coverage distributions.

SELECT
    BENE_STATE_DESC,
    ROUND(SUM(_dual) / SUM(total) *  100, 2) AS Dual_Pct,
    ROUND(SUM(nodual) / SUM(total) *  100, 2) AS Nodual_Pct
FROM v_monthly_county_avg_demo
WHERE YEAR = 2024
GROUP BY BENE_STATE_DESC;

-- All results look neat, but bear in mind:
-- Some ethnicity values are null on account of incomplete master data or lack of certain distributions by county/state.