# Business Requirements

**Project:** Asterwell Healthcare Analytics  
**Prepared by:** Ruchitha  
**Note:** Asterwell Health & Services Ltd is fictional; all data is synthetic.

---

## 1. Business requirement (the why)

Asterwell needs **reliable reporting on waiting times, cancellations and revenue** across its 12 clinics, so managers can see where performance is slipping and decide where to act.

The existing appointment data cannot be trusted as it is, so it must first be **cleaned, validated and documented**.

---

## 2. Stakeholders and their questions

| Stakeholder | What they need to know |
|---|---|
| Operations Director | Which clinics and services cancel the most? Are waits getting longer? Are we meeting the 48-day target? |
| Clinic managers | How does my clinic compare with others? How long are my patients waiting? |
| Finance Manager | Is revenue on track this year? Which services bring the most income? Are customers coming back? |
| Data/BI team | Can the data be trusted? Is every appointment linked to a clinic? |

---

## 3. Functional requirements (what the solution must do)

- Show headline KPIs: total appointments, cancellation rate, waiting times, SLA breach rate, revenue, repeat customer rate.
- Filter every page by **year** (and clinic region on the clinic page).
- Compare clinics and services side by side, highlighting exceptions (above or below average).
- Show trends by month, including month-on-month growth and year-to-date revenue.
- Show data-quality checks: control totals, duplicates and completeness.
- Refresh automatically when new data arrives (Power Query steps, SQL Server source).

---

## 4. Reporting requirements (how results are delivered)

| Item | Requirement |
|---|---|
| Format | Six-page Power BI dashboard, plus a one-page management paper for specific questions |
| Audience | Operations Director, clinic managers, Finance Manager |
| Frequency | Operational KPIs weekly; revenue monthly; data quality on every refresh |
| Level of detail | Executive summary first, then drill-down pages by clinic and service |
| Definitions | Every KPI defined in the KPI dictionary |

---

## 5. Key KPIs

Total Appointments · Cancellation Rate · DNA Rate · Average and Median Waiting Days · SLA Breach Rate · Total Revenue · Repeat Customer Rate · Clinic Completeness %

Full definitions, targets and thresholds are in the **KPI dictionary** (`RB_KPI_Dictionary.xlsx`).

---

## 6. Scope and assumptions

- **In scope:** appointments January 2025 to June 2026; 12 clinics; 8 services; private-payment transactions.
- **Out of scope:** NHS-funded revenue, staffing rotas, clinical outcomes.
- **Assumptions:** the 48-day waiting target and all KPI targets and thresholds are assumptions for this practice project. Waiting time is measured from booking to appointment.
