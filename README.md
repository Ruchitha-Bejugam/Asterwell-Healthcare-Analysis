# Asterwell Healthcare Analytics

An end-to-end data analytics project: from messy raw data to a validated SQL database, a Power BI star-schema model with 29 DAX measures, a six-page executive dashboard, and a management paper with recommendations.

> \*\*Note:\*\* Asterwell Health \& Services Ltd is a \*\*fictional\*\* organisation. All data is \*\*synthetic\*\*, created for portfolio practice.

\---

## Business problem

Asterwell runs 12 clinics across the UK. Managers wanted to understand **waiting times, cancellations and revenue**, but the raw appointment data could not be trusted: it contained duplicates, missing values, impossible dates and inconsistent spellings.

**Goal:** clean and validate the data, then build reliable reporting that helps managers decide where to act.

\---

## Workflow

```
Raw Data -> Profiling -> Validation -> SQL Database -> Transformation (Power Query)
-> Power BI Model -> DAX Measures -> Dashboard -> Insight Summary -> Recommendation -> Management Pack
```

|Stage|Tool|What I did|
|-|-|-|
|Profiling and validation|Excel / Google Sheets|Profiled 15,300 records, flagged problems with formulas, removed 820 rows with documented reasons|
|Database and analysis|SQL Server|Built a 6-table database and answered 36 business questions (JOINs, CTEs, window functions)|
|Transformation and model|Power BI (Power Query)|Cleaned data, built a star schema with a date table and 7 relationships|
|Measures and dashboard|Power BI (DAX)|Wrote 29 measures and designed a 6-page dashboard|
|Communication|Management paper|Investigated a rise in waiting times and made recommendations|

\---

## Key findings

* **Data quality:** 15,300 raw records = 14,480 clean + 820 removed (reconciled). 0 duplicate IDs remain; 99.0% of appointments have a known clinic.
* **Cancellations:** the overall rate is 14.4%. Bristol Harbour is highest (16.5%) and Leicester Central lowest (12.6%).
* **Waiting times:** the typical (median) wait is 14 days; the average is 17.4 days because the distribution is right-skewed. 411 appointments (2.8%) waited longer than the 48-day target.
* **Testing a link:** Bristol has both long waits and high cancellations, but across all 12 clinics the correlation is almost zero (r = -0.03), so long waits are not shown to cause cancellations.
* **Revenue:** £790,262 from private payments; Specialist services bring about 61%.
* **March 2026 investigation:** the average wait rose from 17.0 to 18.3 days, mainly in Physiotherapy (+5.6 days), but stayed within the normal 18-month range.

\---

## Dashboard

|Page|Purpose|
|-|-|
|Executive Overview|Is Asterwell healthy right now?|
|Patient Flow|What happens to appointments, and where do patients come from?|
|Waiting Times|Are patients waiting too long, and where?|
|Clinic Performance|Which clinics need attention?|
|Service Performance|Which services perform well, and where does revenue come from?|
|Data Quality|Can we trust these numbers?|

!\[Executive Overview](04\_powerbi/01\_executive\_overview.png)

More screenshots are in the [04\_powerbi](04_powerbi) folder.

\---

## Repository structure

```
01\_data/            Raw and clean data (synthetic)
02\_excel/           Week 1 profiling, cleaning and validation workbook
03\_sql/             Database setup script and analysis queries
04\_powerbi/         Power BI file, dashboard PDF, screenshots, star schema
05\_documentation/   Business requirements, model explanation, DAX register, KPI dictionary
06\_reports/         Management paper
```

\---

## Documentation

|Document|Where|
|-|-|
|Business requirements|[05\_documentation/01\_Business\_Requirements.md](05_documentation/01_Business_Requirements.md)|
|Data model explanation|[05\_documentation/02\_Model\_Explanation.md](05_documentation/02_Model_Explanation.md)|
|DAX register (29 measures)|[05\_documentation/03\_DAX\_Register.md](05_documentation/03_DAX_Register.md)|
|KPI dictionary|05\_documentation/RB\_KPI\_Dictionary.xlsx|
|Data dictionary and data-quality report|Tabs in 02\_excel/RB\_Week1\_My\_Work.xlsx|
|SQL scripts|03\_sql folder|
|Findings, recommendations, limitations|06\_reports/RB\_Management\_Paper\_Waiting\_Times.pdf|

\---

## How to reproduce

1. Install **SQL Server Express** and **SSMS** (free).
2. Open `03\_sql/Asterwell\_SQLServer\_Setup.sql` in SSMS and press **F5**. This creates the Asterwell database.
3. Open `04\_powerbi/RB\_Asterwell\_Dashboard.pbix` in **Power BI Desktop**.
4. If asked, set the server to `localhost` and the database to `Asterwell`, then click **Refresh**.

\---

## Tools and skills

Excel / Google Sheets (COUNTIFS, XLOOKUP, INDEX/MATCH, pivot tables, data validation) · SQL Server (GROUP BY, JOINs, CTEs, window functions) · Power Query · Power BI data modelling (star schema) · DAX (CALCULATE, time intelligence, RANKX) · Statistics (distributions, correlation vs causation) · Business communication (KPI dictionary, management paper)

\---

## Limitations

* The data is synthetic, so findings demonstrate method, not real performance.
* There is no urgent/routine flag or staffing data, so causes of changes cannot be confirmed.
* Waiting time is measured from booking, not referral. The 48-day target is an assumption.

\---

## What I learned

*This was my first full data project. I learned how to check raw data, find problems like duplicates and missing values, and clean it step by step. I also learned SQL and Power BI, and how to build a dashboard from start to finish.*



*The hardest part for me was understanding DAX, especially filter context. I made mistakes, but fixing them helped me understand better.*



*One thing that surprised me was that Bristol Harbour had both long waits and high cancellations, but when I checked all 12 clinics, there was no real link. This taught me to always check the data before making a conclusion.*

\---

## Author

**Ruchitha** · Data / BI Analyst
[LinkedIn: linkedin.com/in/ruchitha-bejugam](https://www.linkedin.com/in/ruchitha-bejugam)

