<div align="center">

# Medicare Beneficiaries in the Midwest

</div>

---

### **Scenario and Objective:**

Superduper Insurance (not a real company) is an insurance company specializing in Medicare Supplements. They have recently expanded and are planning to roll out new Medicare Advantage policies. The initial rollout will take place in the Midwest region of the US, containing the following states:

**North Dakota, South Dakota, Minnesota, Wisconsin, Michigan, Iowa, Illinois, Indiana, Ohio, Nebraska, Missouri and Kansas**

Traditionally, Medicare Advantage policy accessibility is based on location, so it's important to understand beneficiary distributions to decide which policies should go to which states. Furthermore, the marketing team needs a solid grasp of demographic distributions in order to conduct a successful ad campaign for the new MA program. I have been tasked to conduct an analysis on CMS Medicare Beneficiary data in order to answer the following questions:

- **Which states and counties have the highest demand for Medicare Advantage policies?**
- **What are the demographic distributions of each state?**

### **Data Report:**

<img width="1285" height="718" alt="image" src="https://github.com/user-attachments/assets/96df4494-8c0c-4f48-a350-4f733fc382b9" />
<br>

To interact with the dashboard or see individual state and year distributions, see the Power BI section of the project, linked here:

[INSERT LINK HERE]

### **Data Preprocessing:**

Aside from generic data preprocessing (outlier management, missing values and duplicates) there was a major challenge in preparing the data... The data itself. There are dozens of different types of Medicare beneficiaries, and because CMS likes to be thorough, some columns are calculations of other columns, which can greatly damage the intergity of the analysis. This problem was so prevalant, I created an entire seperate section dedicated to untangling the mess, linked below:

[INSERT NIGHTMARE LINK FROM HELL HERE]

For this summative README, I will provide one example. When I went through some of the lookup columns to find possible calculated columns, I stumbled across a data entry labled 'Year' in the 'Month' column. I suspected it might be a yearly calculation of the number of Medicare beneficiaries per a geographic level, so I tested it by filtering the data into state and then county. The county filtration provided my answer:

```Python
test = df3[
    (df3['MONTH'] == 'Year') &
    (df3['BENE_COUNTY_DESC'] == 'Adams County') &
    (df3['BENE_STATE_DESC'] == 'Ohio')
    ]

test[['YEAR', 'MONTH','BENE_STATE_ABRVTN', 'BENE_COUNTY_DESC', 'TOT_BENES']].set_index('YEAR')
```

|YEAR|MONTH|BENE\_STATE\_ABRVTN|BENE\_COUNTY\_DESC|TOT\_BENES|
|---|---|---|---|---|
|2020|Year|OH|Adams County|6520\.0|
|2021|Year|OH|Adams County|6548\.0|
|2022|Year|OH|Adams County|6511\.0|
|2023|Year|OH|Adams County|6731\.0|
|2024|Year|OH|Adams County|7061\.0|

Next, I tested another filtration constraint: I targeted the year 2020 to see how many times 'Year' popped up. The results further supported the theory that this was a calculation of one year in one county, since it only appeared once.

```Python
test2 = df3[
    (df3['BENE_COUNTY_DESC'] == 'Adams County') &
    (df3['BENE_STATE_DESC'] == 'Ohio') &
    (df3['YEAR'] == 2020)
    ]

test2[['YEAR', 'MONTH','BENE_STATE_ABRVTN', 'BENE_COUNTY_DESC', 'TOT_BENES']].set_index('YEAR')
```
    
|YEAR|MONTH|BENE\_STATE\_ABRVTN|BENE\_COUNTY\_DESC|TOT\_BENES|
|---|---|---|---|---|
|2020|Year|OH|Adams County|6520\.0|
|2020|January|OH|Adams County|6513\.0|
|2020|February|OH|Adams County|6510\.0|
|2020|March|OH|Adams County|6506\.0|
|2020|April|OH|Adams County|6518\.0|
|2020|May|OH|Adams County|6509\.0|
|2020|June|OH|Adams County|6511\.0|
|2020|July|OH|Adams County|6518\.0|
|2020|August|OH|Adams County|6525\.0|
|2020|September|OH|Adams County|6536\.0|
|2020|October|OH|Adams County|6535\.0|
|2020|November|OH|Adams County|6537\.0|
|2020|December|OH|Adams County|6517\.0|

Just to be extra super sure, I used .describe for the column TOT_BENES using my filtration constraints, and it turns out it was a yearly MEAN calculation, not a full sum. Still, a calculation is a calculation, so I took it out to preserve the integrity of the analysis.

