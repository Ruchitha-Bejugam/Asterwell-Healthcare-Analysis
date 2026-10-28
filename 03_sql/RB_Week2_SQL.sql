SELECT * from Asterwell;

SELECT COUNT(*) AS Total_Appointments FROM appointments;

SELECT * from clinics;
SELECT Clinic_Name, Region from Clinics;
SELECT Top 10 * from clinics;
Select Top 10 * from appointments;

select clinic_name, region
from clinics
where region = 'East Midlands';

Select Top 10 Appointment_id, waiting_days
from appointments
where waiting_days>48;

select appointment_id, status, waiting_days
from appointments
where status = 'cancelled' AND waiting_days>60;

select appointment_id, status, waiting_days
from appointments
where status = 'cancelled' OR status='dna';

select top 10 appointment_id, clinic_id, waiting_days
from appointments
order by waiting_days desc;

select distinct status from appointments;

select distinct region 
from clinics
order by region;

select top 5 appointment_id, appointment_date
from appointments
where status = 'DNA' and Clinic_ID='C02'
order by appointment_date desc;

-- How many appointments are there in total?
select 
	count(*) as Total_Appointments,
	count(distinct patient_id) as Unique_Patients,
	count(clinic_id) as Appointments_with_clinic
from appointments;

-- How many appointments are there in each status?
Select status, 
	count(*) as Appointments
	from appointments
	group by status
	order by Appointments desc;

-- Which clinic has the most appointments?
select clinic_id,
	count(*) as Appointments
	from appointments
	group by clinic_id
	order by Appointments desc;

-- Print clinic_ids where appointments are greater than or equals to 1223?
select clinic_id,
	count(*) as Appointments
	from appointments
	group by clinic_id
	having count(*)>=1223
	order by Appointments desc;


-- Avg waiting days?
select avg(waiting_days) as AvgWait from appointments;

-- Average, minimum and maximum waiting time?
select 
	cast(avg(waiting_days*1.0) as decimal(5,1)) as Avg_Wait,
	min(waiting_days) as Min_Wait,
	max(waiting_days) as Max_Wait
	from appointments;

--Which clinic has the longest average wait?
select clinic_id,
	cast(avg(waiting_days * 1.0) as decimal(5,2)) as Avg_Wait
	from appointments
	group by clinic_id
	order by Avg_Wait desc;

--Which clinic has most cancellations?
select clinic_id,
	count(*) as Cancellations
	from appointments
	where status = 'cancelled'
	group by clinic_id
	order by cancellations desc;

--Which clinics handles more than 1200 appointments?
select clinic_id,
	count(*) as Appointments
	from appointments
	group by clinic_id
	having count(*) > 1200
	order by appointments desc;

--How much revenue came from each payment method?
--use transaction table
select * from transactions;

select payment_method,
	count(*) as Transactions,
	sum(amount) as Total_Revenue
from transactions
group by payment_method
order by total_revenue desc;

--Which service id has most important appointments and how many?
select * from appointments;

select service_id,
	count(*) as Appointments
	from appointments
	group by Service_ID
	order by appointments desc;

select count(clinic_id) from appointments;


--How are waiting times spread out?
select count(*) as Appointments,
	(CASE
		WHEN Waiting_Days <= 7  THEN '1. 0-7 days'
        WHEN Waiting_Days <= 14 THEN '2. 8-14 days'
        WHEN Waiting_Days <= 28 THEN '3. 15-28 days'
        WHEN Waiting_Days <= 48 THEN '4. 29-48 days'
        ELSE '5. Over 48 days (outlier)'
	END) as Wait_Band
from appointments
group by 
	(CASE
		WHEN Waiting_Days <= 7  THEN '1. 0-7 days'
        WHEN Waiting_Days <= 14 THEN '2. 8-14 days'
        WHEN Waiting_Days <= 28 THEN '3. 15-28 days'
        WHEN Waiting_Days <= 48 THEN '4. 29-48 days'
        ELSE '5. Over 48 days (outlier)'
	END)
