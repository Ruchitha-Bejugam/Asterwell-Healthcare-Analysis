# DAX Register

**Project:** Asterwell Healthcare Analytics  
**Location in Power BI:** all measures are in the `_Measures` table.  
**Results:** all years, no filters (unless stated).

A DAX register lists every measure, its exact formula, format and purpose, so another analyst can understand, check and maintain the dashboard.

| # | Measure | DAX formula | Format | Purpose | Result |
|---|---|---|---|---|---|
| 1 | Total Appointments | `COUNTROWS(Fact_Appointments)` | Whole number | Count of appointments (demand) | 14,480 |
| 2 | Completed Appointments | `CALCULATE([Total Appointments], Fact_Appointments[Status] = "Completed")` | Whole number | Care delivered | 10,060 |
| 3 | Cancelled Appointments | `CALCULATE([Total Appointments], Fact_Appointments[Status] = "Cancelled")` | Whole number | Lost capacity | 2,092 |
| 4 | DNA Appointments | `CALCULATE([Total Appointments], Fact_Appointments[Status] = "DNA")` | Whole number | Missed without notice | 1,161 |
| 5 | Cancellation Rate | `DIVIDE([Cancelled Appointments], [Total Appointments])` | % (1 dp) | Share of appointments cancelled | 14.4% |
| 6 | DNA Rate | `DIVIDE([DNA Appointments], [Total Appointments])` | % (1 dp) | Share not attended | 8.0% |
| 7 | Average Waiting Days | `AVERAGE(Fact_Appointments[Waiting_Days])` | Decimal (1 dp) | Average wait | 17.4 |
| 8 | Median Waiting Days | `MEDIAN(Fact_Appointments[Waiting_Days])` | Whole number | Typical wait (skew-resistant) | 14 |
| 9 | SLA Breach Count | `CALCULATE([Total Appointments], Fact_Appointments[Waiting_Days] > 48)` | Whole number | Waits over the 48-day target | 411 |
| 10 | SLA Breach Rate | `DIVIDE([SLA Breach Count], [Total Appointments])` | % (1 dp) | Share over target | 2.8% |
| 11 | Total Revenue | `SUM(Fact_Transactions[Amount])` | £ (2 dp) | Private-payment income | £790,262.00 |
| 12 | Average Transaction Value | `DIVIDE([Total Revenue], COUNTROWS(Fact_Transactions))` | £ (2 dp) | Typical spend per payment | £121.58 |
| 13 | Customer Count | `DISTINCTCOUNT(Fact_Transactions[Patient_ID])` | Whole number | Paying customers | 1,825 |
| 14 | Unique Patients | `DISTINCTCOUNT(Fact_Appointments[Patient_ID])` | Whole number | Patients seen | 7,218 |
| 15 | Repeat Customers | `COUNTROWS(FILTER(VALUES(Fact_Transactions[Patient_ID]), CALCULATE(COUNTROWS(Fact_Transactions)) > 1))` | Whole number | Customers with 2+ purchases | 1,317 |
| 16 | Repeat Customer Rate | `DIVIDE([Repeat Customers], [Customer Count])` | % (1 dp) | Loyalty | 72.2% |
| 17 | Appointments (All Clinics) | `CALCULATE([Total Appointments], ALL(Dim_Clinic))` | Whole number | Total ignoring clinic filter | 14,480 |
| 18 | % of Total Appointments | `DIVIDE([Total Appointments], [Appointments (All Clinics)])` | % (1 dp) | Clinic share of total | Bristol 8.0% |
| 19 | Cancellation Rate vs Average | `[Cancellation Rate] - CALCULATE([Cancellation Rate], ALL(Dim_Clinic))` | % (1 dp) | Variance from overall rate | Bristol +2.0% |
| 20 | Appointments Last Month | `CALCULATE([Total Appointments], DATEADD(Dim_Date[Date], -1, MONTH))` | Whole number | Previous month's count | Mar 2025: 729 |
| 21 | MoM Growth % | `VAR ThisMonth = [Total Appointments] VAR LastMonth = [Appointments Last Month] RETURN IF(ISBLANK(ThisMonth), BLANK(), DIVIDE(ThisMonth - LastMonth, LastMonth))` | % (1 dp) | Month-on-month change | Mar 2025: +10.8% |
| 22 | Revenue YTD | `TOTALYTD([Total Revenue], Dim_Date[Date])` | £ | Year-to-date revenue | Dec 2025: £532,905 |
| 23 | Revenue Last Year | `IF(ISBLANK([Total Revenue]), BLANK(), CALCULATE([Total Revenue], SAMEPERIODLASTYEAR(Dim_Date[Date])))` | £ | Same period last year | Jan 2026: £45,545 |
| 24 | Clinic Rank | `IF(HASONEVALUE(Dim_Clinic[Clinic_Name]), RANKX(ALL(Dim_Clinic[Clinic_Name]), [Total Appointments], , DESC, Dense))` | Whole number | Rank by appointments | Nottingham North = 1 |
| 25 | Cancellation Rank | `RANKX(ALL(Dim_Clinic[Clinic_Name]), [Cancellation Rate], , DESC, Dense)` | Whole number | Rank by cancellation rate | Bristol Harbour = 1 |
| 26 | Duplicate Appointment IDs | `COUNTROWS(Fact_Appointments) - DISTINCTCOUNT(Fact_Appointments[Appointment_ID])` | Whole number | Data-quality check | 0 |
| 27 | Unknown Clinic Appointments | `CALCULATE([Total Appointments], Dim_Clinic[Clinic_ID] = "C00")` | Whole number | Appointments with no clinic | 150 |
| 28 | Clinic Completeness % | `1 - DIVIDE([Unknown Clinic Appointments], [Total Appointments])` | % (1 dp) | Share with a known clinic | 99.0% |
| 29 | Patients Never Booked | `COUNTROWS(Dim_Customer) - [Unique Patients]` | Whole number | Registered, never booked | 250 |

---

## Notes for maintainers

- Measures build on each other: for example, Cancellation Rate uses Cancelled Appointments and Total Appointments. Changing a base measure updates every measure that uses it.
- Time-intelligence measures (20-23) need `Dim_Date` marked as the date table, and must be used with `Dim_Date` columns in visuals.
- `DIVIDE` is used instead of `/` to avoid divide-by-zero errors.
- Measures 21 and 23 return blank for months with no data, to avoid misleading values such as -100%.
- The 48-day SLA target (measures 9-10) is an assumption for this practice project.
- When adding a new measure, add a row to this register.