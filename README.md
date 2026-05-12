<div align="center">

# Medicare Beneficiaries in the Midwest

</div>

---

### **Scenario and Objective:**

Superduper Insurance (not a real company) is an insurance company specializing in Medicare Supplements. However, they have recently expanded and are planning to roll out new Medicare Advantage Policies. The initial rollout will take place in the Midwest region of the US, containing the following states:

North Dakota South Dakota Minnesota, Wisconsin, Michigan, Iowa, Illinois, Indiana, Ohio, Nebraska, Missouri and Kansas

Traditionally, Medicare Advantage policy accessibility is based on location, so it's important to understand beneficiary distributions to decide which policies should go to which states. Furthermore, the marketing team needs a solid grasp of demographic distributions in order to conduct a successful ad campaign for the new MA program. I have been tasked to conduct an analysis on CMS Medicare Beneficiary data in order to answer the following questions:

- Which states and counties have the highest demand for Medicare Advantage policies.

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

test[['YEAR', 'MONTH','BENE_STATE_ABRVTN', 'BENE_COUNTY_DESC', 'TOT_BENES']].set_index('YEAR')```
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

The first question is the most challenging of the two, but the data does provide a solid answer. There are many, many, MANY different types of beneficiaries in the dataset, and each kind of beneficiary has a certain level of demand for Medicare Advantage. For example, someone in the __________ column might have less demand, because as the column name implies, they already have Part C or other additional coverage. However, people in the _________ column might have more, since they only have Medicare Part A and B. The data clearly shows that people with Part A and Part B with no additional coverage are on the decline, while people with both kinda of coverage are on the rise as shown here:

This chart shows data for the entire midwest region, but I found that every single state has some variation of this pattern. This means that people without extra coverage have implied demand.

That would make for an easy ratio, but there's just one other problem: Population. A ratio that only contains the number of people 

### **Results and Observations:**

Let's go through and answer each data question using visuals and tables from the report.

- 

### **Analyst Recommendations:**