order by wait_band;


--What is each clinics cancellation rate?
select clinic_id,
	count(*) as Appointments,
	sum(case
			when status = 'cancelled' then 1
			else 0
		end) as Cancelled,
	cast(sum(case
			when status = 'cancelled' then 1
			else 0
		end) * 100.0 / count(*) as decimal(5,2)) as Cancel_Rate
from appointments
group by clinic_id
order by cancel_rate desc;

--How many appointments have no clinic?
select count(*) as No_Clinic
from appointments
where clinic_id is null;

select * from employees;

--How many appointments are there each month?
select 
	year(appointment_date) as Appyr,
	month(appointment_date) as Appmn,
	count(*) as Appointments
	from appointments
	group by year(appointment_date), month(appointment_date)
	order by Appyr, Appmn;

--Is waiting_days calculated correctly?
select count(*) as Mismatches
from appointments
where waiting_days <> datediff(day, booking_date,appointment_date);

--Are there any duplicate appointment_ids?
select appointment_id,
	count(*) as Dup
	from appointments
	group by appointment_id
	having count(*) > 1;


select top 5 patient_id,
	count(*) as appointments
	from appointments
	group by patient_id
	having count(*) > 5
	order by appointments desc;


--What is the overall cancellation rate?
select 
	cast(sum(case
		when status='cancelled' then 1
		else 0
		end) * 100.0 / count(*) as decimal(5,1)) as rate
from appointments;

----JOINS----

--Inner Join--
select top 10 
	a.appointment_id,
	a.status,
	a.clinic_id,
	c.clinic_name
from appointments as a
inner join clinics as c
on a.clinic_id = c.clinic_id
where a.status = 'cancelled' and c.clinic_name = 'bristol harbour'
order by a.appointment_id;


select
	c.clinic_name,
	count(*) as appointments
from appointments as a
inner join clinics as c
on a.clinic_id = c.clinic_id
group by 
	c.clinic_name
order by appointments desc;


select count(*) as Inner_Rows
from appointments a
inner join clinics as c
on a.clinic_id = c.clinic_id;


--Left Join--
select count(*) as Left_Rows
from appointments a
left join clinics as c
on a.clinic_id = c.clinic_id;

select 
	isnull(c.clinic_name, 'unknown') as Clinic,
	count(*) as appointments
from appointments as a
left join clinics as c
on a.clinic_id = c.clinic_id
group by isnull(c.clinic_name, 'unknown')
order by appointments desc;


-- Cancellation rate by clinic name and region
select c.clinic_name,
	c.region,
	count(*) as appointments,
	cast(sum(case
			when a.status = 'cancelled' then 1
			else 0
			end) * 100.0 / count(*) as decimal(5,1)) as Cancel_Rate
from appointments as a
inner join clinics as c
on a.clinic_id = c.clinic_id
group by c.clinic_name, c.region
order by Cancel_Rate desc;


-- Appointments per clinic, including the unknown?
select
	count(*) as Appointments,
	isnull(c.clinic_name, 'unknown') as Clinic
from appointments as a
left join clinics as c
on a.clinic_id = c.clinic_id
group by isnull(c.clinic_name, 'unknown')
order by appointments desc;


--Which patient never booked an appointment?
select 
	count(*) as Patients_Never_Booked
from patients as p
left join appointments as a
on p.patient_id = a.patient_id
where a.appointment_id is null;


--Find all bristol harbour's cancellations and for whic services
select 
	s.service_name,
	count(*) as Cancellations
from appointments as a
inner join clinics as c
on a.clinic_id = c.clinic_id
inner join services as s
on a.service_id = s.service_id
where c.clinic_name = 'bristol harbour' and a.status='cancelled'
group by s.service_name
order by cancellations desc;

--Revenue by service category
select s.category,
	count(*) as Transactions,
	sum(t.amount) as Revenue
