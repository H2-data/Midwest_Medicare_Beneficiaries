# Data Dictionary II: The CMS Mess

It's important to note that a lot of these columns are calculations of other columns. This can be frustrating, but after going through each subsection (Demographics, Medicare, Medicaid and Prescription Drug) I sorted out which columns were calculated within each other. From this, I chose the columns that would be most useful in answering the question: Which populations have a high number of people eligible for Medicare Advantage without having it? The Data Dictionary does not mention some of these column calculations, so I will list the important ones here. In this section, I will also talk about columns that seem to have redundant information.

___

TOT_BENES: It's also ORGNL_MDCR_BENES + MA_AND_OTH_BENES
TOT_BENES: It's also all columns between AGE_LT_25_BENES to AGE_GT_94_BENES
TOT_BENES: It's also MALE_TOT_BENES + FEMALE_TOT_BENES
TOT_BENES: This is DUAL_TOT_BENES + NO_DUAL_TOT_BENES
TOT_BENES: It's also AGED_ESRD_BENES + AGED_NO_ESRD_BENES + DSBLD_TOT_BENES

DSBLD_TOT_BENES: This is DSBLD_ESRD_AND_ESRD_ONLY_BENES + DSBLD_NO_ESRD_BENES. All the columns making up this value are individual demographics that can be added.

MA_AND_OTH_BENES: This column is actually repeated 4 times. The columns A_B_MA_AND_OTH_BENES, A_MA_AND_OTH_BENES and B_MA_AND_OTH_BENES have the same number as MA_AND_OTH_BENES. This is because if someone has MA, they specifically need Part A AND Part B. I will be dropping the A_B_MA, A_MA and B_MA columns because they serve no function.

ORGNL_MDCR_BENES: This is beneficiaries who have Part A OR Part B or Part A AND Part B with no additional coverage. This one should be dropped in favor of A_B_ORGNL_MDCR_BENES because it's too broad to use.

A_B_ORGNL_MDCR_BENES: This is Part A AND Part B with nothing else. This is most likely the most useful column in this dataset for the task at hand because it includes the people who are eligible for MA and that don't already have it, indicating demand.

A_B_TOT_BENES: This is A_B_ORGNL_MDCR_BENES + A_B_MA_AND_OTH_BENES. It is basically anyone that has Part A AND Part B, including people with or without MA.

A_ORGNL_MDCR_BENES: This includes people who have Part A and nothing else (No Part B, no MA).

A_TOT_BENES: This is A_ORGNL_MDCR_BENES + MA_AND_OTH_BENES. It's basically anyone who has either Part A, Part A + Part B or Part A + Part B + MA.

You can apply the logic of A_ORGNL_MDCR_BENES TO B_ORGNL_MDCR_BENES and A_TOT_BENES to B_TOT_BENES.

DUAL_TOT_BENES: This is QMB_PLUS_BENES + QMB_ONLY_BENES + SLMB_PLUS_BENES + SLMB_ONLY_BENES + QDWI_QI_BENES + OTHR_FULL_DUAL_MDCD_BENES. All the columns making up this number are individual demographics that can be added.

FULL_DUAL_TOT_BENES: This is SLMB_PLUS_BENES + QMB_PLUS_BENES + OTHR_FULL_DUAL_MDCD_BENES. I will not use this, as DUAL_TOT_BENES includes this number while also being more useful.

NODUAL_TOT_BENES: This column is TOT_BENES - DUAL_TOT_BENES. It's a leftover column of all Medicare beneficiaries that are NOT dual eligible. This may be useful for comparing eligible beneficiaries to ineligible beneficiaries.

PRSCRPTN_DRUG_TOT_BENES: This is PRSCRPTN_DRUG_PDP_BENES + PRSCRPTN_DRUG_MAPD_BENES. 
PRSCRPTN_DRUG_TOT_BENES: This is PRSCRPTN_DRUG_DEEMED_ELIGIBLE_FULL_LIS_BENES + PRSCRPTN_DRUG_FULL_LIS_BENES + PRSCRPTN_DRUG_PARTIAL_LIS_BENES + PRSCRPTN_DRUG_NO_LIS_BENES.

All of the LIS columns: If someone has LIS, then it's not guaranteed they have both Part A and Part B, as LIS usually only requires one or the other. However, LIS is an SEP for MA, so it might be worth using these columns as supplementary supporting data.

___

Now that we have a good idea of what these numbers mean and how they may overlap, here are the columns that can be most effectively used to determine MA eligibility. I will also include columns that are useful overall:

DUAL_TOT_BENES: This includes the beneficiaries who have any level of Medicaid coverage. For most Medicaid savings programs, a beneficiary must have Part A AND Part B, so anyone falling into this demographic is highly likely to be eligible.

A_B_ORGNL_MDCR_BENES: This includes beneficiaries with Part A, Part B and no extra coverage. It is probably the most useful column in the entire dataset, because it shows people who might be eligible for MA but don't have it, indicating a demand.

A_B_ORGNL_MDCR_BENES + A_B_MA_AND_OTH_BENES: These two columns make up A_B_TOT_BENES. It's useful to compare them together because it shows the number of eligible beneficiaries who have MA vs the eligible beneficiaries who don't.

TOT_BENES: This column is what I will compare everything to. I'll compare the total beneficiaries to the total number of people eligible for MA.
