# Data Model Explanation

**Project:** Asterwell Healthcare Analytics  
**Tool:** Power BI Desktop, connected to SQL Server (`localhost`, database `Asterwell`, Import mode)

---

## 1. Model design: a star schema

The model uses a **star schema**: two **fact tables** (events) in the middle, connected to four **dimension tables** (descriptions) around them.

![Star schema](../04_powerbi/star_schema.png)

**Why a star schema?**
- Names (like clinic names) are stored once, so they cannot be misspelt in thousands of rows.
- The model is easy to understand and maintain.
- Filters work correctly: one date or service filter can control both fact tables.

---

## 2. Tables

| Table | Type | Rows | One row per | Key columns |
|---|---|---|---|---|
| Fact_Appointments | Fact | 14,480 | Appointment | Appointment_ID, Patient_ID, Clinic_ID, Service_ID, Appointment_Date, Status, Waiting_Days, Wait_Band |
| Fact_Transactions | Fact | 6,500 | Private payment | Transaction_ID, Patient_ID, Service_ID, Transaction_Date, Amount |
| Dim_Clinic | Dimension | 13 | Clinic (incl. C00 Unknown) | Clinic_ID, Clinic_Name, Region |
| Dim_Service | Dimension | 8 | Service | Service_ID, Service_Name, Category |
| Dim_Customer | Dimension | 7,468 | Patient | Patient_ID, Gender, Postcode_Area |
| Dim_Date | Dimension (date table) | 730 | Day (2025-2026) | Date, Year, Month_Name, Month_Year, Quarter, Weekday |
| _Measures | Measure table | - | - | Holds all 29 DAX measures |

---

## 3. Relationships

All relationships are **one-to-many**, **single direction** (dimension filters fact) and **active**.

| # | From (one side) | To (many side) |
|---|---|---|
| 1 | Dim_Clinic[Clinic_ID] | Fact_Appointments[Clinic_ID] |
| 2 | Dim_Service[Service_ID] | Fact_Appointments[Service_ID] |
| 3 | Dim_Customer[Patient_ID] | Fact_Appointments[Patient_ID] |
| 4 | Dim_Date[Date] | Fact_Appointments[Appointment_Date] |
| 5 | Dim_Service[Service_ID] | Fact_Transactions[Service_ID] |
| 6 | Dim_Customer[Patient_ID] | Fact_Transactions[Patient_ID] |
| 7 | Dim_Date[Date] | Fact_Transactions[Transaction_Date] |

Booking_Date is **not** related to Dim_Date, so time analysis is always by appointment date.

---

## 4. Power Query transformations

| Step | Table | Why |
|---|---|---|
| Renamed tables (Fact_ / Dim_) | All | Shows each table's role |
| Checked data types | All | Wrong types break calculations |
| Appended a C00 "Unknown" row | Dim_Clinic | So appointments with no clinic show "Unknown", not "(Blank)" |
| Replaced null Clinic_ID with C00 | Fact_Appointments | Every appointment links to a clinic |
| Removed duplicates on keys | Fact_Appointments, Dim_Clinic | Protects the model; dimension keys must be unique |
| Added Wait_Band (conditional column) | Fact_Appointments | Groups waits into 5 bands |
| Added Appointment_Month | Fact_Appointments | Month column for trends |

Validation: a Left Anti merge between Fact_Appointments and Dim_Clinic returned **0 rows**, confirming every appointment matches a clinic.

---

## 5. Date table (Dim_Date)

Created with DAX (`CALENDAR` + `ADDCOLUMNS`) for every day in 2025 and 2026.

- Marked as the **date table** (needed for time intelligence such as year-to-date).
- Month_Name sorted by Month_No; Month_Year sorted by YearMonth_No; Weekday sorted by Weekday_no.
- Year and number columns set to "Don't summarize".

---

## 6. How to maintain the model

- **New data:** load it into SQL Server, then click **Refresh** in Power BI. All Power Query steps re-run automatically.
- **New dates:** extend the CALENDAR end date in Dim_Date if data goes beyond December 2026.
- **New clinic or service:** add it to the SQL table; the relationships pick it up automatically.
- **Always use Dim_Date columns** (not fact-table date columns) in visuals, or time-intelligence measures will not work.
- **New measures:** create them in the _Measures table and add them to the DAX register.