from transactions as t
inner join services as s
on t.service_id = s.service_id
group by s.Category
order by revenue desc;


---CTE---
--Which clinics have a cancellation rate above the overall average(14.4%)?
With Clinicrate as (
	select 
		clinic_id,
		sum(case
				when status = 'cancelled' then 1
				else 0
			end) * 100.0 / count(*) as cancel_rate
	from appointments
	where clinic_id is not null
	group by clinic_id),
Overallrate as (
	select
		sum(case
				when status = 'cancelled' then 1
				else 0
			end) * 100.0 / count(*) as overall_rate
	from appointments
)
select 
	c.clinic_name,
	cast(r.cancel_rate as decimal(5,1)) as Cancel_Rate_Per,
	cast(o.overall_rate as decimal(5,1)) as Overall_Rate_Per
from clinicrate as r
inner join clinics as c
on r.clinic_id = c.clinic_id
cross join overallrate as o
where r.cancel_rate > o.overall_rate
order by r.cancel_rate desc;

-- show clinics name and avg waiting days, longest first?
select
	isnull(c.clinic_name, 'unknown') as Clinic,
	cast(avg(a.waiting_days * 1.0) as decimal(5,1)) as Avg_Wait
from appointments as a
left join clinics as c
on a.clinic_id = c.clinic_id
group by isnull(c.clinic_name, 'unknown')
order by Avg_wait desc;


--Ranking--
--Rank the clinics by number of appointments?
select
	c.clinic_name,
	count(*) as Appointments,
	Rank() over (order by count(*) desc) as Rank_St,
	dense_rank() over (order by count(*) desc) as Rank_Dense,
	row_number() over(order by count(*) desc) as Row_Num
from appointments as a
inner join clinics as c
on a.clinic_id = c.clinic_id
group by c.clinic_name
order by appointments desc;

--What is the most popular service at each clinic?
with Servicecte as(
select 
	c.clinic_name,
	s.service_name,
	count(*) as Appointments,
	row_number() over (partition by c.clinic_name 
	order by count(*) desc) as Rank_in_Clinic
from appointments as a
inner join clinics as c
on a.clinic_id = c.clinic_id
inner join services as s
on a.service_id = s.service_id
group by c.clinic_name, s.service_name)
select clinic_name,
	service_name, 
	appointments
from servicecte
where rank_in_clinic = 1
order by clinic_name;


--Monthly appointments and month-on-month growth
with monthcte as (
	select 
	DATEFROMPARTS(year(appointment_date), month(appointment_date),1) as Month_start,
	count(*) as Appointments
	from appointments
	group by DATEFROMPARTS(year(appointment_date), month(appointment_date),1)
)
select 
	month_start,
	appointments,
	lag(appointments) over (order by month_start) as Previoud_Month,
	cast((appointments - lag(appointments) over(order by month_start)) * 100.0
	/ lag(appointments) over (order by month_start) as decimal(5,1)) as growth_perc
	from monthcte
	order by month_start;

--monthly revenue and running total?
with monthlyrevenue as (
select
	datefromparts(year(transaction_date), month(transaction_date), 1) as Month_Start,
	sum(amount) as revenue
	from transactions
	group by datefromparts(year(transaction_date), month(transaction_date), 1))
select 
	month_start,
	revenue,
	sum(revenue) over (order by month_start) as Running_Total
	from Monthlyrevenue
	order by month_start;

--Rolling 3 month average of appointments
with rollingavgcte as (
select
	datefromparts(year(appointment_date), month(appointment_date),1) as Month_start,
	count(*) as appointments
	from appointments
	group by datefromparts(year(appointment_date), month(appointment_date),1))
select 
	month_start,
	appointments,
	cast(avg(appointments * 1.0) over (order by month_start 
	rows between 2 preceding and current row) as decimal(6,1)) as Rolling_Avg
	from rollingavgcte
	order by month_start;