To see the other tests I ran as well as the rest of the preprocessing, please refer to the Python preprocessing portion of this project, linked here:

[INSERT LINK HERE]

### **How can I solve the problem?**

At it's core, this project can be boiled down to 2 simple questions:

- What is the demand for Medicare advantage?
- What kinds of people are in each state?

The first question is the more challenging of the two, but the data does provide a solid answer. There are many different types of beneficiaries in the dataset, and each kind of beneficiary has a certain level of implied demand for Medicare Advantage. For example, someone in the MA_AND_OTH_BENES column might have lower demand, because as the column name implies, they already have Part C or other additional coverage. However, people in the A_B_ORGNL_MDCR_BENES column might have higher demand, since they only have Medicare Part A and B. The data clearly shows that people with Part A and Part B with no additional coverage are on the decline, while people with both kinds of coverage are on the rise as shown here:

<img width="1096" height="272" alt="image" src="https://github.com/user-attachments/assets/a6bbb156-ac63-4df4-a36f-ff1ea15636f3" />
<br>

Every single Midwest state has this trend, the difference is when it started. In Wisconsin, Ohio, Michigan, Minnesota and Missouri (And the Dakotas, not depicted here) the trend began earlier, around 2020. In Illinois, Indiana, Iowa, Kansas and Nebraska, the trend began more recently. The more recent the trend, the greater the possible market gap. **The bottom 5 states here should be given special attention.**

That would make for an easy ratio, but there's just one other problem: Population. Even if a location has high demand, focusing the campaign on low-population areas could result in less return overall. In order to properly gauge Opportunity, we must take into account the following:

- Areas with a high population of beneficiaries with BOTH A and B.
- Areas with a high population of beneficiaries without Part C or other additional coverage.
- Areas with a high Medicare beneficiary population overall.

This is the sweet spot, and after untangling the CMS data, I found the correct pieces to make the following ratio:

```SQL
(A_B_TOT_BENES) * (1 - SUM(A_B_MA_AND_OTH_BENES) / TOT_BENES)
```

The second question regarding demographics is much simpler. The data has the age sex, ethnicty and medicaid status of Medicare beneficiaries in respective neat columns. Since the columns contain the total number of beneficiaries per demographic, I can't calculate an implied demand, but I can find a distribution, which should be enough until additional data is acquired during the rollout.

### **Results and Observations:**

Important Notes:

- 'White' is the dominant demographic across every single state by several magnitudes, it's about 85% of the midwest population. I want to get a better idea of secondary demographics, so I have removed it from the ethnicity visuals, but it is always the main demographic.

- Cook County is the most populous county in the midwest region due to Chicago being there, it's a massive outlier that distorts everything around it. It will be acknowledged and removed from the analysis to keep visuals clear, but it should be considered a top priority.

<div align="center">
    
<img width="832" height="190" alt="image" src="https://github.com/user-attachments/assets/be20411f-4f6b-4f65-aa54-bc9b0006729b" />  
</div>
<br>
  
Let's go through and answer each data question using visuals and tables from the report.

- **Which States have the highest demand for Medicare Advantage?**

<img width="1096" height="341" alt="image" src="https://github.com/user-attachments/assets/48018698-f1f1-4020-96e0-acacc17bf933" />  
<br>  
<br>
  
- **Which counties have the highest demand for Medicare Advantage?**

This README is designed to be summative, so I will provide the top 5 counties for the top 3 states, but all county rankings by state can be found on the interactive dashboard and in the SQL 'demographics' file, linked below.

<img width="1162" height="217" alt="image" src="https://github.com/user-attachments/assets/433c5e69-8a5c-4965-9410-9f523d32e524" />
<img width="1162" height="216" alt="image" src="https://github.com/user-attachments/assets/433fde08-0773-4e20-84c1-61184e309d34" /> 
<img width="1158" height="217" alt="image" src="https://github.com/user-attachments/assets/8c05ac8d-18a0-47cb-9e7a-82bf9334c6dc" />  
<br>
<br>

- **What are the demographic distributions of the midwest?**

<img width="1182" height="310" alt="image" src="https://github.com/user-attachments/assets/0662e1db-4a31-4c54-8f3c-03854f7b9827" />
<br>
<br>

- **What are the demographic distributions for each state?**

This README is designed to be summative, to see state by state demographic percentage data, see the SQL portion of the analysis, linked here:

[insert SQL link here]

