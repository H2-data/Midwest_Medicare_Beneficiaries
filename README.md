<div align="center">

# Medicare Beneficiaries in the Midwest

</div>

---

## **Important Notes:**

### **The Data:**

The data for this project was obtained from the following sources:

- A **publicly available** dataset containing Medicare Beneficiary enrollment information from 2013 to 2025. It was created by the Centers for Medicare and Medicaid Services (CMS).

[Data Source](https://data.cms.gov/resources/medicare-monthly-enrollment-data-dictionary)

[Dataset](https://github.com/H2-data/Midwest_Medicare_Beneficiaries/blob/undo_merge/beneficiaries_data.zip)

### **How to Read and Run This Repository:**

- To test the code on this project, you will need access to the following resources:
  
  	- Visual Studio Code (Or any other all-inclusive coding environment.)
  	- A MySQL environment extension
  	- Power BI Desktop
  	- An OBDC Connector
  	- A Python environment extension with the following libraries installed:
 
      - Pandas
	  - Numpy
	  - Matplotlib
	  - Seaborn
      - SQLalchemy

**Step 1.** Plug the CSV file into the python script and run it until you reach the 'Database Creation' section. 

**Step 2.** Once you get to the Database Creation section, you can put the username, password and database name into the SQL alchemy engine object. Then run the code. It should slice the cleaned data into tables and send them to the database.

**Step 3.** Run the SQL code in your SQL environment.

**Step 4.** Open the Power BI pbix file.

**Step 5.** You need to have an ODBC connector since the code is MySQL. Once you've created the connection object, you can connect the database to Power BI using the Power Query and add all tables when prompted. This should activate the dashboard.

### **Who is the Project's Intended Recipient?:**

- **The Superduper Insurance marketing expansion team** in charge of selecting state-by-state policy distribution for the upcoming Medicare Advantage program rollout. In this report, they will be able to see the top states based on their demand for MA and overall beneficiary population, so it will be clear which areas to prioritize during the rollout.

- The **project managers in charge of advertising** for the upcoming MA rollout. In this report, they will be able to see the demographic distributions of Medicare beneficiaries in the target states, so it will be clear who to advertise for in each area.
___

## **Scenario and Objective:**

Superduper Insurance (not a real company) is an insurance company specializing in Medicare Supplements. They have recently expanded and are planning to roll out new Medicare Advantage policies. The initial rollout will take place in the Midwest region of the US, containing the following states:

**North Dakota, South Dakota, Minnesota, Wisconsin, Michigan, Iowa, Illinois, Indiana, Ohio, Nebraska, Missouri and Kansas**

Traditionally, Medicare Advantage policy accessibility is based on location, so it's important to understand beneficiary distributions to decide which policies should go to which states. Furthermore, the marketing team needs a solid grasp of demographic distributions in order to conduct a successful ad campaign for the new MA program. I have been tasked to conduct an analysis on CMS Medicare Beneficiary data in order to answer the following questions:

- **Which states and counties have the highest demand for Medicare Advantage policies?**
- **What are the demographic distributions of each state?**

### **Data Report:**

<img width="1286" height="720" alt="Screenshot 2026-08-17 152614" src="https://github.com/user-attachments/assets/cebc7181-5f46-4f1c-a389-63dd3de44847" />
<br>

## **Data Preprocessing:**

Aside from generic data preprocessing (outlier management, missing values and duplicates) there was a major challenge in preparing the data... The data itself. There are dozens of different types of Medicare beneficiaries, and because CMS likes to be thorough, some columns are calculations of other columns, which can greatly damage the intergity of the analysis. This problem was so prevalant, I created an entire seperate section dedicated to untangling the mess, linked [HERE](https://github.com/H2-data/Midwest_Medicare_Beneficiaries/blob/undo_merge/The%20CMS%20Mess.md)

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

To see the other tests I ran as well as the rest of the preprocessing, please refer to the Python preprocessing portion of this project, linked [HERE](https://github.com/H2-data/Midwest_Medicare_Beneficiaries/blob/undo_merge/midwest_benes_cleaning.ipynb).
___

## **How can I solve the problem?**

At it's core, this project can be boiled down to 2 simple questions:

- What is the demand for Medicare advantage?
- What kinds of people are in each state?

The first question is the more challenging of the two, but the data does provide a solid answer. There are many different types of beneficiaries in the dataset, and each kind of beneficiary has a certain level of implied demand for Medicare Advantage. For example, someone in the MA_AND_OTH_BENES column might have lower demand, because as the column name implies, they already have Part C or other additional coverage. However, people in the A_B_ORGNL_MDCR_BENES column might have higher demand, since they only have Medicare Part A and B. The data clearly shows that people with Part A and Part B with no additional coverage are on the decline, while people with A, B and additional coverage are on the rise as shown here:

<img width="1153" height="332" alt="Screenshot 2026-08-17 154452" src="https://github.com/user-attachments/assets/5c6c4dd4-956b-4860-abda-4a62b1670798" />
<br>

Every single Midwest state has this trend, the difference is when it started. In Wisconsin, Ohio, Michigan, Minnesota and Missouri (And the Dakotas, not depicted here) the trend began earlier, around 2020. In Illinois, Indiana, Iowa, Kansas and Nebraska, the trend began more recently. The more recent the trend, the greater the possible market gap. **The bottom 5 states here should be given special attention.**

Because of this trend, I can make an inference to gauge demand:

- **Beneficiaries with only Part A and Part B have an implied demand for Medicare Advantage.**

The second question regarding demographics is much simpler. The data has the age sex, ethnicty and Medicaid status of Medicare beneficiaries in neat columns. Since the columns contain the total number of beneficiaries per demographic, I can't calculate an implied demand, but I can find a distribution, which should be enough until additional data is acquired during the rollout.
___

## **Results and Observations:**

### **Outliers:**

- **White** is the dominant demographic across every single state by several magnitudes, it's about 85% of the midwest population. I want to get a better idea of secondary demographics, so I have removed it from the ethnicity visuals, but it is always the main demographic.

- **Cook County** is the most populous county in the midwest region due to Chicago being there, it's a massive outlier that distorts everything around it. It will be acknowledged and removed from the analysis to keep visuals clear, but it should be considered a top priority.

<div align="center">
    
<img width="1070" height="182" alt="Screenshot 2026-08-17 155638" src="https://github.com/user-attachments/assets/ac886995-1cff-4ff2-a995-516f18067b01" /> 
</div>
<br>
  
Let's go through and answer each data question using visuals and tables from the report.

### **Which States have the highest demand for Medicare Advantage?**

<img width="968" height="317" alt="Screenshot 2026-08-17 200027" src="https://github.com/user-attachments/assets/0874f3d0-67fd-4e7d-b0b1-a022873d8293" />

<br>  

### **Which counties have the highest demand for Medicare Advantage?**

This README is designed to be summative, so I will provide the top 5 counties for the top 5 states, but all county rankings by state can be found on the interactive dashboard and in the SQL 'demographics' file, linked [HERE](https://github.com/H2-data/Midwest_Medicare_Beneficiaries/blob/undo_merge/demographics.sql).

<img width="1048" height="216" alt="Screenshot 2026-08-17 200532" src="https://github.com/user-attachments/assets/392c3705-c306-4d96-9902-4eab66bf8a5c" />
<img width="1050" height="215" alt="Screenshot 2026-08-17 200546" src="https://github.com/user-attachments/assets/110a1166-97e9-4576-82bd-031b4c42004e" />
<img width="1052" height="217" alt="Screenshot 2026-08-17 200601" src="https://github.com/user-attachments/assets/ba515e5c-059f-4c6a-8c95-6d478198d91d" />
<img width="1048" height="216" alt="Screenshot 2026-08-17 200618" src="https://github.com/user-attachments/assets/f6bfa071-7d45-4dea-99f4-d7eac1aca35c" />
<img width="1052" height="213" alt="Screenshot 2026-08-17 200632" src="https://github.com/user-attachments/assets/5d9c87a2-c064-43e2-aa92-4dee6f833a74" />
<br>

- The states with the highest current demand for Medicare advantage according to my ratio are **Illinois, Ohio, Michigan, Indiana and Missouri**. Illinois has a high ranking whether or not Cook County is factored in.

- The see the County MA Demand Ranking for all states, please refer to the SQL report linked [HERE](https://github.com/H2-data/Midwest_Medicare_Beneficiaries/blob/undo_merge/MA_demand.sql) for the ranking and [HERE](https://github.com/H2-data/Midwest_Medicare_Beneficiaries/blob/undo_merge/MA_demand.sql) for growth. I'd recommend prioritizing the following:

	- The top 5 counties for the top 5 results. MAKE SURE TO INCLUDE COOK COUNTY FOR ILLINOIS, I have removed it from visuals to avoid visual skew but it's population alone makes it top priority.
	- The top 5 counties for Kansas, Nebraska and Iowa on account of their market opening.
	- The top 5 counties for Nebraska, Kansas, and Iowa on account of their MA policy growth from 2020-2024. North Dakota and South Dakota also had a high growth rate, but their beneficiary populations are some of the lowest.

### **What are the demographic distributions of the midwest?**

<img width="1178" height="311" alt="Screenshot 2026-08-17 202740" src="https://github.com/user-attachments/assets/4368eaee-bd76-4cbf-bea3-46558ca4fc83" />
<br>
<br>

- The dominant demographic for the Midwest overall is **white women aged 65-75 with no dual coverage**. There have not been any major demographic shifts during this time period.
- Females and Males are an almost perfect 55-45 split, so it shouldn't be weighed too heavily in marketing decisions.
- The secondary ethnic demographics in regards to beneficiary distribution for the Midwest are black beneficiaries (secondary) and Hispanic beneficiaries (tertiary).
- Beneficiaries under 64 do not make for an effective target demographic.

### **Specific State Details:**

- North Dakota and South Dakota have a uniquely high population of Native American beneficiaries as their secondary demographic for marketing purposes.
- Michigan, Ohio and Missouri have a uniquely high population of black beneficiaries as their secondary demographic for marketing purposes.
- Most states have a majority of demand beneficiaries centralized in the top 3 counties.