--which services have highest cancellation rate?
select 
	s.service_name,
	count(*) as appointments,
	sum(case
		when status = 'cancelled' then 1 
		else 0
		end) as Cancelled,
	cast(sum(case
		when status = 'cancelled' then 1 
		else 0
		end) * 100.0 / count(*) as decimal(5,1)) as Rate
	from appointments as a
	inner join services as s
	on a.service_id = s.service_id
	group by s.service_name
	order by rate desc;
	
--which services breach the 48-day waiting threshold most often?
select 
	s.service_name,
	sum(case 
		when waiting_days>48 then 1 
		else 0
		end) as Breach,
	cast(sum(case 
		when waiting_days>48 then 1 
		else 0
		end) * 100.0 / count(*) as decimal(5,1)) as Rate
from appointments as a
inner join services as s
on a.service_id = s.service_id
group by s.service_name
order by rate desc;


--what is repeat patient volume?
with patientcte as (
	select 
	patient_id,
	count(*) as visits
	from appointments
	group by patient_id
)
select 
	count(*) as Total_Patients,
	sum(case 
		when visits > 1 then 1 
		else 0
		end) as Repeat_Patients,
	cast(sum(case 
		when visits > 1 then visits 
		else 0
		end) * 100.0 / sum(visits) as decimal(5,1)) as perc_of_App
from patientcte;

--customer ranking - which customer purchases most often?
select top 10 
	patient_id,
	count(*) as purchases,
	sum(amount) as total_spend,
	dense_rank() over (order by count(*) desc) as customer_rank
from transactions
group by patient_id
order by purchases desc, total_spend desc;

--Repeat purchase classification
with customercte as (
	select 
		patient_id,
		count(*) as purchases
	from transactions
	group by patient_id ),
classifiedcte as (
select 
	patient_id,
	purchases,
	(case 
		when purchases = 1 then 'one-time'
		when purchases <=3 then 'occasional'
		else 'loyal'
		end) as customer_type
from customercte)
select
	customer_type,
	count(*) as customers,
	sum(purchases) as total_purchases
from classifiedcte
group by customer_type
order by customer_type desc;

--which workforce departments have highest attrition?
-- attrition means % of staff left
select
	department,
	count(*) as staff,
	sum(case	
		when leave_date is not null then 1
		else 0
		end) as leavers,
	cast(sum(case	
		when leave_date is not null then 1
		else 0
		end) * 100.0 / count(*) as decimal(5,1)) as perct
from employees
group by department
order by perct desc;

--Attrition by tenure band
--tenure - how long someone has worked ther.
-- for leavers its measured up to their leave_date and for current staff 
--up to the end of data
with tenurecte as (
	select	
		employee_id,
		leave_date,
		datediff(month, start_date, isnull(leave_date, '2026-06-30')) as tenure_month
	from employees ),
bandedcte as (
select 
	(case
		when tenure_month < 12 then 'under 1 year'
		when tenure_month < 36 then '1-3 years'
		when tenure_month < 60 then '3-5 years'
		else '5+ years'
	end ) as tenure_band,
	leave_date
	from tenurecte )
select	
	tenure_band,
	count(*) as staff,
	sum(case	
		when leave_date is not null then 1
		else 0
		end) as leavers,
	cast(sum(case	
		when leave_date is not null then 1
		else 0
		end) * 100.0 / count(*) as decimal(5,1)) as perct
	from bandedcte
	group by tenure_band
	order by tenure_band desc;

--which referral source has highest dna rate?
select 
	referral_source,
	cast(sum(case 
		when status = 'dna' then 1
		else 0
		end) * 100.0 / count(*) as decimal(5,1)) as dna_rate
	from appointments
	group by referral_source
	order by dna_rate desc;

-- whats the average transaction amount for each payment method?
select
	payment_method,
	cast(avg(amount) as decimal (5,2)) as avg_amount
from transactions
group by payment_method
order by avg_amount desc;




-- =====================================================================
-- VALIDATION SUMMARY: every major SQL result checked a second way
-- =====================================================================
-- Result                        | SQL answer  | Second method                          | Match
-- ------------------------------|-------------|----------------------------------------|------
-- Total appointments            | 14,480      | Excel Clean_Data row count             | YES
-- Appointments with a clinic    | 14,330      | Excel region table (SUMIFS) total      | YES
-- Missing clinics (IS NULL)     | 150         | INNER JOIN vs LEFT JOIN difference     | YES
-- Status totals (Q2)            | sum 14,480  | Total appointments                     | YES
-- Bristol Harbour cancellations | 192 (16.5%) | Excel Analysis sheet (COUNTIFS)        | YES
-- Overall cancellation rate     | 14.4%       | Excel Week 1 result                    | YES
-- Average / max wait            | 17.4 / 108  | Excel Outliers sheet (AVERAGE, MAX)    | YES
-- Median wait (PERCENTILE_CONT) | 14          | Excel MEDIAN                           | YES
-- Waits over 48 days            | 411         | Q9 band + Q27 total + Excel Outliers   | YES
-- Duplicate Appointment_IDs     | 0 rows      | Excel Quality_Summary (0 duplicates)   | YES
-- Waiting_Days vs dates (Q13)   | 0 mismatch  | DATEDIFF recalculation                 | YES
-- Unique patients               | 7,218       | Q28 repeat-patient CTE total           | YES
-- Total revenue                 | 790,262.00  | Q24 running total, final month         | YES
-- Transactions by customer type | sum 6,500   | COUNT(*) FROM transactions             | YES
-- =====================================================================
	
/*
   VALIDATION SUMMARY

   Before trusting any SQL result, I checked it a second way - either
   against my Week 1 Excel workbook or with a different SQL query.
   These are the checks I did and what I found.

   1. Row counts
   My appointments table has 14,480 rows. This is the same as my
   Clean_Data sheet in Excel, so nothing was lost when I loaded the
   data into SQL Server.

   2. The 150 missing clinics
   COUNT(*) gave 14,480 but COUNT(Clinic_ID) gave 14,330. At first
   I wasn't sure why, then I realised COUNT(column) skips NULLs.
   I confirmed it three ways: WHERE Clinic_ID IS NULL returned 150,
   the LEFT JOIN had 150 more rows than the INNER JOIN, and 14,330
   matched my region total in Excel.

   3. Cancellations
   Bristol Harbour came out highest at 192 cancellations (16.5%) and
   the overall rate was 14.4%. Both match my Excel COUNTIFS results
   from Week 1 exactly.

   4. Waiting times
   My first average came out as 17, which looked wrong because Excel
   said 17.4. The problem was SQL Server averaging whole numbers, so I
   multiplied by 1.0 first and got 17.4. The maximum (108) and the
   median (14, using PERCENTILE_CONT) also match my Excel Outliers sheet.

   5. Outliers
   I counted 411 waits over 48 days in three separate places: the wait
   bands in Q9, the total of the breaches column in Q27, and my Excel
   Outliers sheet. All three agreed.

   6. Duplicates
   Grouping by Appointment_ID with HAVING COUNT(*) > 1 returned no
   rows, which confirms my Week 1 cleaning removed every duplicate.

   7. Waiting_Days calculation
   I recalculated the wait for every row using DATEDIFF between the
   booking and appointment dates. There were 0 mismatches, so the
   Waiting_Days column is consistent with the dates.

   8. Revenue
   The final running total in Q24 was 790,262.00, which is the same
   as a simple SUM(Amount) on the transactions table.

   9. Totals that should add up
   My status groups (Q2) add up to 14,480, my customer groups (Q30)
   add up to 6,500 transactions, and my repeat-patient query (Q28)
   found 7,218 patients - the same as COUNT(DISTINCT Patient_ID).

   Summary: every major result matched its second check. The two
   things that caught me out - the integer average and the NULL
   clinics - taught me to always sense-check a number before
   reporting it.
 */